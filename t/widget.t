#!/usr/bin/env perl -w
# $Id: widget.t,v 1.1 2002/08/10 02:54:04 kennedyh Exp $

use strict;
use Test::Simple tests => 6;

use HTML::Widgets::DateEntry;

my ($date_year, $date_month, $date_day) = (2002, 8, 9);

my $de = new HTML::Widgets::DateEntry(
                                      year      => ['date_year',  $date_year],
                                      month     => ['date_month', $date_month],
                                      day       => ['date_day',   $date_day],
                                      separator => '/',
                                      pre_year  => 1,
                                      post_year => 1,
                                      -iso      => 1,
                                     );

# test the manual


# the full rendered iso widget for 2002/08/09
my $isotarget = '<select name="date_year">
<option value="2001">2001</option>
<option value="2002" selected>2002</option>
<option value="2003">2003</option>
</select>/<select name="date_month">
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>
<option value="06">06</option>
<option value="07">07</option>
<option value="08" selected>08</option>
<option value="09">09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select>/<select name="date_day">
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>
<option value="06">06</option>
<option value="07">07</option>
<option value="08">08</option>
<option value="09" selected>09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
</select>';

ok( defined $de );
ok( $de->isa('HTML::Widgets::DateEntry') );
ok( $de->render_widget eq $isotarget );

# test an alternate rendering
# the full rendered us widget for 2002/08/09
my $ustarget = '<select name="date_month">
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>
<option value="06">06</option>
<option value="07">07</option>
<option value="08" selected>08</option>
<option value="09">09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select>-<select name="date_day">
<option value="01">01</option>
<option value="02">02</option>
<option value="03">03</option>
<option value="04">04</option>
<option value="05">05</option>
<option value="06">06</option>
<option value="07">07</option>
<option value="08">08</option>
<option value="09" selected>09</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
</select>-<select name="date_year">
<option value="2001">2001</option>
<option value="2002" selected>2002</option>
<option value="2003">2003</option>
<option value="2004">2004</option>
</select>';

undef $de;
$de = new HTML::Widgets::DateEntry(
                                   year      => ['date_year',  $date_year],
                                   month     => ['date_month', $date_month],
                                   day       => ['date_day',   $date_day],
                                   separator => '-',
                                   pre_year  => 1,
                                   post_year => 2,
                                   -us      => 1,
                                  );
ok( defined $de );
ok( $de->isa('HTML::Widgets::DateEntry') );
ok( $de->render_widget eq $ustarget );

exit;
__END__
