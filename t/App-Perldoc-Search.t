#!perl
use Test::More tests => 6;
use strict;
use warnings;

use IPC::Run ();
use Cwd ();
use File::Spec ();
use File::Basename ();

search_ok( '\brun\b', qr/^IPC::Run/m, 'Found IPC::Run' );

# echo -n 'Try searching for something that probably doesn'\''t exist' | md5
# dc098fbcf3f9bf8ba7898addba4591cb
search_ok( 'dc098fbcf3f9bf8ba7898addba4591cb', qr/^$/, "Couldn't find dc098fbcf3f9bf8ba7898addba4591cb" );


sub search_ok {
    my ( $phrase, $expected, $test_name ) = @_;

    my @command = (
        $^X,
        '-Mblib',
        'bin/perldoc-search',
        $phrase
    );
    my $success = IPC::Run::run(
        \ @command,
        '>',  \ my $stdout,
        '2>', \ my $stderr,
    );

    ok( $success, "@command" );
    is( $stderr, '', "No errors" );
    like( $stdout, $expected, $test_name );
}
