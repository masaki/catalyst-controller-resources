package TestApp::Resources::Controller::Users::Articles::Comments;

use strict;
use warnings;
use base 'Catalyst::Controller::Resources';

__PACKAGE__->config(belongs_to => 'Users::Articles');

sub list {}
sub post {}
sub create {}
sub show {}
sub update {}
sub destroy {}
sub edit {}
sub delete {}

1;
