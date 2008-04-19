use strict;
use lib 't/lib';
use Test::More 'no_plan';
use HTTP::Request;
use Catalyst::Test 'TestApp';

ok( _req(GET => '/foo/bar')->is_success );
is( _req(GET => '/foo/bar')->content => 'foo/bar/list' );

ok( _req(POST => '/foo/bar')->is_success );
is( _req(POST => '/foo/bar')->content => 'foo/bar/create' );

ok( _req(GET => '/foo/bar/new')->is_success );
is( _req(GET => '/foo/bar/new')->content => 'foo/bar/post' );

ok( _req(GET => '/foo/bar/1')->is_success );
is( _req(GET => '/foo/bar/1')->content => 'foo/bar/show' );

ok( _req(PUT => '/foo/bar/1')->is_success );
is( _req(PUT => '/foo/bar/1')->content => 'foo/bar/update' );

ok( _req(DELETE => '/foo/bar/1')->is_success );
is( _req(DELETE => '/foo/bar/1')->content => 'foo/bar/destroy' );

ok( _req(GET => '/foo/bar/1/edit')->is_success );
is( _req(GET => '/foo/bar/1/edit')->content => 'foo/bar/edit' );

# deep nest
ok( _req(GET => '/foo/bar/1/buz')->is_success );
is( _req(GET => '/foo/bar/1/buz')->content => 'foo/bar/buz/list' );

ok( _req(GET => '/foo/bar/1/buz/1')->is_success );
is( _req(GET => '/foo/bar/1/buz/1')->content => 'foo/bar/buz/show' );

sub _req { request(HTTP::Request->new(@_)) }
