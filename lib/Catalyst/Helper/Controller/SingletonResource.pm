package Catalyst::Helper::Controller::SingletonResource;

use strict;
use warnings;

sub mk_compclass {
    my ($self, $helper, $belongs_to) = @_;

    $helper->{belongs_to} = $belongs_to if $belongs_to;
    $helper->render_file('compclass', $helper->{file});
};

sub mk_comptest {
    my ($self, $helper) = @_;

    $helper->render_file('test', $helper->{test});
};

=head1 NAME

Catalyst::Helper::Controller::SingletonResource - Helper for Controller::SingletonResource

=head1 SYNOPSIS

    script/create.pl controller <ControllerName> SingletonResource [ BelongsToName ]

=head1 METHODS

=over 4

=item mk_complass

Makes a SingletonResource Controller class.

=item mk_comptest

Makes a SingletonResource Controller test.

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Controller::SingletonResource>

=begin pod_to_ignore

=cut

1;
__DATA__

__compclass__
package [% class %];

use strict;
use warnings;
use base 'Catalyst::Controller::SingletonResource';

[% IF belongs_to -%]
__PACKAGE__->config(belongs_to => '[% belongs_to %]');
[% END -%]

=head1 NAME

[% class %] - Catalyst Singleton Resource Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 create

called by POST Singleton Resource

=cut

sub create {
    my ($self, $c[% IF belongs_to %], $parent_id[% END %]) = @_;
}

=head2 show

called by GET Singleton Resource

=cut

sub show {
    my ($self, $c[% IF belongs_to %], $parent_id[% END %]) = @_;
}

=head2 update

called by PUT Singleton Resource

=cut

sub update {
    my ($self, $c[% IF belongs_to %], $parent_id[% END %]) = @_;
}

=head2 destroy

called by DELETE Singleton Resource

=cut

sub destroy {
    my ($self, $c[% IF belongs_to %], $parent_id[% END %]) = @_;
}

=head2 post

called by GET form for describing a new Resource

=cut

sub post {
    my ($self, $c[% IF belongs_to %], $parent_id[% END %]) = @_;
}

=head2 edit

called by GET form for describing a Singleton Resource

=cut

sub edit {
    my ($self, $c[% IF belongs_to %], $parent_id[% END %]) = @_;
}

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

__test__
use strict;
use Test::More tests => 1;

use_ok('[% class %]');

__END__

