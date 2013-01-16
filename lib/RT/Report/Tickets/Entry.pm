# BEGIN BPS TAGGED BLOCK {{{
#
# COPYRIGHT:
#
# This software is Copyright (c) 1996-2013 Best Practical Solutions, LLC
#                                          <sales@bestpractical.com>
#
# (Except where explicitly superseded by other copyright notices)
#
#
# LICENSE:
#
# This work is made available to you under the terms of Version 2 of
# the GNU General Public License. A copy of that license should have
# been provided with this software, but in any event can be snarfed
# from www.gnu.org.
#
# This work is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 or visit their web page on the internet at
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.html.
#
#
# CONTRIBUTION SUBMISSION POLICY:
#
# (The following paragraph is not intended to limit the rights granted
# to you to modify and distribute this software under the terms of
# the GNU General Public License and is only of importance to you if
# you choose to contribute your changes and enhancements to the
# community by submitting them to Best Practical Solutions, LLC.)
#
# By intentionally submitting any modifications, corrections or
# derivatives to this work, or any other work intended for use with
# Request Tracker, to Best Practical Solutions, LLC, you confirm that
# you are the copyright holder for those contributions and you grant
# Best Practical Solutions,  LLC a nonexclusive, worldwide, irrevocable,
# royalty-free, perpetual, license to use, copy, create derivative
# works based on those contributions, and sublicense and distribute
# those contributions and any derivatives thereof.
#
# END BPS TAGGED BLOCK }}}

package RT::Report::Tickets::Entry;

use warnings;
use strict;

use base qw/RT::Record/;

# XXX TODO: how the heck do we acl a report?
sub CurrentUserHasRight {1}

=head2 LabelValue

If you're pulling a value out of this collection and using it as a label,
you may want the "cleaned up" version.  This includes scrubbing 1970 dates
and ensuring that dates are in local not DB timezones.

=cut

sub LabelValue {
    my $self  = shift;
    my $field = shift;
    my $value = $self->__Value( $field );

    if ( $field =~ /(Daily|Monthly|Annually|Hourly)$/ ) {
        my $re;
        # it's not just 1970-01-01 00:00:00 because of timezone shifts
        # and conversion from UTC to user's TZ
        $re = qr{19(?:70-01-01|69-12-31) [0-9]{2}} if $field =~ /Hourly$/;
        $re = qr{19(?:70-01-01|69-12-31)} if $field =~ /Daily$/;
        $re = qr{19(?:70-01|69-12)} if $field =~ /Monthly$/;
        $re = qr{19(?:70|69)} if $field =~ /Annually$/;
        $value =~ s/^$re/Not Set/;
    }

    return $value;
}

sub ObjectType {
    return 'RT::Ticket';
}

RT::Base->_ImportOverlays();

1;
