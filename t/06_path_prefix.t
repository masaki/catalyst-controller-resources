use strict;
use lib 't/lib';
use Test::More 'no_plan';
use HTTP::Request;
use Catalyst::Test 'TestApp';

ok( _req(GET => '/users/masaki')->is_success );
is( _req(GET => '/users/masaki')->content => 'users/show' );

ok( _req(GET => '/users/masaki/20080401')->is_success );
is( _req(GET => '/users/masaki/20080401')->content => '(user, date) = (masaki, 20080401)' );

sub _req { request(HTTP::Request->new(@_)) }
