package Catalyst::Controller::SingletonResource;

use Moose;
use namespace::clean -except => ['meta'];
use Catalyst::Utils;

require Catalyst::Controller::Resources;
our $VERSION = $Catalyst::Controller::Resources::VERSION;

BEGIN { extends 'Catalyst::Controller::Resource' }

with 'Catalyst::Controller::Resources::Role::ResourceAttributes';

sub _COLLECTION :ResourceChained ResourcePath CaptureArgs(0) {}
sub _MEMBER     :ResourceChained ResourcePath CaptureArgs(0) {}

sub setup_collection_actions {
    my $self = shift;

    my $maps = Catalyst::Utils::merge_hashes($self->{collection} || {}, {
        create => { method => 'POST', path => '' },
        post   => { method => 'GET',  path => 'new' },
    });
    $self->setup_actions(_COLLECTION => $maps);
}

sub setup_member_actions {
    my $self = shift;

    my $maps = Catalyst::Utils::merge_hashes($self->{member} || {}, {
        show    => { method => 'GET',    path => '' },
        update  => { method => 'PUT',    path => '' },
        destroy => { method => 'DELETE', path => '' },
        edit    => { method => 'GET' },
    });
    $self->setup_actions(_MEMBER => $maps);
}

__PACKAGE__->meta->make_immutable;

=head1 NAME

Catalyst::Controller::SingletonResource - Catalyst Singleton Resource Controller

=head1 SYNOPSIS

  package MyApp::Controller::Account;
  use base 'Catalyst::Controller::SingletonResource';
  
  # POST /account
  sub create {
      my ($self, $c) = @_;
  }
  
  # GET /account
  sub show {
      my ($self, $c) = @_;
  }
  
  # PUT /account
  sub update {
      my ($self, $c) = @_;
  }
  
  # DELETE /account
  sub destroy {
      my ($self, $c) = @_;
  }
  
  # GET /account/new
  sub post {
      my ($self, $c) = @_;
  }
  
  # GET /account/edit
  sub edit {
      my ($self, $c) = @_;
  }

=head1 DESCRIPTION

This controller defines HTTP verb-oriented actions for singleton resource,
inspired by map.resource (Ruby on Rails).

In your controller:

  package MyApp::Controller::Account;
  use base 'Catalyst::Controller::SingletonResource';

This base controller exports Catalyst action attributes to your controller,
and setup singleton resource as B</account>.

=head1 METHODS

=head2 RESERVED SUBROUTINES (ACTIONS)

=over

=item create

called by B<POST /resource> request

=item show

called by B<GET /resource> request

=item update

called by B<PUT /resource> request

=item destroy

called by B<DELETE /resource> request

=item post

called by B<GET /resource/new> request

=item edit

called by B<GET /resource/edit> request

=back

=head2 INTERNAL METHODS

=over

=item setup_collection_actions

=item setup_member_actions

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Controller>, L<Catalyst::Controller::Resources>,
L<http://api.rubyonrails.org/classes/ActionController/Resources.html>

=cut
