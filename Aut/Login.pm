package Aut::Login;

use strict;
use Aut::GUI;
use Lang;

use base qw(Aut::dlgLogin);

sub new {
    my $class=shift;
    my $auth=shift;
    my $title=shift;
    my $parent=shift;
    my $self;

    if (not $parent) { $parent=undef; }
    $self=$class->SUPER::new($parent,-1,_T($title));
    $self->{"auth"}=$auth;
    $self->{"ok"}=undef;
    $self->{"ticket"}=undef;

    bless $self,$class;

return $self;
}

sub login {
    my $self=shift;

    $self->{"ok"}=0;

    if ($self->{"auth"}->has_accounts()) {
	$self->pass("");
	$self->ShowModal();
    }
    else {
	$self->{"ticket"}=$self->{"auth"}->admin_ticket();
    }

return $self->{"ticket"};
}

sub Ok {
    my $self=shift;
    my $account=$self->account();
    my $pass=$self->pass();

    my $ticket=$self->{"auth"}->check_login($account,$pass);

    if ($ticket->valid()) {
	$self->{"ok"}=1;
    }
    else {
	$self->messageOK(_T("Login"),_T("Not a valid account/user combination"),$self);
	$self->pass("");
    }

    $self->{"ticket"}=$ticket;

return $self->{"ok"};
}

sub Cancel {
    my $self=shift;
    $self->{"ticket"}=new Aut::Ticket(VALID => 0);
return 1;
}



1;
__END__

=head1 NAME

Aut::Login - Autorization Framework for wxPerl - Loggin In

=head1 SYNOPSIS

    use Aut::Backend::SQL;
    use Aut;
    use Aut::Login;
    use DBI;
    use Lang::SQL;
    use Lang;

    package testApp;

    use base 'Wx::App';

    sub OnInit {
      my $dbname="zclass";
      my $host="localhost";
      my $user="zclass";
      my $pass="";
      my $dsn="dbi:Pg:dbname=$dbname;host=$host";

      Lang::init(new Lang::SQL("dbi:Pg:dbname=$dbname;host=$host",$user,$pass));

      my $backend=Aut::Backend::SQL->new($dsn,$user,$pass);
      my $auth=Aut->new($backend);

      my $login=Aut::Login->new($auth,"test application");

      my $ticket=$login->login();
      $ticket->log();

      $ticket=Aut::Ticket->new(ADMIN => 1);
      $ticket->log();
      $auth->create_account("admin","test",$ticket);

      print "login with admin, pass=test\n";

      $ticket=$login->login();

      $ticket->log();

      $login->Destroy;

      return 0;
    }

    package main;

    my $a= new testApp;
    $a->MainLoop();

=head1 ABSTRACT

'Aut::Login' is part of the authorization framework that can be used
in conjunction with wxPerl. It provides the gui part for logging in.

=head1 DESCRIPTION

=head2 C<new(Aut object, title [,parent])> --E<gt> Aut::Login

This method initializes the Login dialog and returns an 
Aut::Login object.

=head2 C<login> --E<gt> Aut::Ticket

Shows a modal dialog that can be used to log into something.
Returns a ticket. If the user presses the Cancel button, an
invalid ticket.

=head1 Internationalization

This module uses '_T' functions for internationalization of
text strings used in this module. It has been programmed to
use the 'Lang' framework.

=head1 SEE ALSO

L<http://wxperl.sf.net>, L<Lang framework|Lang>, L<Aut framework|Aut>, L<Aut::Ticket|Aut::Ticket>, 
L<Aut::Backend::SQL|Aut::Backend::SQL>.

=head1 AUTHOR

Hans Oesterholt-Dijkema <oesterhol@cpan.org>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under LGPL terms.

=cut

