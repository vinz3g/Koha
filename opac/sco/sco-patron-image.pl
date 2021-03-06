#!/usr/bin/perl
#
# Copyright 2009 LibLime
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use strict;
use warnings;
use C4::Service;
use C4::Members;
use Koha::Patron::Images;

my ($query, $response) = C4::Service->init(circulate => 'self_checkout');

unless (C4::Context->preference('WebBasedSelfCheck')) {
    print $query->header(status => '403 Forbidden - web-based self-check not enabled');
    exit;
}
unless (C4::Context->preference('ShowPatronImageInWebBasedSelfCheck')) {
    print $query->header(status => '403 Forbidden - displaying patron images in self-check not enabled');
    exit;
}

my ($borrowernumber) = C4::Service->require_params('borrowernumber');

my $patron_image = Koha::Patron::Images->find($borrowernumber);

if ($patron_image) {
    print $query->header(
        -type           => $patron_image->mimetype,
        -Content_Length => length( $patron_image->imagefile )
      ),
      $patron_image->imagefile;
} else {
    print $query->header(status => '404 patron image not found');
}
