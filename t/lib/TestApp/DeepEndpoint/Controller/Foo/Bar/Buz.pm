package TestApp::DeepEndpoint::Controller::Foo::Bar::Buz;
use strict;
use warnings;
use base 'Catalyst::Controller::Resources';

__PACKAGE__->config(belongs_to => 'Foo::Bar');

sub list {}
sub post {}
sub create {}
sub show {}
sub update {}
sub destroy {}
sub edit {}
sub delete {}

1;

