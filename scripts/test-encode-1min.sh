#!/bin/bash

x264enc='libx264 -profile:v high -bf 3 -refs 3'

# Encoding settings for nvenc (GPU based encoder)

nvenc='h264_nvenc -profile:v high -bf 3 -refs 3 -forced-idr 1 -temporal-aq 1 -spatial-aq 1'

ffmpeg \
    -y \
    -i ${1} \
    -filter_complex \
    "[0:v]format=yuv420p,split=6[1][2][3][4][5][6]; \
    [1]scale=384:-2[1out]; \
    [2]scale=512:-2[2out]; \
    [3]scale=640:-2[3out]; \
    [4]scale=960:-2[4out]; \
    [5]scale=1280:-2[5out]; \
    [6]scale=1920:-2[6out]" \
    -map '[1out]' -c:v:0 ${x264enc} -preset:v:0 medium -force_key_frames 'expr:gte(t,n_forced*5)' -b:v:0 800k \
    -map '[2out]' -c:v:1 ${x264enc} -preset:v:1 medium -force_key_frames 'expr:gte(t,n_forced*5)' -b:v:1 1600k \
    -map '[3out]' -c:v:2 ${x264enc} -preset:v:2 medium -force_key_frames 'expr:gte(t,n_forced*5)' -b:v:2 2200k \
    -map '[4out]' -c:v:3 ${x264enc} -preset:v:3 medium -force_key_frames 'expr:gte(t,n_forced*5)' -b:v:3 4400k \
    -map '[5out]' -c:v:4 ${x264enc} -preset:v:4 medium -force_key_frames 'expr:gte(t,n_forced*5)' -b:v:4 6600k \
    -map '[6out]' -c:v:5 ${x264enc} -preset:v:5 medium -force_key_frames 'expr:gte(t,n_forced*5)' -b:v:5 12000k \
    -map 0:a \
    -c:a:0 aac \
    -b:a 128k \
    -t 60 \
    -movflags faststart \
    ${2}.mp4

# -map 0:a
#    -i ${1} \
#    -c:v h264_qsv \
