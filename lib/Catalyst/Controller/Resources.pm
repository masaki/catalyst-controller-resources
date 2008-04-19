package Catalyst::Controller::Resources;

use strict;
use warnings;
use base 'Catalyst::Controller::Resource';
use Catalyst::Utils;

our $VERSION = '0.03';

sub setup_collection_actions {
    my $self = shift;

    my $maps = Catalyst::Utils::merge_hashes($self->{collection} || {}, {
        list   => { method => 'GET',  path => '' },
        create => { method => 'POST', path => '' },
        post   => { method => 'GET',  path => 'new' },
    });
    $self->setup_actions(collection => $maps);
}

sub setup_member_actions {
    my $self = shift;

    my $maps = Catalyst::Utils::merge_hashes($self->{member} || {}, {
        show    => { method => 'GET',    path => '' },
        update  => { method => 'PUT',    path => '' },
        destroy => { method => 'DELETE', path => '' },
        edit    => { method => 'GET' },
    });
    $self->setup_actions(member => $maps);
}

1;

=head1 NAME

Catalyst::Controller::Resources - Catalyst Collection Resources Controller

=head1 SYNOPSIS

=head2 MAP RESOURCES

  package MyApp::Controller::Articles;
  use base 'Catalyst::Controller::Resources';
  
  # GET /articles
  sub list {
      my ($self, $c) = @_;
  }
  
  # POST /articles
  sub create {
      my ($self, $c) = @_;
  }
  
  # GET /articles/{article_id}
  sub show {
      my ($self, $c, $article_id) = @_;
  }
  
  # PUT /articles/{article_id}
  sub update {
      my ($self, $c, $article_id) = @_;
  }
  
  # DELETE /articles/{article_id}
  sub destroy {
      my ($self, $c, $article_id) = @_;
  }
  
  # GET /articles/new
  sub post {
      my ($self, $c) = @_;
  }
  
  # GET /articles/{article_id}/edit
  sub edit {
      my ($self, $c, $article_id) = @_;
  }

=head2 NESTED RESOURCES

  package MyApp::Controller::Articles;
  use base 'Catalyst::Controller::Resources';
  
  # ...
  
  package MyApp::Controller::Comments;
  use base 'Catalyst::Controller::Resources';
  
  __PACKAGE__->config(belongs_to => 'Articles');
  
  # GET /articles/{article_id}/comments
  sub list {
      my ($self, $c, $article_id) = @_;
  }
  
  # POST /articles/{article_id}/comments
  sub create {
      my ($self, $c, $article_id) = @_;
  }
  
  # GET /articles/{article_id}/comments/{comment_id}
  sub show {
      my ($self, $c, $article_id, $comment_id) = @_;
  }
  
  # PUT /articles/{article_id}/comments/{comment_id}
  sub update {
      my ($self, $c, $article_id, $comment_id) = @_;
  }
  
  # DELETE /articles/{article_id}/comments/{comment_id}
  sub destroy {
      my ($self, $c, $article_id, $comment_id) = @_;
  }
  
  # GET /articles/{article_id}/comments/new
  sub post {
      my ($self, $c, $article_id) = @_;
  }
  
  # GET /articles/{article_id}/comments/{comment_id}/edit
  sub edit {
      my ($self, $c, $article_id, $comment_id) = @_;
  }

=head1 DESCRIPTION

This controller defines HTTP verb-oriented actions for collection resource,
inspired by map.resources (Ruby on Rails).

In your controller:

  package MyApp::Controller::Books;
  use base 'Catalyst::Controller::Resources';

This base controller exports Catalyst action attributes to your controller,
and setup collection resource as B</books>.

=head1 METHODS

=head2 RESERVED SUBROUTINES (ACTIONS)

=over

=item list

called by B<GET /collection> request

=item create

called by B<POST /collection> request

=item show

called by B<GET /member/{member_id}> request

=item update

called by B<PUT /member/{member_id}> request

=item destroy

called by B<DELETE /member/{member_id}> request

=item post

called by B<GET /collection/new> request

=item edit

called by B<GET /member/{member_id}/edit> request

=back

=head2 INTERNAL METHODS

=over

=item setup_collection_actions

=item setup_member_actions

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

Daisuke Murase E<lt>typester@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Controller>, L<Catalyst::Controller::SingletonResource>,
L<http://api.rubyonrails.org/classes/ActionController/Resources.html>

=cut
