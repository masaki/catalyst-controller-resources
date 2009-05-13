package # hide from PAUSE
    Catalyst::Controller::Resources::ActionRole::MethodMatch;

use Moose::Role;
use namespace::clean -except => ['meta'];

around 'match' => sub {
    my ($next, $self, $c) = @_;

    # check Method('...') attribute
    if (exists $self->attributes->{Method}) {
        my $request = uc($c->req->method) eq 'HEAD' ? 'GET' : uc($c->req->method);
        my $method  = $self->attributes->{Method}->[0] || '';
        return unless uc($method) eq $request;
    }

    $next->($self, $c);
};

1;
