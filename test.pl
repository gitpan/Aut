# Perl
# $Id: test.pl,v 1.5 2004/04/08 16:55:13 cvs Exp $ 
################################################################
# Setup custom Test script
################################################################

BEGIN { print "1..?\n"; }

my $tcount=0;
sub tt {
  printf "%3d...%s\n",$tcount,shift;
}

sub ok {
  print "--> ok $tcount\n";
  $tcount+=1;
}

sub nok {
  print "--> nok $tcount\n";
  $tcount+=1;
}

################################################################
# Use modules
################################################################

tt("Using the modules we need"); 

use Aut;
use Aut::UI::Console;
use Aut::Backend::Conf;
use Config::Frontend;
use Config::Backend::INI;
use strict;

ok();

################################################################
# Instantiate aut system
################################################################

tt("Initializing aut object");

my $cfg=new Config::Frontend(new Config::Backend::INI("./accounts.ini"));
my $backend=new Aut::Backend::Conf($cfg);
my $ui=new Aut::UI::Console();
my $aut=new Aut( Backend => $backend, UI => $ui, RSA_Bits => 512 );

ok();

################################################################
# Initializing admin
################################################################

tt("Initializing 'admin' account with password 'testpass'");

my $ticket=$aut->ticket_get("admin","testpass");
if (not $ticket->valid()) {
  $ticket=new Aut::Ticket("admin","testpass");
  $ticket->set_rights("admin");
  $aut->ticket_create($ticket);
}

ok();

################################################################
# test ui
################################################################

################################################################
# test LOGIN
################################################################

tt("Testing user interface, logging in (login with 'admin' and 'testpass')");

print "\n";

$ticket=$aut->login();

print "account :",$ticket->account(),"\n";
print "rights  :",$ticket->rights(),"\n";

ok();

################################################################
# test ADMIN
################################################################

tt("Testing user interface, administrator menu (do whatever you think is appropriate ;-)).");

$aut->admin($ticket);

print "account :",$ticket->account(),"\n";
print "rights  :",$ticket->rights(),"\n";

ok();

################################################################
# Change password
################################################################

tt("Testing user interface, Changing password");

$aut->change_pass($ticket);

if ($ticket->valid()) {
  my $text="This is a text!!";

  my $ciphertext=$ticket->encrypt($text);
  my $dtext=$ticket->decrypt($ciphertext);

  ok();

  
  tt("Testing symmetric encryption");

  if ($text eq $dtext) {
    print "encryption/decryption = symmetric, ok\n";
  }
}

ok();

################################################################
# Post message
################################################################

print <<EOF
You can repeat this test, after adding some accounts with different
authorization levels. Try e.g.:

- Installing with an account without 'admin' rights.
- Logging in with an invalid account (login will prompt you max. 3 times).
- Enter false data while changing the password.
- Change passwords from the admin menu.
- Change rights from the admin menu.
- Delete all accounts.
- Change rights of all accounts until and including the last admin account.

etc.

EOF









