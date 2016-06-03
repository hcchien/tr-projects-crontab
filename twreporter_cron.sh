#! /bin/bash

# get full directory name of the script no matter where it is being called from
file_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $file_path
echo 'moving photos in keystone'
/usr/bin/env python movePhotos.py
echo 'making rss'
/usr/bin/env perl rss.pl
echo 'update articles'
#/usr/bin/env perl sync_articles.pl
