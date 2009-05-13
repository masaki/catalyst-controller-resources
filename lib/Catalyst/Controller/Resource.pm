package # hide from PAUSE
    Catalyst::Controller::Resource;

use Moose;
use namespace::clean -except => ['meta'];
use attributes ();

BEGIN { extends 'Catalyst::Controller::ActionRole' }

__PACKAGE__->config(
    action_roles => ['+Catalyst::Controller::Resources::ActionRole::ResourceAction'],
);

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
        'ResourceEndpoint',
        'Args(0)',
        "Chained('$chained_from')",
        "Method('$map->{method}')",
        exists $map->{path} ? "PathPart('$map->{path}')" : 'PathPart',
    );
}

__PACKAGE__->meta->make_immutable;
