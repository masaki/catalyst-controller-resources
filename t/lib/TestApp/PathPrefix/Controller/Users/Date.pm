package TestApp::PathPrefix::Controller::Users::Date;

use strict;
use warnings;
use base 'Catalyst::Controller::Resources';

__PACKAGE__->config(belongs_to => 'Users', path => '');

sub show {
    my ($self, $c, $name, $ymd) = @_;
    $c->res->body("(user, date) = ($name, $ymd)");
}

1;
