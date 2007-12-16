package Catalyst::Controller::Resources;

use strict;
use warnings;
use base 'Catalyst::Controller';
use attributes ();
use String::CamelCase ();
use Class::C3;
use Catalyst::Action;

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

sub path_prefix_underscore {
    my $self = shift;
    my $prefix = $self->path_prefix;
    $prefix =~ s!/!_!g;
    $prefix;
}

sub new {
    my $self = shift->next::method(@_);
    $self->setup_resources;
    $self->setup_resource_actions;
    $self->setup_extra_actions;
    $self;
}

sub create_action {
    my ($self, %attrs) = @_;

    for my $resource (qw( Collection Member )) {
        my $attrs = $attrs{attributes};
        my $extra = "BelongsTo${resource}";
        next unless exists $attrs->{$resource} or exists $attrs->{$extra};

        $attrs->{Chained}  = [lc $resource];
        $attrs->{Args}     = [0];
        $attrs->{PathPart} = [$attrs->{$extra} ? () : ('')];

        my $method = (delete $attrs->{$resource} || delete $attrs->{$extra} || [''])->[0];
        if ($method =~ /^(?:GET|POST|PUT|DELETE)$/) {
            $attrs->{Method} = [$method];
        }

        $attrs{attributes} = $attrs;
        last;
    }

    $self->next::method(%attrs);
}

sub setup_resources {
    my $self  = shift;
    my $class = ref $self || $self;

    no strict 'refs';
    no warnings 'redefine';

    # belongs_to other resource controller
    if ($self->{belongs_to}) {
        *{"${class}::collection"} = sub :BelongsTo PathPrefix CaptureArgs(0) {};
        *{"${class}::member"}     = sub :BelongsTo PathPrefix CaptureArgs(1) {
            my ($self, $c, $id) = @_;
            my $prefix = $self->path_prefix_underscore;
            $c->stash->{"${prefix}_id"} = $id;
        };
    }
    else {
        *{"${class}::collection"} = sub :Chained('/') PathPrefix CaptureArgs(0) {};
        *{"${class}::member"}     = sub :Chained('/') PathPrefix CaptureArgs(1) {
            my ($self, $c, $id) = @_;
            my $prefix = $self->path_prefix_underscore;
            $c->stash->{"${prefix}_id"} = $id;
        };
    }
}

sub setup_resource_actions {
    my $self  = shift;
    my $class = ref $self || $self;

    # Collection
    if (my $code = $class->can('list')) {
        attributes->import($class, $code, 'Collection(GET)');
    }
    if (my $code = $class->can('create')) {
        attributes->import($class, $code, 'Collection(POST)');
    }

    # Member
    if (my $code = $class->can('show')) {
        attributes->import($class, $code, 'Member(GET)');
    }
    if (my $code = $class->can('update')) {
        attributes->import($class, $code, 'Member(PUT)');
    }
    if (my $code = $class->can('delete')) {
        attributes->import($class, $code, 'Member(DELETE)');
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
            attributes->import($class, $code, "BelongsTo${resource}($method)");
        }
    }
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
      my ($self, $c) = @_;
      my $foo_id = $c->stash->{foo_id};
      ...
  }

  # PUT /foo/{foo_id}
  sub update { ... }

  # DELETE /foo/{foo_id}
  sub delete { ... }

nested resource:

  package MyApp::Controller::User;
  use base 'Catalyst::Controller::Resource';

  sub list   { ... } # GET /user
  sub create { ... } # POST /user
  sub show   { ... } # GET /user/{user_id}
  sub update { ... } # PUT /user/{user_id}
  sub delete { ... } # DELETE /user/{user_id}

  package MyApp::Controller::Article;
  use base 'Catalyst::Controller::Resource';

  __PACKAGE__->config(belongs_to => 'User');

  sub list   { ... } # GET /user/{user_id}/article
  sub create { ... } # POST /user/{user_id}/article
  sub show   { ... } # GET /user/{user_id}/article/{article_id}
  sub update { ... } # PUT /user/{user_id}/article/{article_id}
  sub delete { ... } # DELETE /user/{user_id}/article/{article_id}

=head1 DESCRIPTION

Catalyst::Controller::Resource

=head1 METHODS

=head2 new

=head2 create_action

=head2 path_prefix_underscore

=head2 setup_resources

=head2 setup_resource_actions

=head2 setup_extra_actions

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Controller>

=cut
