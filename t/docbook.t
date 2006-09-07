#!/usr/bin/perl -w

# t/docbook.t - check output from Pod::PseudoPod::DocBook

BEGIN {
    chdir 't' if -d 't';
}

use strict;
use lib '../lib';
use Test::More tests => 28;

use_ok('Pod::PseudoPod::DocBook') or exit;

my $parser = Pod::PseudoPod::DocBook->new ();
isa_ok ($parser, 'Pod::PseudoPod::DocBook');

my $results;

initialize($parser, $results);
$parser->parse_string_document( "=head0 Narf!" );
is($results, "<chapter>\n<title>Narf!</title>\n\n</chapter>\n\n", "head0 level output");

initialize($parser, $results);
$parser->parse_string_document( "=head1 Poit!" );
is($results, "<sect1>\n<title>Poit!</title>\n\n</sect1>\n\n", "head1 level output");

initialize($parser, $results);
$parser->parse_string_document( "=head2 I think so Brain." );
is($results, "<sect2>\n<title>I think so Brain.</title>\n\n</sect2>\n\n", "head2 level output");

initialize($parser, $results);
$parser->parse_string_document( "=head3 I say, Brain..." );
is($results, "<sect3>\n<title>I say, Brain...</title>\n\n</sect3>\n\n", "head3 level output");

initialize($parser, $results);
$parser->parse_string_document( "=head4 Zort!" );
is($results, "<sect4>\n<title>Zort!</title>\n\n</sect4>\n\n", "head4 level output");


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

Gee, Brain, what do you want to do tonight?
EOPOD

is($results, <<'EODB', "simple paragraph");
<para>Gee, Brain, what do you want to do tonight?</para>

EODB


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

B: Now, Pinky, if by any chance you are captured during this mission,
remember you are Gunther Heindriksen from Appenzell. You moved to
Grindelwald to drive the cog train to Murren. Can you repeat that?

P: Mmmm, no, Brain, don't think I can.
EOPOD

is($results, <<'EODB', "multiple paragraphs");
<para>B: Now, Pinky, if by any chance you are captured during this mission, remember you are Gunther Heindriksen from Appenzell. You moved to Grindelwald to drive the cog train to Murren. Can you repeat that?</para>

<para>P: Mmmm, no, Brain, don't think I can.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=over

=item *

P: Gee, Brain, what do you want to do tonight?

=item *

B: The same thing we do every night, Pinky. Try to take over the world!

=back

EOPOD

is($results, <<'EODB', "simple bulleted list");
<ul>

<li>P: Gee, Brain, what do you want to do tonight?</li>

<li>B: The same thing we do every night, Pinky. Try to take over the world!</li>

</ul>

EODB


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=over

=item 1

P: Gee, Brain, what do you want to do tonight?

=item 2

B: The same thing we do every night, Pinky. Try to take over the world!

=back

EOPOD

is($results, <<'EODB', "numbered list");
<ol>

<li>1. P: Gee, Brain, what do you want to do tonight?</li>

<li>2. B: The same thing we do every night, Pinky. Try to take over the world!</li>

</ol>

EODB


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=over

=item Pinky

Gee, Brain, what do you want to do tonight?

=item Brain

The same thing we do every night, Pinky. Try to take over the world!

=back

EOPOD

is($results, <<'EODB', "list with text headings");
<ul>

<li>Pinky

<para>Gee, Brain, what do you want to do tonight?</para>

<li>Brain

<para>The same thing we do every night, Pinky. Try to take over the world!</para>

</ul>

EODB


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

  1 + 1 = 2;
  2 + 2 = 4;

EOPOD

is($results, <<'EODB', "code block");
<programlisting>
  1 + 1 = 2;
  2 + 2 = 4;</programlisting>

EODB


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a C<functionname>.
EOPOD
is($results, <<"EODB", "code entity in a paragraph");
<para>A plain paragraph with a <literal>functionname</literal>.</para>

EODB


initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a footnote.N<And the footnote is...>
EOPOD
is($results, <<"EODB", "footnote entity in a paragraph");
<para>A plain paragraph with a footnote.<footnote label="*"><para>And the footnote is...</para></footnote></para>

EODB


initialize($parser, $results);
$parser->add_css_tags(1);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a U<http://test.url.com/stuff/and/junk.txt>.
EOPOD
is($results, <<"EODB", "URL entity in a paragraph");
<para>A plain paragraph with a <systemitem role="url">http://test.url.com/stuff/and/junk.txt</systemitem>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a Z<crossreferenceendpoint>.
EOPOD
is($results, <<"EODB", "Link anchor entity in a paragraph");
<para>A plain paragraph with a <a name="crossreferenceendpoint">.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a A<crossreferencelink>.
EOPOD
is($results, <<"EODB", "Link entity in a paragraph");
<para>A plain paragraph with a <a href="#crossreferencelink">link</a>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a G<superscript>.
EOPOD
is($results, <<"EODB", "Superscript in a paragraph");
<para>A plain paragraph with a <sup>superscript</sup>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a H<subscript>.
EOPOD
is($results, <<"EODB", "Subscript in a paragraph");
<para>A plain paragraph with a <sub>subscript</sub>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with B<bold text>.
EOPOD
is($results, <<"EODB", "Bold text in a paragraph");
<para>A plain paragraph with <emphasis role="strong">bold text</emphasis>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with I<italic text>.
EOPOD
is($results, <<"EODB", "Italic text in a paragraph");
<para>A plain paragraph with <emphasis>italic text</emphasis>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with R<replaceable text>.
EOPOD
is($results, <<"EODB", "Replaceable text in a paragraph");
<para>A plain paragraph with <em>replaceable text</em>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

A plain paragraph with a F<filename>.
EOPOD
is($results, <<"EODB", "File name in a paragraph");
<para>A plain paragraph with a <filename>filename</filename>.</para>

EODB

initialize($parser, $results);
$parser->parse_string_document(<<'EOPOD');
=pod

  # this header is very important & don't you forget it
  B<my $file = <FILEE<gt> || 'Blank!';>
  my $text = "File is: " . <FILE>;
EOPOD
like($results, qr/&quot;/, "Verbatim text with encodable quotes");
like($results, qr/&amp;/, "Verbatim text with encodable ampersands");
like($results, qr/&lt;/, "Verbatim text with encodable less-than");
like($results, qr/&gt;/, "Verbatim text with encodable greater-than");

######################################

sub initialize {
	$_[0] = Pod::PseudoPod::DocBook->new ();
	$_[0]->output_string( \$results ); # Send the resulting output to a string
	$_[1] = '';
	return;
}