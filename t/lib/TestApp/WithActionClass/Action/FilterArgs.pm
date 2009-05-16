package TestApp::WithActionClass::Action::FilterArgs;
use strict;
use warnings;
use base 'Catalyst::Action';
use MRO::Compat;

sub execute {
    my $self = shift;
    my ($controller, $c, @args) = @_;
    $c->res->header('X-Args' => join ', ', @args);
    $self->next::method($controller, $c, @args);
}

1;
