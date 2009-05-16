package TestApp::WithActionClass::Controller::Foo;
use strict;
use warnings;
use base 'Catalyst::Controller::Resources';

sub list {}
sub show :ActionClass('+TestApp::WithActionClass::Action::FilterArgs') {}

1;
