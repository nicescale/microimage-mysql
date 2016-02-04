from       microimages/alpine

maintainer william <wlj@nicescale.com>

label service=mysql

run wget -O /tmp/mysql.apk http://dl-3.alpinelinux.org/alpine/v3.1/main/x86_64/mysql-5.5.44-r0.apk \
	&& wget -O /tmp/mysql-client.apk http://dl-3.alpinelinux.org/alpine/v3.1/main/x86_64/mysql-client-5.5.44-r0.apk \
	&& wget -O /tmp/mysql-common.apk http://dl-3.alpinelinux.org/alpine/v3.1/main/x86_64/mysql-common-5.5.44-r0.apk \
	&& apk add --update libaio libstdc++ \
	&& apk add /tmp/mysql-common.apk /tmp/mysql.apk /tmp/mysql-client.apk \
	&& rm -f /tmp/mysql* && rm -fr /var/cache/apk/* && rm -f /usr/bin/*_embedded

run mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'user = mysql'; \
		echo 'datadir = /var/lib/mysql'; \
		echo '!includedir /etc/mysql/conf.d/'; \
	} > /etc/mysql/my.cnf \
	&& uid=`stat -c %u /var/run/mysqld` \
	&& adduser -s /sbin/nologin -H -D -u $uid mysql

volume /var/lib/mysql

copy docker-entrypoint.sh /entrypoint.sh

#entrypoint ["/entrypoint.sh"]

expose 3306
cmd ["/entrypoint.sh", "mysqld"]
