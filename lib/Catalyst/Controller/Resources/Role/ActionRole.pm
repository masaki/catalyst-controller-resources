package # hide from PAUSE
    Catalyst::Controller::Resources::Role::ActionRole;

use Moose::Role;
use Moose::Meta::Class;
use Class::MOP;
use namespace::clean -except => ['meta'];

requires 'create_action';

# taken from Catalyst::Controller::ActionRole
override 'create_action' => sub {
    my ($self, %args) = @_;

    my $class = exists $args{attributes}->{ActionClass}
        ? $args{attributes}->{ActionClass}->[0]
        : $self->_action_class;

    Class::MOP::load_class($class);
    my $role = 'Catalyst::Controller::Resources::ActionRole::ResourceAction';
    Class::MOP::load_class($role);

    my $meta = Moose::Meta::Class->initialize($class)->create_anon_class(
        superclasses => [$class],
        roles        => [$role],
        cache        => 1,
    );
    $meta->add_method(meta => sub { $meta });
    $class = $meta->name;

    return $class->new(\%args);
};

1;
