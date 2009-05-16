package # hide from PAUSE
    Catalyst::Controller::Resources::Role::BuildActions;

use Moose::Role;
use namespace::clean -except => ['meta'];
use attributes ();

has '_default_collection_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
    default  => sub { +{} },
);

has '_additional_collection_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => 'collection',
    default  => sub { +{} },
);

has '_collection_actions' => (
    is         => 'ro',
    isa        => 'HashRef',
    init_arg   => undef,
    lazy_build => 1,
);

sub _build__collection_actions {
    my $self = shift;
    return +{
        %{ $self->_default_collection_actions },
        %{ $self->_additional_collection_actions },
    };
}

has '_default_member_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
    default  => sub { +{} },
);

has '_additional_member_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => 'member',
    default  => sub { +{} },
);

has '_member_actions' => (
    is         => 'ro',
    isa        => 'HashRef',
    init_arg   => undef,
    lazy_build => 1,
);

sub _build__member_actions {
    my $self = shift;
    return +{
        %{ $self->_default_member_actions },
        %{ $self->_additional_member_actions },
    };
}

sub BUILD {
    my $self = shift;

    $self->_inject_action_attributes(_COLLECTION => $self->_collection_actions);
    $self->_inject_action_attributes(_MEMBER     => $self->_member_actions);
}

sub _inject_action_attributes {
    my ($self, $chained, $actions) = @_;
    my $meta = $self->meta;

    while (my ($name, $config) = each %$actions) {
        next unless $meta->has_method($name);

        unless (ref $config eq 'HASH') {
            $config = { path => $name, method => uc $config };
        }
        my $method = $config->{method} eq 'HEAD' ? 'GET' : $config->{method};
        my $path   = exists $config->{path} ? $config->{path} : $name;
        my $code   = $meta->get_method($name)->body;

        my @attrs = split /\s+/, qq/
            Chained('$chained')
            PathPart('$path')
            Args(0)
            ResourceEndpoint
            Method('$method')
        /;
        my @default_attrs = @{ $meta->get_method_attributes($code) || [] };
        if (@default_attrs) {
            unshift @attrs, @default_attrs;
        }

        attributes::->import($meta->name, $code, @attrs);
    }
}

1;
