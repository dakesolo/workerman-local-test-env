FROM centos:7
MAINTAINER dakesole 569072171@qq.com

RUN yum update -y && yum -y install wget pcre pcre-devel openssl openssl-devel libicu-devel gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel ncurses ncurses-devel curl curl-devel krb5-devel libidn libidn-devel openldap openldap-devel nss_ldap jemalloc-devel cmake boost-devel bison automake libevent libevent-devel gd gd-devel libtool* libmcrypt libmcrypt-devel mcrypt mhash libxslt libxslt-devel readline readline-devel gmp gmp-devel libcurl libcurl-devel openjpeg-devel && yum clean all

ADD php-7.2.22.tar.gz /tmp/
RUN cd /tmp/php-7.2.22 && \
       ./configure --prefix=/usr/local/php \
	   --with-config-file-path=/usr/local/php/etc \
	   --with-config-file-scan-dir=/usr/local/php/conf.d \
	   --with-pdo-mysql=mysqlnd --with-iconv-dir \
	   --with-freetype-dir=/usr/local/freetype \
	   --with-jpeg-dir \
	   --with-png-dir \
	   --with-zlib \
	   --with-libxml-dir=/usr \
	   --with-curl \
	   --with-gd \
	   --with-openssl \
	   --with-mhash \
	   --with-xmlrpc \
	   --with-gettext \
	   --enable-xml \
	   --disable-rpath \
	   --enable-bcmath \
	   --enable-shmop \
	   --enable-sysvsem \
	   --enable-inline-optimization \
	   --enable-mbregex \
	   --enable-mbstring \
	   --enable-intl \
	   --enable-pcntl \
	   --enable-ftp \
	   --enable-sockets \
	   --enable-zip \
	   --enable-soap \
	   --enable-mysqlnd --with-mysqli=mysqlnd \
	   --enable-opcache && \
	   make -j 4 && make install && \
	   cp /tmp/php-7.2.22/php.ini-production /usr/local/php/etc/php.ini && \
	   sed -i 's/post_max_size =.*/post_max_size = 50M/g' /usr/local/php/etc/php.ini && \
	   sed -i 's/upload_max_filesize =.*/upload_max_filesize = 50M/g' /usr/local/php/etc/php.ini && \
	   sed -i 's/;date.timezone =.*/date.timezone = PRC/g' /usr/local/php/etc/php.ini && \
	   sed -i 's/short_open_tag =.*/short_open_tag = On/g' /usr/local/php/etc/php.ini && \
	   sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini && \
	   sed -i 's/max_execution_time =.*/max_execution_time = 300/g' /usr/local/php/etc/php.ini && \
	   sed -i 's/disable_functions =.*/disable_functions = passthru,system,chroot,chgrp,chown,proc_open,proc_get_status,popen,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru/g' /usr/local/php/etc/php.ini && \
	   rm -rf /tmp/php-7.2.22

RUN echo PATH=$PATH:/usr/local/php/bin >> /etc/profile && echo export PATH >> /etc/profile && \
	source /etc/profile && \
	ln -s /usr/local/php/bin/php /usr/bin/php -f

ADD event-2.5.3.tgz /tmp/
RUN cd /tmp/event-2.5.3 && \
    /usr/local/php/bin/phpize && \
    ./configure --with-php-config=/usr/local/php/bin/php-config && \
    make && make install && \
    echo extension=event.so >> /usr/local/php/etc/php.ini && \
	rm -rf /tmp/event-2.5.3

ADD redis-5.0.2.tgz /tmp/
RUN cd /tmp/redis-5.0.2 && \
    /usr/local/php/bin/phpize && \
    ./configure --with-php-config=/usr/local/php/bin/php-config && \
    make && make install && \
    echo extension=redis.so >> /usr/local/php/etc/php.ini && \
	rm -rf /tmp/redis-5.0.2

RUN mkdir -p /home/wwwroot
WORKDIR /home/wwwroot