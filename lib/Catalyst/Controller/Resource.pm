package # hide from PAUSE
    Catalyst::Controller::Resource;

use Moose;
use namespace::clean -except => ['meta'];
use attributes ();

BEGIN { extends 'Catalyst::Controller' }

sub BUILD {
    my $self = shift;

    $self->setup_collection_actions;
    $self->setup_member_actions;
}

sub setup_actions {
    my ($self, $map_to, $maps) = @_;
    my $class = ref $self || $self;

    while (my ($action, $map) = each %$maps) {
        next unless my $code = $class->can($action);
        $map = { method => uc $map } unless ref($map) eq 'HASH';

        my @attrs = $self->_construct_action_attributes($map_to, $map);
        unshift @attrs => @{ attributes::get($code) || [] };

        attributes->import($class, $code, @attrs);
    }
}

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

sub _parse_ResourceChained_attr {
    my ($self, $c, $name, $value) = @_;

    my $path = '/';
    if (my $parent = $self->{belongs_to}) {
        $path .= $c->controller($parent)->action_namespace . '/member';
    }

    return Chained => $path;
}

sub _parse_ResourcePath_attr {
    my ($self, $c, $name, $value) = @_;

    my $path;
    if (exists $self->{belongs_to} and not $self->has_path_prefix) {
        $path = [ split m!/! => $self->action_namespace ]->[-1];
    }
    else {
        $path = $self->path_prefix;
    }

    return PathPart => $path;
}

{
    require Catalyst::Action;
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
    require Catalyst::ActionChain;
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

__PACKAGE__->meta->make_immutable;
