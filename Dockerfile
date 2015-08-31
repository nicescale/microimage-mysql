from       microimages/alpine

maintainer william <wlj@nicescale.com>

label service=mysql

env MYSQL_MAJOR 5.5
env MYSQL_VERSION 5.5.45

run wget -O /tmp/mysql.tar.gz "http://dev.mysql.com/get/Downloads/MySQL-$MYSQL_MAJOR/mysql-$MYSQL_VERSION-linux2.6-x86_64.tar.gz" \
	&& mkdir /usr/local/mysql \
	&& tar -xzf /tmp/mysql.tar.gz -C /usr/local/mysql \
	&& cd /usr/local/mysql/mysql-*/ && mv * ../ && cd .. && rmdir mysql-${MYSQL_VERSION}* \
	&& rm -f /tmp/mysql.tar.gz \
	&& rm -rf /usr/local/mysql/mysql-test /usr/local/mysql/sql-bench \
	&& rm -rf /usr/local/mysql/bin/*-debug /usr/local/mysql/bin/*_embedded \
	&& find /usr/local/mysql -type f -name "*.a" -delete \
	&& apk add --update binutils \
	&& { find /usr/local/mysql -type f -perm /111 -exec strip --strip-all '{}' + || true; } \
	&& apk del --purge binutils && rm -fr /var/cache/apk/*

env PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

run mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'user = mysql'; \
		echo 'datadir = /var/lib/mysql'; \
		echo '!includedir /etc/mysql/conf.d/'; \
	} > /etc/mysql/my.cnf

volume /var/lib/mysql

copy docker-entrypoint.sh /entrypoint.sh

entrypoint ["/entrypoint.sh"]

expose 3306
cmd ["mysqld"]
