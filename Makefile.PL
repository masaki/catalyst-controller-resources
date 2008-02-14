use inc::Module::Install;
name('Catalyst-Controller-Resources');
all_from('lib/Catalyst/Controller/Resources.pm');

requires('Catalyst::Runtime' => 5.70);
requires('Catalyst::Devel'); # Catalyst::Helper
requires('Class::C3');

build_requires('Test::More');
build_requires('HTTP::Request');

use_test_base;

auto_include;
auto_install;
WriteAll;
