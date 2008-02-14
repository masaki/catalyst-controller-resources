use strict;
use lib 't/lib';
use Test::More 'no_plan';
use HTTP::Request;
use Catalyst::Test 'TestApp';

# Users::Articles
ok( _req(GET => '/users/1/articles')->is_success );
is( _req(GET => '/users/1/articles')->content => 'users/articles/list' );

ok( _req(POST => '/users/1/articles')->is_success );
is( _req(POST => '/users/1/articles')->content => 'users/articles/create' );

ok( _req(GET => '/users/1/articles/new')->is_success );
is( _req(GET => '/users/1/articles/new')->content => 'users/articles/post' );

ok( _req(GET => '/users/1/articles/1')->is_success );
is( _req(GET => '/users/1/articles/1')->content => 'users/articles/show' );

ok( _req(PUT => '/users/1/articles/1')->is_success );
is( _req(PUT => '/users/1/articles/1')->content => 'users/articles/update' );

ok( _req(DELETE => '/users/1/articles/1')->is_success );
is( _req(DELETE => '/users/1/articles/1')->content => 'users/articles/destroy' );

ok( _req(GET => '/users/1/articles/1/edit')->is_success );
is( _req(GET => '/users/1/articles/1/edit')->content => 'users/articles/edit' );

# Users::Articles::Comments
ok( _req(GET => '/users/1/articles/1/comments')->is_success );
is( _req(GET => '/users/1/articles/1/comments')->content => 'users/articles/comments/list' );

ok( _req(POST => '/users/1/articles/1/comments')->is_success );
is( _req(POST => '/users/1/articles/1/comments')->content => 'users/articles/comments/create' );

ok( _req(GET => '/users/1/articles/1/comments/new')->is_success );
is( _req(GET => '/users/1/articles/1/comments/new')->content => 'users/articles/comments/post' );

ok( _req(GET => '/users/1/articles/1/comments/1')->is_success );
is( _req(GET => '/users/1/articles/1/comments/1')->content => 'users/articles/comments/show' );

ok( _req(PUT => '/users/1/articles/1/comments/1')->is_success );
is( _req(PUT => '/users/1/articles/1/comments/1')->content => 'users/articles/comments/update' );

ok( _req(DELETE => '/users/1/articles/1/comments/1')->is_success );
is( _req(DELETE => '/users/1/articles/1/comments/1')->content => 'users/articles/comments/destroy' );

ok( _req(GET => '/users/1/articles/1/comments/1/edit')->is_success );
is( _req(GET => '/users/1/articles/1/comments/1/edit')->content => 'users/articles/comments/edit' );

sub _req { request(HTTP::Request->new(@_)) }
