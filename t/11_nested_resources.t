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
--- path: /users/100/pages
--- content: pages/list

=== create
--- method: POST
--- path: /users/100/pages
--- content: pages/create

=== post
--- method: GET
--- path: /users/100/pages/new
--- content: pages/post

=== show
--- method: GET
--- path: /users/100/pages/200
--- content: pages/show

=== update
--- method: PUT
--- path: /users/100/pages/200
--- content: pages/update

=== destroy
--- method: DELETE
--- path: /users/100/pages/200
--- content: pages/destroy

=== edit
--- method: GET
--- path: /users/100/pages/200/edit
--- content: pages/edit

=== delete
--- method: GET
--- path: /users/100/pages/200/delete
--- content: pages/delete
