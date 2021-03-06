package TestApp::PathPrefix::Controller::Users;

use strict;
use warnings;
use base 'Catalyst::Controller::Resources';

__PACKAGE__->config(
    collection => { login => 'GET' },
    member     => { feed  => 'GET' },
);

sub list {}
sub post {}
sub create {}
sub show {}
sub update {}
sub destroy {}
sub edit {}
sub delete {}

sub login {}
sub feed {}

1;
