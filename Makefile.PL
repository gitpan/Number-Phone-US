# $Id: Makefile.PL,v 1.1.1.1 2000/11/17 21:34:14 kennedyh Exp $

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'HTML::Widgets::DateEntry',
    'VERSION_FROM' => 'lib/HTML/Widgets/DateEntry.pm', # finds $VERSION
);
