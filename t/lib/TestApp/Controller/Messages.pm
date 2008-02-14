package TestApp::Controller::Messages;

use strict;
use warnings;
use base 'Catalyst::Controller::Resources';

__PACKAGE__->config(belongs_to => 'Account');

sub list {}
sub post {}
sub create {}
sub show {}
sub update {}
sub destroy {}
sub edit {}

1;
