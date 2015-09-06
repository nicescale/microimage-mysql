
![logo](https://csphere.cn/assets/d553e966-da1c-4eeb-b713-e17a10e62f21)

## 启动一个MySQL容器

```console
$ image=index.csphere.cn/microimages/mysql
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d $image
```

... 这里 `some-mysql` 是容器的名称, `my-secret-pw` 是MySQL的root用户密码。

## 连接到MySQL数据库

MySQL镜像导出了3306端口，因此应用容器可以通过link的方法获取到MySQL的相关connect参数.

```console
$ docker run --name some-app --link some-mysql:mysql -d app-that-uses-mysql
```

... app容器中，可以通过名字或环境变量来访问数据库

## 使用MySQL命令行客户端来访问数据库

```console
$ docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

... 这里 `some-mysql` 是MySQL容器的名称。

## 进入数据库容器的Shell

```console
$ docker exec -it some-mysql bash
```

## 查看数据库容器的日志
The MySQL Server log is available through Docker's container log:

```console
$ docker logs some-mysql
```

## 自定义MySQL的配置文件

MySQL的配置文件路径是 `/etc/mysql/my.cnf`, 该文件包含了 `/etc/mysql/conf.d` 目录下的所有 `*.cnf` 文件。如果想自定义一些配置，可以通过volume的方式放到 `/etc/mysql/conf.d` 目录下面。

假设 `/my/custom/config-file.cnf` 是自定义配置文件，可以这样启动MySQL容器：

```console
image=index.csphere.cn/microimages/mysql
$ docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d $image
```

这个MySQL容器实例将会读区 `/etc/mysql/conf.d/config-file.cnf` 里的配置并生效。

注意使用SELinux的用户可能会碰到问题，可以禁用SELinux或者赋予该配置相关的SeLinux策略才行。

```console
$ chcon -Rt svirt_sandbox_file_t /my/custom
```

## 环境变量

当你从 `index.csphere.cn/microimages/mysql` 镜像创建容器时，你可以通过传递环境变量来调整MySQL实例的配置。

### `MYSQL_ROOT_PASSWORD`

这个变量用来设置MySQL实例的超级用户 `root` 的密码。在上面的例子中，我们设为了 `my-secret-pw` 。

### `MYSQL_DATABASE`

这个变量属于可选，允许你在启动容器时创建一个db，如果同时还指定了该数据库的用户名密码(见下面的环境变量说明)，那么创建该db时，会同时做好授权操作。

### `MYSQL_USER`, `MYSQL_PASSWORD`

这2个变量可选，用于为数据库创建用户设置密码。注意超级用户 `root` 的密码是通过 `MYSQL_ROOT_PASSWORD` 设置的。

### `MYSQL_ALLOW_EMPTY_PASSWORD`

可选变量，如果设为 `yes` ，将允许数据库root用户空密码。不推荐。

## 数据存到哪里

Docker存储数据有几种方法：

-	使用docker volume来管理数据库数据。这种方法的弊端是，在容器外面不好定位管理。
-	将主机上的目录映射到容器中。这种方法的弊端是数据外挂，另外的问题是需要考虑好uid权限。

1.	创建一个合适的主机目录，比如 `/my/own/datadir`.
2.	启动MySQL容器:

	```console
	$ image=index.csphere.cn/microimages/mysql
	$ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d $image
	```

上述命令，会将 `/my/own/datadir` 挂载到容器里的 `/var/lib/mysql` 上(类似 `mount --bind` )。MySQL将会把数据写到该目录。

注意SELinux需要policy type:

```console
$ chcon -Rt svirt_sandbox_file_t /my/own/datadir
```

## 授权和法律

该镜像由希云制造，未经允许，任何第三方企业和个人，不得重新分发。违者必究。

## 支持和反馈

该镜像由希云为企业客户提供技术支持和保障，任何问题都可以直接反馈到: `docker@csphere.cn`
