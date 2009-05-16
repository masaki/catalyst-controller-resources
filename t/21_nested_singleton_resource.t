use strict;
use lib 't/lib';
use Test::Base;
use HTTP::Request;
use Catalyst::Test 'TestApp::Singleton';

plan tests => 2 * blocks;

run {
    my $block = shift;
    my $name = $block->name;
    my $res = request(HTTP::Request->new($block->method, $block->path));
    ok $res->is_success, "request success: $name";
    is $res->content => $block->content, "valid contents: $name";
};

__END__
=== index
--- method: GET
--- path: /account/messages
--- content: messages/list

=== create
--- method: POST
--- path: /account/messages
--- content: messages/create

=== post
--- method: GET
--- path: /account/messages/new
--- content: messages/post

=== show
--- method: GET
--- path: /account/messages/100
--- content: messages/show

=== update
--- method: PUT
--- path: /account/messages/100
--- content: messages/update

=== destroy
--- method: DELETE
--- path: /account/messages/100
--- content: messages/destroy

=== edit
--- method: GET
--- path: /account/messages/100/edit
--- content: messages/edit

=== delete
--- method: GET
--- path: /account/messages/100/delete
--- content: messages/delete
