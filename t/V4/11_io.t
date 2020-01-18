use strict;
use warnings;
use Path::Tiny;

use Test::More tests => 6;
use Data::Section::Simple qw(get_data_section);

use lib qw(./lib);

BEGIN { use_ok ('Text::vCard::Precisely::V4') };        #1

my $vc = Text::vCard::Precisely::V4->new();
is 'Text::vCard::Precisely::V4', ref($vc), 'new()';     #2

$vc = Text::vCard::Precisely::V4->new({});
is 'Text::vCard::Precisely::V4', ref($vc), 'new({})';   #3

my $hashref = {
    N   => [ 'Gump', 'Forrest', '', 'Mr.', '' ],
    FN  => 'Forrest Gump',
    ORG => 'Bubba Gump Shrimp Co.',
    TITLE => 'Shrimp Man',
    PHOTO => { media_type => 'image/gif', content => 'http://www.example.com/dir_photos/my_photo.gif' },
    TEL => [
        { types => ['WORK','VOICE'], content => '(111) 555-1212' },
        { types => ['HOME','VOICE'], content => '(404) 555-1212' },
    ],
    ADR =>[{
        types       => ['work'],
        pref        => 1,
        extended    => 100,
        street      => 'Waters Edge',
        city        => 'Baytown',
        region      => 'LA',
        post_code   => '30314',
        country     => 'United States of America'
    },{
        types       => ['home'],
        extended    => 42,
        street      => 'Plantation St.',
        city        => 'Baytown',
        region      => 'LA',
        post_code   => '30314',
        country     => 'United States of America'
    }],
    URL => 'http://www.example.com/dir_photos/my_photo.gif',
    EMAIL => 'forrestgump@example.com',
    REV => '20080424T195243Z',
};

my $data = get_data_section('data.vcf');
$data =~ s/\n/\r\n/g;

my $string = $vc->load_hashref($hashref)->as_string();
is $string, $data, 'as_string()';                       #4

my $in_file = path( 't', 'V4', 'expected.vcf' );
$string = $vc->load_file($in_file)->as_string();
my $expected_content = $in_file->slurp_utf8;
is $string, $expected_content, 'load_file()';           #5

my $load_s = $vc->load_string($data);
is $load_s->as_string(), $data, 'load_string()';        #6

done_testing;

__DATA__

@@ data.vcf
BEGIN:VCARD
VERSION:4.0
FN:Forrest Gump
N:Gump;Forrest;;Mr.;
ADR;TYPE=WORK;PREF=1:;100;Waters Edge;Baytown;LA;30314;United States of
  America
ADR;TYPE=HOME:;42;Plantation St.;Baytown;LA;30314;United States of America
TEL;TYPE=WORK,VOICE;VALUE=uri:tel:111 555 1212
TEL;TYPE=HOME,VOICE;VALUE=uri:tel:404 555 1212
EMAIL:forrestgump@example.com
ORG:Bubba Gump Shrimp Co.
TITLE:Shrimp Man
URL:http://www.example.com/dir_photos/my_photo.gif
PHOTO;MEDIATYPE=image/gif:http://www.example.com/dir_photos/my_photo.gif
REV:20080424T195243Z
END:VCARD
