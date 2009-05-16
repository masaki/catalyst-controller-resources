use strict;
use lib 't/lib';
use Test::More tests => 5;
use HTTP::Request;
use Catalyst::Test 'TestApp::WithActionClass';

action_ok '/foo';
content_like '/foo' => qr!foo/list!;

action_ok '/foo/100';
content_like '/foo/100' => qr!foo/show!;
is request('/foo/100')->header('X-Args') => '100';
