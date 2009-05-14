package # hide from PAUSE
    Catalyst::Controller::Resources::Role::ParseAttributes;

use Moose::Role;
use namespace::clean -except => ['meta'];

requires qw(
    action_namespace
    path_prefix
    has_path_prefix
);

sub _parse_ResourceChained_attr {
    my ($self, $c, $name, $value) = @_;

    my $path = '/';
    if (my $parent = $self->{belongs_to}) {
        $path .= $c->controller($parent)->action_namespace . '/_MEMBER';
    }

    return Chained => $path;
}

sub _parse_ResourcePathPart_attr {
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

1;
