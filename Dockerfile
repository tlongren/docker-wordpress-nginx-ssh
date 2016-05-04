FROM ubuntu:14.04
MAINTAINER BaseBoxOrg <developer@basebox.org>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
RUN mkdir /var/run/sshd

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y install mysql-server mysql-client imagemagick graphicsmagick nginx php7.0-fpm php7.0-mysql php-apc pwgen python-setuptools curl git wget less unzip openssh-server openssl

# Wordpress Requirements
#RUN apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl
RUN apt-get -y install php7.0-curl php7.0-gd php7.0-intl php-pear php-imagick php7.0-imap php7.0-mcrypt \
    php-memcache php-memcached php7.0-zip php7.0-ps php7.0-pspell php7.0-recode php7.0-snmp php7.0-sqlite \
    php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-cli php7.0-json php7.0-sqlite3 php7.0-ldap php7.0-opcache \
    php7.0-soap php7.0-mbstring php7.0-bz2
# mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/fpm/pool.d/www.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf

# Add system user for Wordpress
RUN useradd -m -d /home/wordpress -p $(openssl passwd -1 'wordpress') -G root -s /bin/bash wordpress \
    && usermod -a -G www-data wordpress \
    && usermod -a -G sudo wordpress \
    && ln -s /usr/share/nginx/www /home/wordpress/www

# Install Wordpress
ADD http://wordpress.org/latest.tar.gz /usr/share/nginx/latest.tar.gz
RUN cd /usr/share/nginx/ \
    && tar xvf latest.tar.gz \
    && rm latest.tar.gz

RUN mv /usr/share/nginx/html/5* /usr/share/nginx/wordpress \
    && rm -rf /usr/share/nginx/www

RUN mv /usr/share/nginx/wordpress /usr/share/nginx/www \
    && chown -R www-data:www-data /usr/share/nginx/www \
    && chmod -R 775 /usr/share/nginx/www

# Wordpress Initialization and Startup Script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

#NETWORK PORTS
# private expose
EXPOSE 3306
EXPOSE 80
EXPOSE 22

# volume for mysql database and wordpress install
VOLUME ["/var/lib/mysql", "/usr/share/nginx/www", "/var/run/sshd"]

CMD ["/bin/bash", "/start.sh"]
