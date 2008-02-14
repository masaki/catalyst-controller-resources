use strict;
use lib 't/lib';
use Test::More 'no_plan';
use HTTP::Request;
use Catalyst::Test 'TestApp';

# Account
ok( _req(POST => '/account')->is_success );
is( _req(POST => '/account')->content => 'account/create' );

ok( _req(GET => '/account/new')->is_success );
is( _req(GET => '/account/new')->content => 'account/post' );

ok( _req(GET => '/account')->is_success );
is( _req(GET => '/account')->content => 'account/show' );

ok( _req(PUT => '/account')->is_success );
is( _req(PUT => '/account')->content => 'account/update' );

ok( _req(DELETE => '/account')->is_success );
is( _req(DELETE => '/account')->content => 'account/destroy' );

ok( _req(GET => '/account/edit')->is_success );
is( _req(GET => '/account/edit')->content => 'account/edit' );

# Account::Messages
ok( _req(GET => '/account/messages')->is_success );
is( _req(GET => '/account/messages')->content => 'messages/list' );

ok( _req(POST => '/account/messages')->is_success );
is( _req(POST => '/account/messages')->content => 'messages/create' );

ok( _req(GET => '/account/messages/new')->is_success );
is( _req(GET => '/account/messages/new')->content => 'messages/post' );

ok( _req(GET => '/account/messages/1')->is_success );
is( _req(GET => '/account/messages/1')->content => 'messages/show' );

ok( _req(PUT => '/account/messages/1')->is_success );
is( _req(PUT => '/account/messages/1')->content => 'messages/update' );

ok( _req(DELETE => '/account/messages/1')->is_success );
is( _req(DELETE => '/account/messages/1')->content => 'messages/destroy' );

ok( _req(GET => '/account/messages/1/edit')->is_success );
is( _req(GET => '/account/messages/1/edit')->content => 'messages/edit' );

sub _req { request(HTTP::Request->new(@_)) }
