package # hide from PAUSE
    Catalyst::Controller::Resources::Role::ParseAttributes;

use Moose::Role;
use namespace::clean -except => ['meta'];

requires qw(
    action_namespace
    path_prefix
    has_path_prefix
);

has '_belongs_to' => (
    is        => 'ro',
    isa       => 'Str',
    init_arg  => 'belongs_to',
    predicate => 'is_nested',
);

sub _parse_ResourceChained_attr {
    my ($self, $c, $name, $value) = @_;

    my $path = '/';
    if ($self->is_nested) {
        $path .= $c->controller($self->_belongs_to)->action_namespace($c) . '/_MEMBER';
    }

    return Chained => $path;
}

sub _parse_ResourcePathPart_attr {
    my ($self, $c, $name, $value) = @_;

    my $path;
    if ($self->is_nested and not $self->has_path_prefix) {
        $path = [ split m!/! => $self->action_namespace($c) ]->[-1];
    }
    else {
        $path = $self->path_prefix;
    }

    return PathPart => $path;
}

1;
