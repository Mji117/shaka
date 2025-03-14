FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت الحزم الضرورية
RUN apt-get update && apt-get install -y \
    wget curl unzip sudo nano gnupg2 \
    mysql-server nginx \
    php-fpm php-mysql php-cli php-mbstring php-xml php-curl php-zip php-gd php-ldap \
    && apt-get clean

# تنزيل Ministra Stalker
RUN wget https://archive.org/download/ministra-5.6.0/ministra-5.6.0.zip -O /tmp/ministra.zip && \
    unzip /tmp/ministra.zip -d /var/www/html && \
    rm /tmp/ministra.zip

# إعداد صلاحيات الملفات
RUN chown -R www-data:www-data /var/www/html/stalker_portal && \
    chmod -R 755 /var/www/html/stalker_portal

# تهيئة MySQL وضبط الصلاحيات
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && \
    service mysql start && \
    mysql -e "CREATE DATABASE stalker_db;" && \
    mysql -e "CREATE USER 'stalker'@'%' IDENTIFIED BY 'stalker_pass';" && \
    mysql -e "GRANT ALL PRIVILEGES ON stalker_db.* TO 'stalker'@'%';" && \
    mysql -e "FLUSH PRIVILEGES;"

# إعداد Nginx
COPY nginx.conf /etc/nginx/sites-available/default

# تشغيل الخدمات وضمان استمرار التشغيل
CMD service mysql start && \
    service nginx start && \
    service php7.4-fpm start && \
    tail -f /dev/null
