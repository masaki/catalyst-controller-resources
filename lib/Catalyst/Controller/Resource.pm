package Catalyst::Controller::Resource;

use strict;
use warnings;
use base 'Catalyst::Controller';
use attributes ();
use Class::C3 ();
use Catalyst::Action;
use Catalyst::ActionChain;

our $VERSION = '0.03';

{
    package # hide from PAUSE
        Catalyst::Action;
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
    package # hide from PAUSE
        Catalyst::ActionChain;
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
            if exists $last->attributes->{Resource};
        $last->dispatch($c);
    };
}

sub _parse_ResourceChained_attr {
    my ($self, $c, $name, $value) = @_;

    my $path = '/';
    if (exists $self->{belongs_to}) {
        my $parent = $c->controller($self->{belongs_to});
        my $action = $c->dispatcher->_invoke_as_component($c, $parent, 'member');
        $path .= join('/', $action->namespace, $action->name);
    }
    return Chained => $path;
}

sub _parse_PathPrefix_attr {
    my ($self, $c, $name, $value) = @_;
    return PathPart => $self->path_prefix;
}

sub new {
    my $self = shift->next::method(@_);

    if (exists $self->{belongs_to} and not exists $self->{path}) {
        $self->{path} = [ split m!/! => $self->path_prefix ]->[-1];
    }

    $self->setup_resources;
    $self->setup_collection_actions;
    $self->setup_member_actions;

    $self;
}

sub setup_resources {
    my $self = shift;
    my $class = ref $self || $self;

    no strict 'refs';

    my $collection = join '::' => $class, 'collection';
    *$collection = sub {} unless defined &$collection;
    attributes->import($class, \&$collection, $self->_collection_attributes);

    my $member = join '::' => $class, 'member';
    *$member = sub {} unless defined &$member;
    attributes->import($class, \&$member, $self->_member_attributes);

}

sub setup_actions {
    my ($self, $map_to, $maps) = @_;
    my $class = ref $self || $self;

    while (my ($action, $map) = each %$maps) {
        my $subname = join '::' => $class, $action;

        no strict 'refs';
        next unless defined &$subname;

        $map = { method => uc $map } unless ref($map) eq 'HASH';
        my @attrs = $self->_construct_action_attributes($map_to, $map);
        attributes->import($class, \&$subname, @attrs);
    }
}

sub _collection_attributes { qw/ResourceChained PathPrefix CaptureArgs(0)/         }
sub _member_attributes     { qw/Chained('collection') PathPart('') CaptureArgs(1)/ }

sub _construct_action_attributes {
    my ($self, $chained_from, $map) = @_;

    return (
        'Resource',
        'Args(0)',
        "Chained('$chained_from')",
        "Method('$map->{method}')",
        exists $map->{path} ? "PathPart('$map->{path}')" : 'PathPart',
    );
}

1;
