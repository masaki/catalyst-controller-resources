use strict;
use lib 't/lib';
use Test::More 'no_plan';
use HTTP::Request;
use Catalyst::Test 'TestApp';

ok( _req(GET => '/users')->is_success );
is( _req(GET => '/users')->content => 'users/list' );

ok( _req(POST => '/users')->is_success );
is( _req(POST => '/users')->content => 'users/create' );

ok( _req(GET => '/users/new')->is_success );
is( _req(GET => '/users/new')->content => 'users/post' );

ok( _req(GET => '/users/1')->is_success );
is( _req(GET => '/users/1')->content => 'users/show' );

ok( _req(PUT => '/users/1')->is_success );
is( _req(PUT => '/users/1')->content => 'users/update' );

ok( _req(DELETE => '/users/1')->is_success );
is( _req(DELETE => '/users/1')->content => 'users/destroy' );

ok( _req(GET => '/users/1/edit')->is_success );
is( _req(GET => '/users/1/edit')->content => 'users/edit' );

# extra actions
ok( _req(GET => '/users/login')->is_success );
is( _req(GET => '/users/login')->content => 'users/login' );

ok( _req(GET => '/users/1/feed')->is_success );
is( _req(GET => '/users/1/feed')->content => 'users/feed' );

sub _req { request(HTTP::Request->new(@_)) }
