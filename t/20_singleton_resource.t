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
=== create
--- method: POST
--- path: /account
--- content: account/create

=== post
--- method: GET
--- path: /account/new
--- content: account/post

=== show
--- method: GET
--- path: /account
--- content: account/show

=== update
--- method: PUT
--- path: /account
--- content: account/update

=== destroy
--- method: DELETE
--- path: /account
--- content: account/destroy

=== edit
--- method: GET
--- path: /account/edit
--- content: account/edit

=== delete
--- method: GET
--- path: /account/delete
--- content: account/delete
