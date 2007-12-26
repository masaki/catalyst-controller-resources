package Catalyst::Helper::Controller::Resources;
use strict;
use warnings;

sub mk_compclass {
    my ($self, $helper, $model) = @_;

    $helper->render_file('compclass', $helper->{file});
};

sub mk_comptest {
    my ($self, $helper) = @_;

    $helper->render_file('test', $helper->{test});
};

=head1 NAME

Catalyst::Helper::Controller::Resources - Helper for Controller::Resources

=head1 SYNOPSIS

    script/create.pl controller <newclass> Resources

=head1 METHODS

=over 4

=item mk_complass

Makes a Resources Controller class.

=item mk_comtest

Makes a Resources Controller test.

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Controller::Resources>

=begin pod_to_ignore

=cut

1;
__DATA__

__compclass__
package [% class %];

use strict;
use base 'Catalyst::Controller::Resources';

=head1 NAME

[% class %] - Catalyst Resources Controller 

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
__test__
use strict;
use Test::More tests => 3;
use_ok( 'Catalyst::Test', '[% app %]' );
use_ok('[% class %]');

ok( request('[% uri %]')->is_success );
__END__

