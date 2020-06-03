#!/bin/bash

sudo ffmpeg \
    -fflags +genpts \
    -stream_loop -1 \
    -re \
    -i ${1} \
    -map 0:0 -c:v:0 copy -b:v:0 800k \
    -map 0:1 -c:v:1 copy -b:v:1 1600k \
    -map 0:2 -c:v:2 copy -b:v:2 2200k \
    -map 0:3 -c:v:3 copy -b:v:3 4400k \
    -map 0:4 -c:v:4 copy -b:v:4 6600k \
    -map 0:5 -c:v:5 copy -b:v:5 12000k \
    -map 0:6 -c:a:0 copy -b:a 128k  \
    -use_timeline 1 \
    -use_template 1 \
    -window_size 5 \
    -seg_duration 5 \
    -remove_at_exit 1 \
    -hls_playlist 1 \
    -index_correction 1 \
    -utc_timing_url "https://time.akamai.com/?iso" \
    -adaptation_sets "id=0,streams=v id=1,streams=a" \
    /opt/streamline/manifests/docflix.mpd
