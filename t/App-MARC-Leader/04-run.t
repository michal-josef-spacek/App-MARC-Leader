use strict;
use warnings;

use App::MARC::Leader;
use English;
use File::Object;
use File::Spec::Functions qw(abs2rel);
use Test::More 'tests' => 3;
use Test::NoWarnings;
use Test::Output;

# Data dir.
my $data = File::Object->new->up->dir('data');

# Test.
@ARGV = (
	'-h',
);
my $script = abs2rel(File::Object->new->file('04-run.t')->s);
# XXX Hack for missing abs2rel on Windows.
if ($OSNAME eq 'MSWin32') {
	$script =~ s/\\/\//msg;
}
my $right_ret = <<"END";
Usage: $script [-a] [-d] [-f marc_xml_file] [-h] [--version] [leader_string]
	-a			Print with ANSI colors (or use NO_COLOR/COLOR env variables).
	-d			Don't print description.
	-f marc_xml_file	MARC XML file.
	-h			Print help.
	--version		Print version.
	leader_string		MARC Leader string.
END
stderr_is(
	sub {
		App::MARC::Leader->new->run;
		return;
	},
	$right_ret,
	'Run help.',
);

# Test.
@ARGV = (
	'-f',
	$data->file('ex1.xml')->s,
);
$right_ret = <<'END';
Record length: 0
Record status: New
Type of record: Language material
Bibliographic level: Monograph/Item
Type of control: No specified type
Character coding scheme: UCS/Unicode
Indicator count: Number of character positions used for indicators
Subfield code count: Number of character positions used for a subfield code (2)
Base address of data: 0
Encoding level: Full level
Descriptive cataloging form: Non-ISBD
Multipart resource record level: Not specified or not applicable
Length of the length-of-field portion: Number of characters in the length-of-field portion of a Directory entry (4)
Length of the starting-character-position portion: Number of characters in the starting-character-position portion of a Directory entry (5)
Length of the implementation-defined portion: Number of characters in the implementation-defined portion of a Directory entry (0)
Undefined: Undefined
END
stdout_is(
	sub {
		App::MARC::Leader->new->run;
		return;
	},
	$right_ret,
	'Process ex1.xml file.',
);
