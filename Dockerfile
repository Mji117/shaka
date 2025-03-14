# 使用轻量级 Ubuntu 基础镜像
FROM ubuntu:22.04

# 安装 FFmpeg 和 Nginx
RUN apt-get update && \
    apt-get install -y ffmpeg nginx && \
    apt-get clean

# 设置环境变量（可在运行容器时覆盖）
ENV STREAM_URL="https://uselector.cdn.intigral-ott.net/MB2H/MB2H.isml/manifest.mpd"
ENV AUTH_TOKEN="58fa20cf6055f3aefc15707992c0b685"

# 创建 HLS 输出目录
RUN mkdir -p /var/www/hls

# 复制 Nginx 配置和启动脚本
COPY nginx.conf /etc/nginx/sites-enabled/default
COPY start.sh /start.sh

# 设置权限
RUN chmod +x /start.sh

# 暴露 Nginx 端口
EXPOSE 80

# 启动命令
CMD ["/start.sh"]
