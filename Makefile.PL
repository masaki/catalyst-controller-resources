use inc::Module::Install;
name 'Catalyst-Controller-Resources';
all_from 'lib/Catalyst/Controller/Resources.pm';

requires 'Catalyst::Runtime' => '5.80011';
requires 'Catalyst::Controller::ActionRole' => '0.12';
requires 'Moose' => '0.79';
requires 'Class::MOP' => '0.84';
requires 'namespace::clean';

feature 'Catalyst::Helper support',
    -default          => 0,
    'Catalyst::Devel' => '1.15';

tests 't/*.t';
test_requires 'Test::More';
test_requires 'Test::UseAllModules';
test_requires 'HTTP::Request';
test_requires 'MRO::Compat';
author_tests 'xt';
use_test_base;

auto_set_repository;
auto_include_deps;
WriteAll;
