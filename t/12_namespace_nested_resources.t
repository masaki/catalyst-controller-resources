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
=== nested list
--- method: GET
--- path: /users/100/articles
--- content: users/articles/list

=== nested create
--- method: POST
--- path: /users/100/articles
--- content: users/articles/create

=== nested show
--- method: GET
--- path: /users/100/articles/200
--- content: users/articles/show

=== nested update
--- method: PUT
--- path: /users/100/articles/200
--- content: users/articles/update

=== nested destroy
--- method: DELETE
--- path: /users/100/articles/200
--- content: users/articles/destroy

=== complex nested list
--- method: GET
--- path: /users/100/articles/200/comments
--- content: users/articles/comments/list

=== complex nested create
--- method: POST
--- path: /users/100/articles/200/comments
--- content: users/articles/comments/create

=== complex nested show
--- method: GET
--- path: /users/100/articles/200/comments/300
--- content: users/articles/comments/show

=== complex nested update
--- method: PUT
--- path: /users/100/articles/200/comments/300
--- content: users/articles/comments/update

=== complex nested destroy
--- method: DELETE
--- path: /users/100/articles/200/comments/300
--- content: users/articles/comments/destroy
