use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

### no test Catalyst::Controller::Resource
plan tests => 2;
pod_coverage_ok('Catalyst::Controller::Resources');
pod_coverage_ok('Catalyst::Controller::SingletonResource');
