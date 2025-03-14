# استخدام صورة Ubuntu الأساسية
FROM ubuntu:22.04

# تثبيت FFmpeg و Nginx
RUN apt-get update && \
    apt-get install -y ffmpeg nginx && \
    apt-get clean

# تعيين المتغيرات البيئية (يمكن تعديلها عند تشغيل الحاوية)
ENV STREAM_URL="https://uselector.cdn.intigral-ott.net/MB2H/MB2H.isml/manifest.mpd"
ENV AUTH_TOKEN="58fa20cf6055f3aefc15707992c0b685"
ENV DECRYPTION_KEY="58fa20cf6055f3aefc15707992c0b685" # إضافة مفتاح فك التشفير

# إنشاء دليل HLS لمحتوى البث
RUN mkdir -p /var/www/hls

# نسخ ملفات الإعدادات الخاصة بـ Nginx والسكريبت
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY start.sh /start.sh

# منح الصلاحيات للسكريبت
RUN chmod +x /start.sh

# فتح منفذ Nginx
EXPOSE 80

# تشغيل السكريبت عند بدء الحاوية
CMD ["/start.sh"]
