package Catalyst::Controller::Resources;

use strict;
use warnings;
use base 'Catalyst::Controller';
use attributes ();
use String::CamelCase ();
use Class::C3;
use Catalyst::Action;
use Catalyst::ActionChain;
#use Catalyst::DispatchType::Chained;

our $VERSION = '0.01';

{
    package Catalyst::Action;
    no warnings 'redefine';

    *match = sub {
        my ($self, $c) = @_;

        # Method('...') attribute hack
        if (exists $self->attributes->{Method}) {
            my $request = uc($c->req->method) eq 'HEAD' ? 'GET' : uc($c->req->method);
            my $method  = $self->attributes->{Method}->[0] || '';
            return unless uc($method) eq $request;
        }

        return 1 unless exists $self->attributes->{Args};
        my $args = $self->attributes->{Args}->[0];
        return 1 unless defined($args) && length($args);
        return scalar( @{ $c->req->args } ) == $args;
    };
}

{
    package Catalyst::ActionChain;
    no warnings 'redefine';

    *dispatch = sub {
        my ($self, $c) = @_;
        my @captures = @{ $c->req->captures || [] };
        my @chain = @{ $self->chain };
        my $last = pop @chain;
        for my $action (@chain) {
            my @args;
            if (my $cap = $action->attributes->{CaptureArgs}) {
                @args = splice(@captures, 0, $cap->[0]);
            }
            local $c->req->{arguments} = \@args;
            $action->dispatch($c);
        }

        # for resource arguments
        local $c->req->{arguments} = $c->req->captures || []
            if exists $last->attributes->{Collection}
            or exists $last->attributes->{Member};
        $last->dispatch($c);
    };
}

sub _parse_PathPrefix_attr {
    my ($self, $c) = @_;
    return PathPart => $self->path_prefix;
}

sub _parse_BelongsTo_attr {
    my ($self, $c) = @_;

    my $prefix = String::CamelCase::decamelize($self->{belongs_to});
    if (my $controller = $c->controller($self->{belongs_to})) {
        $prefix = $controller->path_prefix;
    }
    return Chained => "/$prefix/member";
}

our %ResourceMap = (
    list   => { resource => 'Collection', method => 'GET',    path => '' },
    create => { resource => 'Collection', method => 'POST',   path => '' },
    show   => { resource => 'Member',     method => 'GET',    path => '' },
    update => { resource => 'Member',     method => 'PUT',    path => '' },
    delete => { resource => 'Member',     method => 'DELETE', path => '' },
    post   => { resource => 'Collection', method => 'GET',    path => 'new' },
    edit   => { resource => 'Member',     method => 'GET',    path => 'edit' },
);

sub new {
    my $self = shift->next::method(@_);
    $self->setup_resources;
    $self->setup_resource_actions;
    $self->setup_extra_actions;
    $self;
}

sub setup_resources {
    my $self  = shift;
    my $class = ref $self || $self;

    no strict 'refs';
    no warnings 'redefine';

    # belongs_to other resource controller
    if ($self->{belongs_to}) {
        *{"${class}::collection"} = sub :BelongsTo PathPrefix CaptureArgs(0) {};
        *{"${class}::member"}     = sub :BelongsTo PathPrefix CaptureArgs(1) {};
    }
    else {
        *{"${class}::collection"} = sub :Chained('/') PathPrefix CaptureArgs(0) {};
        *{"${class}::member"}     = sub :Chained('/') PathPrefix CaptureArgs(1) {};
    }
}

sub setup_resource_actions {
    my $self  = shift;
    my $class = ref $self || $self;

    while (my ($action, $attrs) = each %ResourceMap) {
        next unless my $code = $class->can($action);

        my ($resource, $method, $path) = @$attrs{qw(resource method path)};
        my $attrs = $self->_create_attributes($resource, $method, $path);
        attributes->import($class, $code, @$attrs);
    }
}

sub setup_extra_actions {
    my $self  = shift;
    my $class = ref $self || $self;

    for my $resource (qw( Collection Member )) {
        next unless my $map = delete $self->{lc $resource};
        $map = { $map => 'GET' } unless ref $map eq 'HASH';

        while (my ($action, $method) = each %$map) {
            next unless my $code = $self->can($action);

            my $attrs = $self->_create_attributes($resource, $method);
            attributes->import($class, $code, @$attrs);
        }
    }
}

sub _create_attributes {
    my ($self, $resource, $method, $path) = @_;

    my $chained = lc $resource;
    my @attrs = ("Chained($chained)", 'Args(0)', $resource, "Method($method)");
    push @attrs => (defined($path) ? "PathPart('$path')" : 'PathPart');
    \@attrs;
}

1;

=head1 NAME

Catalyst::Controller::Resources - resource-based controller

=head1 SYNOPSIS

  package MyApp::Controller::Foo;
  use base 'Catalyst::Controller::Resource';

  # GET /foo
  sub list {
      my ($self, $c) = @_;
      ...
  }

  # POST /foo
  sub create { ... }

  # GET /foo/{foo_id}
  sub show {
      my ($self, $c, $foo_id) = @_;
      ...
  }

  # PUT /foo/{foo_id}
  sub update { ... }

  # DELETE /foo/{foo_id}
  sub delete { ... }

nested resource:

  package MyApp::Controller::User;
  use base 'Catalyst::Controller::Resource';

  ...

  package MyApp::Controller::Article;
  use base 'Catalyst::Controller::Resource';

  __PACKAGE__->config(belongs_to => 'User');

  # GET /user/{user_id}/article
  sub list {
      my ($self, $c, $user_id) = @_;
      ...
  }

  # GET /user/{user_id}/article/{article_id}
  sub show {
      my ($self, $c, $user_id, $article_id) = @_;
      ...
  }

=head1 DESCRIPTION

Catalyst::Controller::Resource

=head1 METHODS

=head2 new

=head2 setup_resources

=head2 setup_resource_actions

=head2 setup_extra_actions

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Controller>, L<Catalyst::Action>, L<Catalyst::ActionChain>

=cut
