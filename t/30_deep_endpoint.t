use strict;
use lib 't/lib';
use Test::Base;
use HTTP::Request;
use Catalyst::Test 'TestApp::DeepEndpoint';

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
--- path: /foo/bar
--- content: foo/bar/list

=== create
--- method: POST
--- path: /foo/bar
--- content: foo/bar/create

=== post
--- method: GET
--- path: /foo/bar/new
--- content: foo/bar/post

=== show
--- method: GET
--- path: /foo/bar/100
--- content: foo/bar/show

=== update
--- method: PUT
--- path: /foo/bar/100
--- content: foo/bar/update

=== destroy
--- method: DELETE
--- path: /foo/bar/100
--- content: foo/bar/destroy

=== edit
--- method: GET
--- path: /foo/bar/100/edit
--- content: foo/bar/edit

=== delete
--- method: GET
--- path: /foo/bar/100/delete
--- content: foo/bar/delete

=== more deep index
--- method: GET
--- path: /foo/bar/100/buz
--- content: foo/bar/buz/list

=== more deep create
--- method: POST
--- path: /foo/bar/100/buz
--- content: foo/bar/buz/create

=== more deep post
--- method: GET
--- path: /foo/bar/100/buz/new
--- content: foo/bar/buz/post

=== more deep show
--- method: GET
--- path: /foo/bar/100/buz/100
--- content: foo/bar/buz/show

=== more deep update
--- method: PUT
--- path: /foo/bar/100/buz/100
--- content: foo/bar/buz/update

=== more deep destroy
--- method: DELETE
--- path: /foo/bar/100/buz/100
--- content: foo/bar/buz/destroy

=== more deep edit
--- method: GET
--- path: /foo/bar/100/buz/100/edit
--- content: foo/bar/buz/edit

=== more deep delete
--- method: GET
--- path: /foo/bar/100/buz/100/delete
--- content: foo/bar/buz/delete
