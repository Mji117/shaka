#!/bin/bash

# تسجيل بداية العملية
echo "$(date) - بدء عملية تحويل البث باستخدام FFmpeg..." >> /var/log/ffmpeg.log

# التحقق من وجود دالة مفتاح التشفير إذا كان البث مشفرًا
if [ -n "$DECRYPTION_KEY" ]; then
    echo "$(date) - استخدام مفتاح التشفير لفك التشفير" >> /var/log/ffmpeg.log
    DECRYPTION_OPTION="-decryption_key ${DECRYPTION_KEY}"
else
    echo "$(date) - لا يوجد مفتاح تشفير، البث غير مشفر" >> /var/log/ffmpeg.log
    DECRYPTION_OPTION=""
fi

# بدء FFmpeg مع فك التشفير (إذا كان موجودًا)
ffmpeg -headers "Authorization: Bearer ${AUTH_TOKEN}" \
  -i "${STREAM_URL}" \
  -c copy \
  -f hls \
  -hls_time 6 \
  -hls_list_size 0 \
  -hls_flags delete_segments \
  -hls_segment_filename "/var/www/hls/segment_%03d.ts" \
  ${DECRYPTION_OPTION} \
  "/var/www/hls/output.m3u8" &>> /var/log/ffmpeg.log &

# تسجيل إذا كانت FFmpeg تعمل في الخلفية
echo "$(date) - FFmpeg تعمل في الخلفية لتحويل البث" >> /var/log/ffmpeg.log

# التأكد من أن مجلد HLS يحتوي على الأذونات المناسبة
echo "$(date) - التحقق من الأذونات لمجلد HLS" >> /var/log/ffmpeg.log
chmod -R 755 /var/www/hls
chown -R www-data:www-data /var/www/hls

# بدء Nginx لتقديم البث
echo "$(date) - بدء Nginx لتقديم البث عبر HLS..." >> /var/log/ffmpeg.log
nginx -g "daemon off;" &>> /var/log/nginx.log

# تسجيل نهاية العملية
echo "$(date) - Nginx بدأ بنجاح" >> /var/log/ffmpeg.log
