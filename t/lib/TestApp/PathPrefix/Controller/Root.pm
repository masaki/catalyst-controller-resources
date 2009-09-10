package TestApp::PathPrefix::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config(namespace => '');

sub default : Private {
    my ($self, $c) = @_;
    $c->res->status(404);
    $c->res->body('404 Not Found');
}

sub end : Private {
    my ($self, $c) = @_;
    $c->res->body($c->action) unless $c->res->body;
    $c->res->content_type('text/plain; charset=UTF-8');
}

1;
