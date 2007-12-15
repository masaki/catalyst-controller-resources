use inc::Module::Install;
name('Catalyst-Controller-Resources');
all_from('lib/Catalyst/Controller/Resources.pm');

requires('String::CamelCase');
requires('Class::C3');
requires('Catalyst::Runtime' => 5.70);

build_requires 'Test::More';
use_test_base;

auto_include;
auto_install;
WriteAll;
