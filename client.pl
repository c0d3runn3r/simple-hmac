#!/usr/bin/perl

#
# Simple HMAC client
#
# @author c0d3runn3r Dec 06 2013 Oregon, USA
# 

use strict;
use warnings;
use LWP;
use Digest::SHA qw(hmac_sha1_base64);
use Digest::MD5 qw(md5_hex);
use DateTime;
use Data::Dumper;


# Parameters
my $access_id="jdoe";
my $access_key="Shh! This is secret!";
my $resource="/resource/some/thing";
my $service="http://192.168.56.101/simple-hmac";
my $content="";
my $content_type="text/plain";



#The string to be signed is formed by appending the REST verb, content-md5 value, content-type value, date value, canonicalized x-amz headers

# Prepare the request
my $browser=LWP::UserAgent->new;
my $req = HTTP::Request->new( GET => "$service/$resource");
$req->content_type($content_type);
$req->content($content);

# Calculate and set the required headers
my $date=DateTime->now()->strftime('%a, %d %b %Y %H:%M:%S %z');
my $content_md5=md5_hex($content);
$req->header("Date", $date);
$req->header("Content-Md5", $content_md5);

# Calculate the digest. Pad it (the Digest:: function doesn't do this for us for some reason)
my $canonical_string="GET\n$content_md5\n$content_type\n$date\n$resource";


$access_id="44CF9590006BF252F707";
$access_key="OtxrzxIsfpFjA7SwPzILwy8Bw21TLhquhboDYROV";
$canonical_string="PUT\nc8fdb181845a4ca6b8fec737b3581d76\ntext/html\nThu, 17 Nov 2005 18:49:58 GMT\nx-amz-magic:abracadabra\nx-amz-meta-author:foo\@bar.com\n/quotes/nelson";

my $digest=hmac_sha1_base64($canonical_string,$access_key);
while (length($digest) % 4) {

	$digest.="=";
}

$req->header("Authorization", "AWS ".$access_id.":".$digest);




print Dumper($req);
exit();



# my $digest=sha256_base64("GET $service/$resource".$secret.$nonce.$timestamp);


# $req->header("Authorization", "hmac $timestamp:$nonce:$digest");

# print Dumper($req);
# exit();

my $response=$browser->request($req);
$response->is_success or die("Unable to request resource: ".$response->status_line."\n");

print $response->content;





