from       microimages/alpine

maintainer william <wlj@nicescale.com>

ENV MYSQL_MAJOR 5.5
ENV MYSQL_VERSION 5.5.45

ADD "http://dev.mysql.com/get/Downloads/MySQL-$MYSQL_MAJOR/mysql-$MYSQL_VERSION-linux2.6-x86_64.tar.gz" /tmp/mysql.tar.gz 
RUN mkdir /usr/local/mysql \
	&& tar -xzf /tmp/mysql.tar.gz -C /usr/local/mysql --strip-components=1 \
	&& rm /tmp/mysql.tar.gz \
	&& rm -rf /usr/local/mysql/mysql-test /usr/local/mysql/sql-bench \
	&& rm -rf /usr/local/mysql/bin/*-debug /usr/local/mysql/bin/*_embedded \
	&& find /usr/local/mysql -type f -name "*.a" -delete \
	&& { find /usr/local/mysql -type f -executable -exec strip --strip-all '{}' + || true; }

ENV PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

RUN mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'user = mysql'; \
		echo 'datadir = /var/lib/mysql'; \
		echo '!includedir /etc/mysql/conf.d/'; \
	} > /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
