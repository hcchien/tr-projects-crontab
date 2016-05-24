#!/usr/bin/env perl
use utf8;
use strict;
use XML::RSS;
use LWP::Simple;
use JSON;
use POSIX qw(strftime);
my $rss = new XML::RSS(version => '2.0');
$rss->channel(
    title => "報導者",
    description => "報導者－深入挖掘新聞",
    link => "https://www.twreporter.org/",
    copyright => "CC BY-NC-ND 3.0",
    language => "zh-TW"
);
$rss->image(
    title => "報導者",
    url => "https://www.twreporter.org/asset/favicon.png",
    link => "https://www.twreporter.org/",
);

my $api = decode_json(get('http://api-v2.twreporter.org:8080/posts?max_results=100&sort=-publishedDate'));
for (@{ $api->{_items} }) {
    # $_->{story_link} =~ s/\s//g;
    $_->{title} =~ s/[\x00-\x19]//g; # strip control characters
    my $byline = '';
    for my $writer_ref (@{ $_->{writers} }) {
        $byline .= $writer_ref->{name}
    }
    $rss->add_item(
        title => $_->{title},
        description => $_->{og_description} || $_->{content}->{brief}->{draft}->{apiData}->[0]->{content}->[0] || '',
        permaLink => ('https://www.twreporter.org/a/'.$_->{slug} or next),
        link => ('https://www.twreporter.org/a/'.$_->{slug} or next),
        enclosure => { url => ( $_->{heroImage}->{image}->{url} or '' ), type => ( $_->{heroImage}->{image}->{filetype} or '' ), length => ( $_->{heroImage}->{image}->{size} or '' ) },
        dc => {
            creator => ($byline or "報導者"),
        },
        pubDate => strftime("%a, %d %b %Y %H:%M:%S %z", localtime($_->{publishedDate})),
    );
}
$rss->save("/tmp/twreporters/articles/rss2.xml");
