package Catalyst::Controller::Resources;

use Moose;
use namespace::clean -except => ['meta'];
use attributes ();

our $VERSION = '0.04';

BEGIN { extends 'Catalyst::Controller::ActionRole' }

__PACKAGE__->config(
    action_roles => ['+Catalyst::Controller::Resources::ActionRole::ResourceAction'],
);

with 'Catalyst::Controller::Resources::Role::ResourceAttributes';

has '_default_collection_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
    default  => sub {
        +{
            list   => { method => 'GET',  path => '' },
            create => { method => 'POST', path => '' },
            post   => { method => 'GET',  path => 'new' },
        },
    },
);

has '_additional_collection_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => 'collection',
    default  => sub { +{} },
);

has '_collection_actions' => (
    is         => 'ro',
    isa        => 'HashRef',
    init_arg   => undef,
    lazy_build => 1,
);

sub _build__collection_actions {
    my $self = shift;
    return +{
        %{ $self->_default_collection_actions },
        %{ $self->_additional_collection_actions },
    };
}

has '_default_member_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
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

has '_additional_member_actions' => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => 'member',
    default  => sub { +{} },
);

has '_member_actions' => (
    is         => 'ro',
    isa        => 'HashRef',
    init_arg   => undef,
    lazy_build => 1,
);

sub _build__member_actions {
    my $self = shift;
    return +{
        %{ $self->_default_member_actions },
        %{ $self->_additional_member_actions },
    };
}

sub _COLLECTION :ResourceChained ResourcePath CaptureArgs(0) {}
sub _MEMBER     :ResourceChained ResourcePath CaptureArgs(1) {}

sub BUILD {
    my $self = shift;

    $self->setup_actions(_COLLECTION => $self->_collection_actions);
    $self->setup_actions(_MEMBER     => $self->_member_actions);
}

sub setup_actions {
    my ($self, $map_to, $maps) = @_;
    my $class = ref $self || $self;

    while (my ($action, $map) = each %$maps) {
        next unless my $code = $class->can($action);
        $map = { method => uc $map } unless ref($map) eq 'HASH';

        my @attrs = $self->_construct_action_attributes($map_to, $map);
        unshift @attrs => @{ attributes::get($code) || [] };

        attributes->import($class, $code, @attrs);
    }
}

sub _construct_action_attributes {
    my ($self, $chained_from, $map) = @_;

    return (
        'ResourceEndpoint',
        'Args(0)',
        "Chained('$chained_from')",
        "Method('$map->{method}')",
        exists $map->{path} ? "PathPart('$map->{path}')" : 'PathPart',
    );
}

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
