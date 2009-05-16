use strict;
use lib 't/lib';
use Test::More tests => 4;
use HTTP::Request;
use Catalyst::Test 'TestApp::Resources';

action_ok '/users/masaki';
content_like '/users/masaki' => qr'users/show';

action_ok '/users/masaki/20080401';
is get('/users/masaki/20080401') => '(user, date) = (masaki, 20080401)';
