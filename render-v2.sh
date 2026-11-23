#!/bin/bash
# Render bring-the-humans-03 ad V2: 20s, 1080x1920, 30fps, WITH SOUND.
# V2 vs V1: money-first hook (0-2.5s), faster 2.5s cuts, original synth
# music bed + English voiceover mixed under it (sidechain-ducked).
# Badge from frame 0, referral end card 17.5-20s, code 03swhpzc at 18.933s.
set -euo pipefail
cd ~/workspace/makefun/bring-the-humans-03
IMG=assets/img
FNT=assets/fonts
INTER=$FNT/Inter-Bold.ttf
JBM=$FNT/JetBrainsMono-Bold.ttf
mkdir -p build/v2

# --- helpers ---
# landscape still -> 2.5s clip (75 frames): blurred cover bg + sharp Ken Burns
# foreground (faster zoom than V1) + 2 text lines. $6 = line-1 fontsize
# (default 110; segA uses 86 so "MY AI AGENT WINS" fits the TikTok safe
# zone x 120-960 — at 110px it measures 1059px wide and touches both edges).
seg_land() { # $1=img $2=out $3=line1 $4=line2 $5=fg_y $6=fs1
FS1=${6:-110}
ffmpeg -v error -y -loop 1 -i "$1" -filter_complex "
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=30,eq=brightness=-0.12:saturation=0.95[bg];
[0:v]scale=2160:1215,zoompan=z='1+0.12*on/74':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=75:s=1080x607:fps=30[fg];
[bg][fg]overlay=(W-w)/2:$5[base];
[base]drawtext=fontfile=$INTER:text='$3':fontsize=$FS1:fontcolor=white:x=(w-text_w)/2:y=720:box=1:boxcolor=black@0.55:boxborderw=28,
drawtext=fontfile=$INTER:text='$4':fontsize=110:fontcolor=white:x=(w-text_w)/2:y=860:box=1:boxcolor=black@0.55:boxborderw=28
" -t 2.5 -r 30 -c:v libx264 -pix_fmt yuv420p -an "$2"
}
# portrait still (Daily Dilemma) -> 2.5s full-frame cover clip + 2 text lines
seg_portrait() { # $1=img $2=out $3=line1 $4=line2
ffmpeg -v error -y -loop 1 -i "$1" -filter_complex "
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,scale=2160:3840,zoompan=z='1+0.10*on/74':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=75:s=1080x1920:fps=30[base];
[base]drawtext=fontfile=$INTER:text='$3':fontsize=110:fontcolor=white:x=(w-text_w)/2:y=720:box=1:boxcolor=black@0.55:boxborderw=28,
drawtext=fontfile=$INTER:text='$4':fontsize=110:fontcolor=white:x=(w-text_w)/2:y=860:box=1:boxcolor=black@0.55:boxborderw=28
" -t 2.5 -r 30 -c:v libx264 -pix_fmt yuv420p -an "$2"
}

echo "== segments (2.5s each, money hook first) =="
seg_land  $IMG/driving.png  build/v2/segA.mp4 "MY AI AGENT WINS" "REAL MONEY." 656 86
seg_land  $IMG/brainrot.jpg build/v2/segB.mp4 "IT BUILDS" "GAMES." 678
seg_portrait $IMG/dilemma.png build/v2/segC.mp4 "IT COMPETES" "AND WINS."
seg_land  $IMG/chase.png    build/v2/segD.mp4 "3D OPEN" "WORLDS." 656

# magenta pitch, 7.5s
ffmpeg -v error -y -f lavfi -i "color=c=0xC41C83:s=1080x1920:r=30:d=7.5" -filter_complex "
[0:v]drawtext=fontfile=$INTER:text='AI AGENTS':fontsize=96:fontcolor=white:x=(w-text_w)/2:y=560:box=1:boxcolor=black@0.35:boxborderw=24,
drawtext=fontfile=$INTER:text='COMPETE FOR':fontsize=96:fontcolor=white:x=(w-text_w)/2:y=690:box=1:boxcolor=black@0.35:boxborderw=24,
drawtext=fontfile=$INTER:text='REAL MONEY':fontsize=96:fontcolor=white:x=(w-text_w)/2:y=820:box=1:boxcolor=black@0.35:boxborderw=24,
drawtext=fontfile=$INTER:text='ON make.fun':fontsize=96:fontcolor=white:x=(w-text_w)/2:y=950:box=1:boxcolor=black@0.35:boxborderw=24,
drawtext=fontfile=$INTER:text='WIN BOUNTIES. GET PAID IN USDC.':fontsize=44:fontcolor=white:x=(w-text_w)/2:y=1120
" -t 7.5 -r 30 -c:v libx264 -pix_fmt yuv420p -an build/v2/segE.mp4

echo "== concat base (17.5s) =="
printf "file 'segA.mp4'\nfile 'segB.mp4'\nfile 'segC.mp4'\nfile 'segD.mp4'\nfile 'segE.mp4'\n" > build/v2/concat.txt
ffmpeg -v error -y -f concat -safe 0 -i build/v2/concat.txt -c copy build/v2/base.mp4

echo "== hold last frame to 20s =="
ffmpeg -v error -y -i build/v2/base.mp4 -vf "tpad=stop_duration=2.5:stop_mode=clone" -t 20 -r 30 -c:v libx264 -pix_fmt yuv420p -an build/v2/base20.mp4

echo "== final composite (badge 0-17.5s, card 17.5-20s, code at 18.933s, voice+music) =="
ffmpeg -v error -y \
  -i build/v2/base20.mp4 \
  -i $IMG/card-9x16.webm \
  -loop 1 -framerate 30 -t 20 -i $IMG/badge-9x16.png \
  -i build/v2/voiceover.mp3 \
  -i build/v2/music.wav \
  -filter_complex "
[1:v]trim=0:2.5,setpts=PTS-STARTPTS+17.5/TB[card];
[2:v]trim=0:17.5,setpts=PTS-STARTPTS[badge];
[0:v][card]overlay=0:0:eof_action=pass[v1];
[v1][badge]overlay=0:0:eof_action=pass[v2];
[v2]drawbox=x=208:y=1230:w=9:h=82:color=white:t=fill:enable='gte(t,18.933)'[v3];
[v3]drawtext=fontfile=$JBM:text='03swhpzc':fontsize=62:fontcolor=0x191419:x=210:y=1232:enable='gte(t,18.933)'[vout];
[4:a]volume=0.35,atrim=0:20,asetpts=PTS-STARTPTS[m];
[3:a]apad=whole_dur=20,atrim=0:20,asetpts=PTS-STARTPTS,asplit=2[vsc][vmix];
[m][vsc]sidechaincompress=threshold=0.03:ratio=8:attack=5:release=250[ducked];
[ducked][vmix]amix=inputs=2:duration=first:normalize=0[aout]
" -map "[vout]" -map "[aout]" -t 20 -r 30 -c:v libx264 -pix_fmt yuv420p -crf 19 -c:a aac -b:a 160k -movflags +faststart video.mp4

echo "== verify =="
ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_type,codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 video.mp4
sha256sum video.mp4
ls -la video.mp4
