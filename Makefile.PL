use inc::Module::Install;
name 'Catalyst-Controller-Resources';
all_from 'lib/Catalyst/Controller/Resources.pm';

requires 'Catalyst::Runtime' => 5.70;
requires 'Class::C3';
requires 'List::Util';

feature 'Catalyst::Helper support',
    -default          => 0,
    'Catalyst::Devel' => '1.0';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::use::ok';
test_requires 'HTTP::Request';
author_tests 'xt';
use_test_base;

auto_include;
auto_install;
WriteAll;
