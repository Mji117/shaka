#!/bin/bash

# 后台运行 FFmpeg 转换流
ffmpeg -headers "Authorization: Bearer ${AUTH_TOKEN}" \
  -i "${STREAM_URL}" \
  -c copy \
  -f hls \
  -hls_time 6 \
  -hls_list_size 0 \
  -hls_flags delete_segments \
  -hls_segment_filename "/var/www/hls/segment_%03d.ts" \
  "/var/www/hls/output.m3u8" &

# 前台运行 Nginx（保持容器不退出）
nginx -g "daemon off;"
