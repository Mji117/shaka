FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY master.m3u8 audio.m3u8 video.m3u8 key.bin /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
