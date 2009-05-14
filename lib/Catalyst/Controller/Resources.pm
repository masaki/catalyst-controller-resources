package Catalyst::Controller::Resources;

use 5.008_001;
use Moose;
use namespace::clean -except => ['meta'];

BEGIN { extends 'Catalyst::Controller' }

our $VERSION = '0.05';

with qw(
    Catalyst::Controller::Resources::Role::BuildActions
    Catalyst::Controller::Resources::Role::ParseAttributes
    Catalyst::Controller::Resources::Role::ActionRole
);

has '+_default_collection_actions' => (
    default  => sub {
        +{
            list   => { method => 'GET',  path => '' },
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
sub _MEMBER     :ResourceChained ResourcePathPart CaptureArgs(1) {}

__PACKAGE__->meta->make_immutable;

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

=head2 WITH OTHER CONTROLLERS AND ATTRIBUTES

e.g.) L<Catalyst::Controller::RequestToken>

In your controller:

  package MyApp::Controller::Foo;
  use base qw(
      Catalyst::Controller::Resources
      Catalyst::Controller::RequestToken
  );
  
  sub post :CreateToken {
      my ($self, $c) = @_;
      $c->stash->{template} = 'foo/post.tt';
      $c->forward($c->view('TT'));
  }
  
  sub create :ValidateToken {
      my ($self, $c) = @_;

      if ($self->validate_token) {
          $c->res->body('complete.');
      }
      else {
          $c->res->body('invalid operation.');
      }
  }

post.tt:

  <html>
    <body>
      <form action="[% c.uri_for('/foo') %]" method="post">
        <input type="hidden" name="_token" values="[% c.req.param('_token') %]"/>
        <input type="submit" name="submit" value="complete"/>
      </form>
    </body>
  </html>

=head1 CAUTION

This version works under Catalyst 5.8 (catamoose).
If you use this module with Catalyst 5.7, please check out version 0.04.

=head1 DESCRIPTION

This controller defines HTTP verb-oriented actions for collection resource,
inspired by map.resources (Ruby on Rails).

In your controller:

  package MyApp::Controller::Books;
  use base 'Catalyst::Controller::Resources';

This base controller exports Catalyst action attributes to your controller,
and setup collection resource as B</books>.

=head1 RESERVED ACTIONS

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
