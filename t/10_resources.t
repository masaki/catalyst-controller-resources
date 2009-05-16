use strict;
use lib 't/lib';
use Test::Base;
use HTTP::Request;
use Catalyst::Test 'TestApp::Resources';

plan tests => 2 * blocks;

run {
    my $block = shift;
    my $name = $block->name;
    my $res = request(HTTP::Request->new($block->method, $block->path));
    ok $res->is_success, "request success: $name";
    is $res->content => $block->content, "valid contents: $name";
};

__END__
=== list
--- method: GET
--- path: /users
--- content: users/list

=== create
--- method: POST
--- path: /users
--- content: users/create

=== post
--- method: GET
--- path: /users/new
--- content: users/post

=== show
--- method: GET
--- path: /users/100
--- content: users/show

=== update
--- method: PUT
--- path: /users/100
--- content: users/update

=== destroy
--- method: DELETE
--- path: /users/100
--- content: users/destroy

=== edit
--- method: GET
--- path: /users/100/edit
--- content: users/edit

=== delete
--- method: GET
--- path: /users/100/delete
--- content: users/delete

=== extra collection
--- method: GET
--- path: /users/login
--- content: users/login

=== extra member
--- method: GET
--- path: /users/100/feed
--- content: users/feed
