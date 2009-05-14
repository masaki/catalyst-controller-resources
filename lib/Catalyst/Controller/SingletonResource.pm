package Catalyst::Controller::SingletonResource;

use Moose;
use namespace::clean -except => ['meta'];

BEGIN { extends 'Catalyst::Controller' }

our $VERSION = '0.06';

with qw(
    Catalyst::Controller::Resources::Role::BuildActions
    Catalyst::Controller::Resources::Role::ParseAttributes
    Catalyst::Controller::Resources::Role::ActionRole
);

has '+_default_collection_actions' => (
    default  => sub {
        +{
            create => { method => 'POST', path => '' },
            post   => { method => 'GET',  path => 'new' },
        },
    },
);

has '+_default_member_actions' => (
    default  => sub {
        +{
            show    => { method => 'GET',    path => '' },
            update  => { method => 'PUT',    path => '' },
            destroy => { method => 'DELETE', path => '' },
            edit    => { method => 'GET',    path => 'edit' },
            delete  => { method => 'GET',    path => 'delete' },
        },
    },
);

sub _COLLECTION :ResourceChained ResourcePathPart CaptureArgs(0) {}
sub _MEMBER     :ResourceChained ResourcePathPart CaptureArgs(0) {}

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

=head1 RESERVED ACTIONS

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

=item delete

called by B<GET /resource/delete> request

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
