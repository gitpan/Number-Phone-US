# $Id: DateEntry.pm,v 1.5 2000/12/18 15:22:27 kennedyh Exp $

=pod

=head1 NAME

HTML::Widgets::DateEntry - creates date entry widgets for HTML forms.

=head1 SYNOPSIS

  use HTML::Widgets::DateEntry;

  $de = new HTML::Widgets::DateEntry(
				     year      => ['date_year',  $date_year], 
				     month     => ['date_month', $date_month], 
				     day       => ['date_day',   $date_day],
				     separator => '/',
				     pre_year  => 1,
				     post_year => 1,
				     -iso      => 1,
				    );

  print $de->render_widget;

=head1 DESCRIPTION

HTML::Widgets::DateEntry is a simple module to generate HTML date entry widgets.

Currently generates widgets that look like:

  [YYYY]/[MM]/[DD]

Will be able to generate

  [MM]/[DD]/[YYYY]

  [YYYY]/[MM]

  [MM]/[YYYY]

  [YYYY]

=over 8

=cut
  
package HTML::Widgets::DateEntry;

require 5;

use strict;
use vars qw($VERSION @EXPORT_OK %EXPORT_TAGS @ISA);
use Carp;

require Exporter;

@ISA = qw(Exporter);

$VERSION = (split / /, q$Id: DateEntry.pm,v 1.5 2000/12/18 15:22:27 kennedyh Exp $ )[2];

%EXPORT_TAGS = ( );
@EXPORT_OK = qw(&render_widget);

# prototypes
#
sub new           (% ); # XXX?
sub render_widget ();
sub _year_frag    ($$$$ );
sub _month_frag   ($$ );
sub _day_frag     ($$ );


# defaults
#
my $DEFAULT_SEPARATOR = '/';
my $DEFAULT_PRE_YEAR  = 1;
my $DEFAULT_POST_YEAR = 1;


################
#
=pod

=item new(% );

Use like
    $de = new HTML::Widgets::DateEntry(year => ['date_year',$year], month => ['date_month',$month], day => ['date_day',$day]);

returns a date entry widget object
with the fields named as specified.

if defaults are not provided, values from localtime will be used.

this will get better :-)

=cut
#
#################

sub new (% ) {
  my $proto = shift;
  my $class = ref($proto) || $proto;

  my $self = {};
  my (%params) = @_;

  my($year_field_name, $month_field_name, $day_field_name)          = map { $_->[0] } @params{'year','month','day'};
  my($year_field_default, $month_field_default, $day_field_default) = map { $_->[1] } @params{'year','month','day'};

  $self = {
	   year_field_name     => $year_field_name,
	   month_field_name    => $month_field_name,
	   day_field_name      => $day_field_name,
	   year_field_default  => $year_field_default, 
	   month_field_default => $month_field_default, 
	   day_field_default   => $day_field_default,
	   separator           => $params{separator},
	   pre_year            => $params{pre_year},
	   post_year           => $params{post_year},
	   -iso                => $params{-iso},
	   -us                 => $params{-us},
	  };

  # XXX need some sanity checking on {pre,post}_year & friends.
  #     need to enforce consistency where needed.

  $self->{separator} ||= $DEFAULT_SEPARATOR;
  $self->{pre_year}  = $DEFAULT_PRE_YEAR  unless defined $self->{pre_year};
  $self->{post_year} = $DEFAULT_POST_YEAR unless defined $self->{post_year};

  if ( $self->{-us} and $self->{-iso} ) {
    $self->{-us}  = undef;
    $self->{-iso} = 1;
  }
  
  unless ( $self->{-us} or $self->{-iso} ) {
    $self->{-iso} = 1;
  }

  bless ($self, $class);
  return $self;
}


################
#
=pod

=item render_widget()

Use like
    print $de->render_widget;

returns a string representing an HTML date entry widget.
with the fields named as specified, and defaults set as specified
when the object was created.

this will get better :-)

=cut
#
#################

sub render_widget () {
  my ($self) = shift;

  my ($year_field_name, $month_field_name, $day_field_name)         
    = @{$self}{'year_field_name', 'month_field_name', 'day_field_name'};

  my ($year_field_default, $month_field_default, $day_field_default) 
    = @{$self}{'year_field_default', 'month_field_default', 'day_field_default'};

  my $separator = $self->{separator};
  my $pre_year  = $self->{pre_year};
  my $post_year = $self->{post_year};
  my $iso       = $self->{-iso};
  
  my @fragment;

  unless ( $year_field_default && $month_field_default ) {
    my ($day,$month,$year) = (localtime)[3,4,5];
    $year += 1900;
    $month++;
    
    ($year_field_default, $month_field_default, $day_field_default) = ($year,$month,$day);
  }

  if ( $iso ) { # YYYY/MM[/DD]
    @fragment = &_year_frag($year_field_name, $year_field_default, $pre_year, $post_year);

    if ( $month_field_name ) {
      push @fragment, &_month_frag($month_field_name, $month_field_default);
    }

    if ( $day_field_name ) {
      push @fragment, &_day_frag($day_field_name, $day_field_default);
    }
  } else {      # MM[/DD]/YYYY

    if ( $month_field_name ) {
      @fragment = &_month_frag($month_field_name, $month_field_default);
    }

    if ( $day_field_name ) {
      push @fragment, &_day_frag($day_field_name, $day_field_default);
    }

    push @fragment, &_year_frag($year_field_name, $year_field_default, $pre_year, $post_year);
  }
  
  return join $separator, @fragment; 
}

################
#
#=pod
#
#=item _year_frag ($$$$ )
#
#Use like
#  $yf = _year_frag('year',2000,1,1);
#
#returns a year entry widget
#with the fields named as specified.
#
#=cut
#
#################

sub _year_frag ($$$$ ) {
  my ($year_field_name, $year_field_default, $pre_year, $post_year) = @_;

  my (@fragment, $selected);

  push @fragment, qq{<select name="$year_field_name">\n};

  foreach ( $year_field_default-$pre_year..$year_field_default+$post_year ) {
    if ( $_ eq $year_field_default ) {
      $selected = " selected";
    } else {
      $selected = "";
    }
    push @fragment, qq{<option value="$_"$selected>$_</option>\n};
  }

  push @fragment, qq{</select>};

  return join "", @fragment; 
}


################
#
#=pod
#
#=item _month_frag ($$ )
#
#Use like
#  $mf = _month_frag('month',11);
#
#returns a month entry widget
#with the fields named as specified.
#
#=cut
#
#################
#
# XXX should we do month names? (long, abbr.)
#
sub _month_frag ($$ ) {
  my ($month_field_name, $month_field_default) = @_;

  my (@fragment, $selected);

  push @fragment, qq{<select name="$month_field_name">\n};

  foreach ( 1..12 ) {
    if ( $_ eq $month_field_default ) {
      $selected = " selected";
    } else {
      $selected = "";
    }
    push @fragment, sprintf(qq{<option value="%02d"$selected>%02d</option>\n}, $_, $_);
  }
  
  push @fragment, qq{</select>};
  
  return join "", @fragment; 
}


################
#
#=pod
#
#=item _day_frag ($$ )
#
#Use like
#  $df = _day_frag('day',03);
#
#returns a day entry widget
#with the fields named as specified.
#
#=cut
#
#################

sub _day_frag ($$ ) {
  my ($day_field_name, $day_field_default) = @_;
  
  my (@fragment, $selected);
  
  push @fragment, qq{<select name="$day_field_name">\n};
  
  foreach ( 1..31 ) {
    if ( $_ eq $day_field_default ) {
      $selected = " selected";
    } else {
      $selected = "";
    }
    push @fragment, sprintf(qq{<option value="%02d"$selected>%02d</option>\n}, $_, $_);
  }
  
  push @fragment, "</select>";
  
  return join "", @fragment; 
}


=pod

=back

=head1 COPYRIGHT

   COPYRIGHT  2000 THE REGENTS OF THE UNIVERSITY OF MICHIGAN
   ALL RIGHTS RESERVED

   PERMISSION IS GRANTED TO USE, COPY, CREATE DERIVATIVE WORKS
   AND REDISTRIBUTE THIS SOFTWARE AND SUCH DERIVATIVE WORKS FOR
   NON-COMMERCIAL EDUCATION AND RESEARCH PURPOSES, SO LONG AS NO
   FEE IS CHARGED, AND SO LONG AS THE COPYRIGHT NOTICE ABOVE,
   THIS GRANT OF PERMISSION, AND THE DISCLAIMER BELOW APPEAR IN
   ALL COPIES MADE; AND SO LONG AS THE NAME OF THE UNIVERSITY
   OF MICHIGAN IS NOT USED IN ANY ADVERTISING OR PUBLICITY
   PERTAINING TO THE USE OR DISTRIBUTION OF THIS SOFTWARE
   WITHOUT SPECIFIC, WRITTEN PRIOR AUTHORIZATION.

   THIS SOFTWARE IS PROVIDED AS IS, WITHOUT REPRESENTATION AS
   TO ITS FITNESS FOR ANY PURPOSE,  AND WITHOUT WARRANTY OF ANY
   KIND,  EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT
   LIMITATION THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
   FITNESS FOR A PARTICULAR PURPOSE. THE REGENTS OF THE
   UNIVERSITY OF MICHIGAN SHALL NOT BE LIABLE FOR ANY DAMAGES,
   INCLUDING SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
   DAMAGES, WITH RESPECT TO ANY CLAIM ARISING OUT OF OR IN
   CONNECTION WITH THE USE OF THE SOFTWARE, EVEN IF IT HAS BEEN
   OR IS HEREAFTER ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

   ( This program is free software; you can redistribute it and/or
     modify it under the same terms as Perl itself. )

=head1 SEE ALSO

perl(1)

=head1 AUTHOR

Hugh Kennedy <kennedyh@engin.umich.edu>

     __|   \   __|  \ |
    (     _ \  _|  .  |
   \___|_/  Web Systems

=cut

'utterly false';
