title: docker初识
date: 2018-04-24 09:11:44
tags:
- docker
categories: 杂说
---
> 参考链接： 
>   - [阮大神](http://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html)，有些介绍直接 copy 了阮大神的，因为阮大神写得很通俗易懂，嘿嘿

软件开发最大的麻烦事之一，就是环境配置。用户计算机的环境都不相同，你怎么知道自家的软件，能在那些机器跑起来？

用户必须保证两件事：操作系统的设置，各种库和组件的安装。只有它们都正确，软件才能运行。举例来说，安装一个 `Python` 应用，计算机必须有 `Python` 引擎，还必须有各种依赖，可能还要配置环境变量。

如果某些老旧的模块与当前环境不兼容，那就麻烦了。开发者常常会说："它在我的机器可以跑了"（It works on my machine），言下之意就是，其他机器很可能跑不了。

环境配置如此麻烦，换一台机器，就要重来一次，旷日费时。很多人想到，能不能从根本上解决问题，软件可以带环境安装？也就是说，安装的时候，把原始环境一模一样地复制过来。

**解决方案：**  
1. 虚拟机（virtual machine）就是带环境安装的一种解决方案。它可以在一种操作系统里面运行另一种操作系统，比如在 Windows 系统里面运行 Linux 系统。应用程序对此毫无感知，因为虚拟机看上去跟真实系统一模一样，而对于底层系统来说，虚拟机就是一个普通文件，不需要了就删掉，对其他部分毫无影响。

    虽然用户可以通过虚拟机还原软件的原始环境。但是，这个方案有几个缺点。
    - **资源占用多**:  
        虚拟机会独占一部分内存和硬盘空间。它运行的时候，其他程序就不能使用这些资源了。哪怕虚拟机里面的应用程序，真正使用的内存只有 1MB，虚拟机依然需要几百 MB 的内存才能运行。
    - **冗余步骤多**：  
        虚拟机是完整的操作系统，一些系统级别的操作步骤，往往无法跳过，比如用户登录。
    - **启动慢**：  
        启动操作系统需要多久，启动虚拟机就需要多久。可能要等几分钟，应用程序才能真正运行。
2. Linux 容器不是模拟一个完整的操作系统，而是对进程进行隔离。或者说，在正常进程的外面套了一个保护层。对于容器里面的进程来说，它接触到的各种资源都是虚拟的，从而实现与底层系统的隔离。  

    由于容器是进程级别的，相比虚拟机有很多优势。
    - **启动快**:  
        容器里面的应用，直接就是底层系统的一个进程，而不是虚拟机内部的进程。所以，启动容器相当于启动本机的一个进程，而不是启动一个操作系统，速度就快很多。
    - **资源占用少**：  
        容器只占用需要的资源，不占用那些没有用到的资源；虚拟机由于是完整的操作系统，不可避免要占用所有资源。另外，多个容器可以共享资源，虚拟机都是独享资源。
    - **体积小**：  
        容器只要包含用到的组件即可，而虚拟机是整个操作系统的打包，所以容器文件比虚拟机文件要小很多。

**总之**，容器有点像轻量级的虚拟机，能够提供虚拟化的环境，但是成本开销小得多。

<!-- more -->

### 什么是docker
`Docker` 属于 Linux 容器的一种封装，提供简单易用的容器使用接口。它是目前最流行的 Linux 容器解决方案。

`Docker` 将应用程序与该程序的依赖，打包在一个文件里面。运行这个文件，就会生成一个虚拟容器。程序在这个虚拟容器里运行，就好像在真实的物理机上运行一样。有了 `Docker`，就不用担心环境问题。

总体来说，`Docker` 的接口相当简单，用户可以方便地创建和使用容器，把自己的应用放入容器。容器还可以进行版本管理、复制、分享、修改，就像管理普通的代码一样。

### 安装
`Docker` 是一个开源的商业产品，有两个版本：社区版（Community Edition，缩写为 CE）和企业版（Enterprise Edition，缩写为 EE）。企业版包含了一些收费服务，个人开发者一般用不到。我们使用社区版。

`Docker` 可以在`Mac`、`Linux`、`windows`下安装，其中的 windows 只能是 win10，我又没有 mac, 所以我使用谷歌云来进行安装，它是 `CentOs7`。

鉴于国内网络问题，强烈建议使用国内源
``` bash
# \ 表示换行
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.ustc.edu.cn/docker-ce/linux/centos/docker-ce.repo
```
如果无法识别 `yum-config-manager` 命令，使用下面命令安装并重新登录:
``` bash
$ sudo yum install -y yum-utils
```
更新 `yum` 软件源缓存，并安装 `docker-ce`。
``` bash
$ sudo yum makecache fast
$ sudo yum install docker-ce
``` 
安装完成后，运行下面的命令，验证是否安装成功。
``` bash
$ docker version 
```
`Docker` 需要用户具有 sudo 权限，为了避免每次命令都输入sudo，可以把用户加入 `Docker` 用户组。
``` bash
$ sudo usermod -aG docker $USER
```
`Docker` 是服务器----客户端架构。命令行运行 `docker` 命令的时候，需要本机有 `Docker` 服务。如果这项服务没有启动，可以用下面的命令启动。
``` bash
$ sudo systemctl start docker
```
最后，验证 `docker` 是否可以正常运行：
``` bash
$ docker run hello-world
```

### image文件
**Docker 把应用程序及其依赖，打包在 image 文件里面，这就是 docker 里常说的镜像。** 只有通过这个文件，才能生成 `Docker` 容器。 `image` 文件可以看作是容器的模板。 `Docker` 根据 `image` 文件生成容器的实例。同一个 `image` 文件，可以生成多个同时运行的容器实例。

`image` 是二进制文件。实际开发中，一个 `image` 文件往往通过继承另一个 `image` 文件，加上一些个性化设置而生成。举例来说，你可以在 Ubuntu 的 `image` 基础上，往里面加入 Apache 服务器，形成你的 `image`。

`iamge` 常用命令：
``` bash
# 获取image
$ docker pull [imageName]
# 显示本机所有的image
$ docker images
# 删除 image 文件
$ docker rmi [imageName]
```
`image` 文件是通用的，一台机器的 `image` 文件拷贝到另一台机器，照样可以使用。一般来说，为了节省时间，我们应该尽量使用别人制作好的 `image` 文件，而不是自己制作。即使要定制，也应该基于别人的 `image` 文件进行加工，而不是从零开始制作。

为了方便共享， `image` 文件制作完成后，可以上传到网上的仓库。 `Docker` 的官方仓库 *Docker Hub* 是最重要、最常用的 `image` 仓库。此外，出售自己制作的 `image` 文件也是可以的。

我们来使用下上面这些命令：
``` bash
$ docker pull hello-world
$ docker images
$ docker rmi hello-world
```

### container文件
**image 运行时的实例，本身也是一个文件，称为容器文件。** 

container 常用命令:
``` bash
# 根据image生成container并启动
$ docker run [OPTIONS] imageName [command]
# 启动已经停止的container
$ docker start [containerId, ...]
# 查看正在运行的container，加 -a 显示所有的container
$ docker ps
# 停止container
$ docker stop [containerId]
# 删除container
$ docker rm [containerId]
```
`docker run` 常用的 options:
- **-d:** 后台运行容器，并返回容器ID；
- **-i:** 以交互模式运行容器，通常与 -t 同时使用；
- **-t:** 为容器重新分配一个伪输入终端，通常与 -i 同时使用；-it一起使用表示，容器的 Shell 映射到当前的 Shell，然后你在本机窗口输入的命令，就会传入容器
- **-p:** 端口映射，将 `docker` 内部端口映射到本机端口,如 -p 8080:3000，8080表示本机端口

我们来使用下上面这些命令：
``` bash
$ docker run hello-world # 本地找不到会自动在仓库下载
$ docker ps
$ docker stop [containerId]
$ docker ps # 只能看到正在运行的container
$ docker ps -a
$ docker rm [containerId]
$ docker ps -a
```
### Dockerfile文件
`Docker` 根据该文件生成二进制的 `image` 文件。

常用相关命令：
``` bash
# 创建image
$ docker build [optiosn] PATH
```

下面用实例来演示：

 创建一个 `Dockerfile` 文件
``` bash
$ mkdir docker-demo && cd docker-demo
$ touch Dockfile
$ vim Dockerfile
```
填入如下内容：
```
FROM alpine:latest
MAINTAINER tang
CMD echo 'hello docker'
```
保存退出。继续下面的命令:
``` bash
$ docker build -t hello-docker . 
$ docker images # 可以看到生成的hello-docker
$ docker run hello-docker # 输出：hello docker
```
上面 `docker build` 语句中：-t 指定 `image` 的名称，后面跟冒号可以指定标签，若没有指定，则默认为 `latest`

`Dockerfile` 文件常用命令：

- **FROM:** 基础镜像
- **MAINTAINER:** 维护者
- **WORKDIR:** 指定工作目录
- **ADD:** 添加文件,可以添加远程文件
- **COPY:** 拷贝文件，但不允许远程文件
- **RUN:** 执行命令，允许出现多条
- **CMD:** 执行命令，只允许一条生效，若有多条，最后一条生效，若 `docker run` 命令后面有命令，会覆盖CMD命令
- **EXPOSE:** 暴露端口
- **ENV:** 设定环境变量
- **ENTRYPOINT:** 容器入口
- **USER:** 指定用户
- **VOLUME:** 挂载卷。如：`VOLUME /data` ， /data 目录就会在运行时自动挂载为匿名卷,任何向 /data 中写入的信息都不会记录进容器存储层，从而保证了容器存储层的无状态化。运行时可以覆盖这个挂载设置,如： `docker run -d -v mydata:/data imageName`, 使用了 mydata 这个命名卷挂载到了 /data 这个位置，替代了 `Dockerfile` 中定义的匿名卷的挂载配置

下面我们来个稍微复杂点的实例，还是在上面那个目录，先做些准备工作：  

初始化一个 `node` 项目:
``` bash
$ npm init
$ npm install koa -S
```
创建 `.dockerignore` 文件，并写入：

``` 
node_modules
node-debug.log
```
创建 `server.js` 并填写：
``` js
const Koa = require('koa')
const app = new Koa()

app.use( async ( ctx ) => {
  ctx.body = 'hello koa2'
})

app.listen(3006)
console.log('[demo] start-quick is starting at port 3006')
```
准备工作完成，修改 `Dockerfile` , 参考 [node官方demo](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/), 最终如下：
``` bash
FROM node:carbon
MAINTAINER tang
# Dockerfile 中每一个指令都会建立一层，使用 WORKDIR 后各层的当前目录就被改为指定的目录
WORKDIR /usr/src/app
COPY package*.json ./

RUN \
npm install -g nrm && \
nrm use taobao && \
npm install

COPY . .
EXPOSE 3006
CMD ["npm", "start"]
```
继续下面命令：
``` bash
# 创建image
$ docker build -t hello-koa2 .
# 查看创建的image
$ docker images
# run the image
$ docker run -p 9000:3006 -d hello-koa2 # 返回containerId
# 查看生成的container
$ docker ps
# Print app output
$ docker logs containerId
```
最后访问 [localhost:9000](localhost:9000)，可以看到结果： hello koa2

### 发布 image 文件
容器运行成功后，就确认了 `image` 文件的有效性。这时，我们就可以考虑把 `image` 文件分享到网上，让其他人使用。假设我们要发布上面用到的 `hello-koa2 image` ，进行如下步骤：

首先，去 [hub.docker.com](https://hub.docker.com) 或 [cloud.docker.com](https://cloud.docker.com) 注册一个账户。然后，使用下面的命令：
``` bash
$ docker login # 输入注册的用户名和密码
# 为本地的 image 标注用户名和版本。
$ docker tag hello-koa2 [username]/[respository]:[tag]
# 我的是： docker tag hello-koa2 jintang/hello-koa2
$ docker push jintang/hello-koa2
```
现在就可以在 [hub.docker.com](https://hub.docker.com) 上登录自己的账号看到刚发布的 `image` 了

### Docker Compose
`Compose` 是 `Docker` 公司推出的一个工具软件，可以管理多个 `Docker` 容器组成一个应用。你需要定义一个 *YAML* 格式的配置文件 `docker-compose.yml` ，写好多个容器之间的调用关系。然后，只要一个命令，就能同时启动/关闭这些容器。

#### 安装
``` bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```
检测是否安装成功：
``` bash
$ docker-compose --version
# docker-compose version 1.21.0, build 5920eb0
```
#### 编写 docker-compose.yml
现在我们要搭建一个 `wordpress` 站点，它需要 `wordpress` 容器和 `mysql` 容器。 

**先看看不使用 compose 的实现方法:** 

首先，基于官方的 `mysql image`， 新建并启动 `MySQL` 容器。
``` bash
$ docker run \
  -d \
  --rm \
  --name wordpressdb \
  --env MYSQL_ROOT_PASSWORD=123456 \
  --env MYSQL_DATABASE=wordpress \
  mysql:5.7
```
然后，基于官方的 `WordPress image` ，新建并启动 `WordPress` 容器。
``` bash
$ docker run \
  -d \
  -p 9001:80 \
  --rm \
  --name wordpress \
  --env WORDPRESS_DB_PASSWORD=123456 \
  --link wordpressdb:mysql \
  --volume "$PWD/wordpress":/var/www/html \
  wordpress
```
解析：  
- **--rm：** 停止运行后，自动删除容器文件。
- **--name wordpress：** 容器的名字叫做wordpress。
- **--env MYSQL_ROOT_PASSWORD=123456：** 向容器进程传入一个环境变量 MYSQL_ROOT_PASSWORD ，该变量会被用作 MySQL 的根密码。
- **--env MYSQL_DATABASE=wordpress：** 向容器进程传入一个环境变量 MYSQL_DATABASE ，容器里面的 `MySQL` 会根据该变量创建一个同名数据库。
- **--link wordpressdb:mysql** ，表示 `WordPress` 容器要连到 `wordpressdb` 容器，冒号表示该容器的别名是 mysql
- **--volume "$PWD/":/var/www/html：** 将当前目录（$PWD）映射到容器的 `/var/www/html` （Apache 对外访问的默认目录）。因此，当前目录的任何修改，都会反映到容器里面，进而被外部访问到。

现在访问 [localhost:9001](localhost:9001) 即可以看到安装页面，停止两个 container 后因为 `--rm` 就自动删除了。

**下面是使用 compose 的实现方法:** 

`docker-compose.yml` 写入如下内容：
``` yml
mysql:
    image: mysql:5.7
    environment:
     - MYSQL_ROOT_PASSWORD=123456
     - MYSQL_DATABASE=wordpress
web:
    image: wordpress
    links:
     - mysql
    environment:
     - WORDPRESS_DB_PASSWORD=123456
    ports:
     - "9001:80"
    working_dir: /var/www/html
    volumes:
     - wordpress:/var/www/html
```
#### 启动
``` bash
$ docker-compose up
```
访问 [localhost:9001](localhost:9001) 就可以看到 `wordpress` 的安装界面了

现在关闭两个容器。
``` bash
$ docker-compose stop
```
关闭以后，这两个容器文件还是存在的，写在里面的数据不会丢失。下次启动的时候，还可以复用。下面的命令可以把这两个容器文件删除（容器必须已经停止运行）。
``` bash
$ docker-compose rm
```
比起上面单独创建 container 的方式方便多了。

**ok, 本文结束。**