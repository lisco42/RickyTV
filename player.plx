#!/usr/bin/perl
###############################################################################
## player.plx - a constant video player for raspberry pi utilizing omxplayer ##
## Original purpose: RickyTV - media player for mentally handycapped people  ##
## Prereqs (some): 512M Raspi B, omxplayer, perl 5.10+                       ##
## Cpan modules: Term::ReadKey, File::Next, Switch, Term::ANSIColor          ## 
## This is for usage without an X server (just framebuffer)                  ##
## Config of system: Arch linux (pi), framebuffer, 64M allocated to gpu      ##
##                 : autologin as 'ricky' user currently, control buttons    ##
##                 : pinned into gpio headers for < > space q + -            ##
## Control: Space (play/pause) and replay current movie, > (skip +30sec) and ##
##        : play next video, < (skip -30sec) and play previous video, +/-    ##
##        : volume control, q (quits current video)                          ##
## vers v.1 - 8/30/15 - initial version                                      ##
## vers v.2 - 9/2/15 - improvements                                          ##
###############################################################################

## todo:
## see if you can get rid of directory path in title
## see whats wrong with audio changing in omxplayer with arch (if possible)
## reformat image to have /home/$user/videos be fat32 (most of disk)

use strict;
use 5.010;
use File::Next;
use Term::ReadKey;
use Switch; 
use Term::ANSIColor;

#global variables
my $user="ricky";
my $videodir="/home/$user/videos";
my $player="omxplayer";
my $maxcounter;
my $counter;
my $input;

say "player.plx script starting";
sleep (2); # wait for the system to settle down a bit
print "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"; ## clear/start at bottom of screen

# primary loop, this program is supposed to run at boot (with crontab @reboot /home/<user>/player.plx) and never end until reboot
# build an array of videos from ~/videos, avi mp4 m4v mkv - add more if needed || not playable: mpg

while (42) {
say "Configured Video directory:  $videodir"; 
my $files = File::Next::files( {sort_files => 1,}, "$videodir" );
my @files;

while ( defined ( my $file = $files->() ) ) {
push @files, $file;
}

$counter=0;
$maxcounter = scalar @files;
say "number of videos: $maxcounter";

while (42) {
  sleep(.3); ## temporary sleep
  print "\033[2J";
  if ( $counter == $maxcounter-1 )
    { print colored ("@files[$counter]\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 'bold cyan'), colored ("Previous video: @files[$counter-1] \nNext Video: @files[0]\n", 'blue'); }
    else
    { print colored ("@files[$counter]\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", 'bold cyan'), colored ("Previous video: @files[$counter-1] \nNext Video: @files[$counter+1]\n", 'blue'); }
  print colored ("Keys: <- and -> prev/next movie, in omx -+30 sec | q - + in omx quit voldown volup\n \" \" (space) play current slected movie, in omx play/pause", 'blue'); 
  #say ("counter is currently $counter ");
  ReadMode 'cbreak';
  $input = ReadKey(0);
  while ( $input eq "+" || $input eq "-" || $input eq "q" ) { $input = ReadKey(0); }
  if ( $input ne " " ) {
    my $input2 = ReadKey(0);
    my $input3 = ReadKey(0);
    $input = join "", $input, $input2, $input3;
  }
  ReadMode 'normal';
  switch ($input) {
    case "[C" { $counter++ }
    case "[D" { $counter-- }
    case " " { system("$player -p -b \"@files[$counter]\""); }
  }
  if ( $counter == abs($counter) ) {} else { $counter = $maxcounter-1; }
  if ( $counter == $maxcounter ) { $counter = 0; }
}

sleep (.3); ## wait just in case ctrl+c is necessary
} ## end primary loop
