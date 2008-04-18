use inc::Module::Install;
name('Catalyst-Controller-Resources');
all_from('lib/Catalyst/Controller/Resources.pm');

requires('Catalyst::Runtime' => 5.70);
requires('Class::C3');

feature 'Catalyst::Helper support',
    -default          => 0,
    'Catalyst::Devel' => '1.0';

build_requires('Test::More');
build_requires('HTTP::Request');

use_test_base;

auto_include;
auto_install;
WriteAll;
