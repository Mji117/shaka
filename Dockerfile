FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# تحديث الحزم وتثبيت الحزم الأساسية
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    unzip \
    sudo \
    nano \
    gnupg2 \
    mysql-server \
    nginx \
    php-fpm php-mysql php-cli php-mbstring php-xml php-curl php-zip php-gd php-ldap \
    && apt-get clean

# تنزيل Ministra Stalker من Archive.org
RUN wget https://archive.org/download/ministra-5.6.0/ministra-5.6.0.zip -O /tmp/ministra.zip && \
    unzip /tmp/ministra.zip -d /var/www/html && \
    rm /tmp/ministra.zip

# إعداد صلاحيات الملفات
RUN chown -R www-data:www-data /var/www/html/stalker_portal && \
    chmod -R 755 /var/www/html/stalker_portal

# تهيئة MySQL
RUN service mysql start && \
    mysql -e "CREATE DATABASE stalker_db;" && \
    mysql -e "CREATE USER 'stalker'@'localhost' IDENTIFIED BY 'stalker_pass';" && \
    mysql -e "GRANT ALL PRIVILEGES ON stalker_db.* TO 'stalker'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# إعداد Nginx
COPY nginx.conf /etc/nginx/sites-available/default

# فتح المنافذ المطلوبة
EXPOSE 80 443

# تشغيل الخدمات
CMD service mysql start && service nginx start && service php7.4-fpm start && tail -f /dev/null
