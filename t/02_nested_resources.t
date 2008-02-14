use strict;
use lib 't/lib';
use Test::More 'no_plan';
use HTTP::Request;
use Catalyst::Test 'TestApp';

ok( _req(GET => '/users/1/pages')->is_success );
is( _req(GET => '/users/1/pages')->content => 'pages/list' );

ok( _req(POST => '/users/1/pages')->is_success );
is( _req(POST => '/users/1/pages')->content => 'pages/create' );

ok( _req(GET => '/users/1/pages/new')->is_success );
is( _req(GET => '/users/1/pages/new')->content => 'pages/post' );

ok( _req(GET => '/users/1/pages/100')->is_success );
is( _req(GET => '/users/1/pages/100')->content => 'pages/show' );

ok( _req(PUT => '/users/1/pages/100')->is_success );
is( _req(PUT => '/users/1/pages/100')->content => 'pages/update' );

ok( _req(DELETE => '/users/1/pages/100')->is_success );
is( _req(DELETE => '/users/1/pages/100')->content => 'pages/destroy' );

ok( _req(GET => '/users/1/pages/100/edit')->is_success );
is( _req(GET => '/users/1/pages/100/edit')->content => 'pages/edit' );

sub _req { request(HTTP::Request->new(@_)) }
