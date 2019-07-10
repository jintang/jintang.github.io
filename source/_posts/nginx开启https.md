title: nginx开启https
date: 2018-04-27 14:22:42
tags: 
- https
- nginx
categories: 杂说
---
前段时间微信小程序很火，得闲时来写写小程序。本来想用豆瓣的 api ，但已经有人写了，好吧...那我就自己写个简单的 api 用用。程序已经写好了，但小程序要求后台必须是 `https`,好吧，那就给谷歌云搞个 `https`, 下面讲讲过程。万万没想到， 最后的结局是悲伤的，这个 api 最后还是用不成，因为小程序要求的接口域名必须是要经过备案的，而谷歌云无法备案，苦涩的哈哈哈... 。仅以此纪念学习这个的过程。

### 下载证书
首先在本地先试验下，用 `openssl` 生成了自签名证书，参考 [这儿](http://www.xymiao.com/archives/769), 再修改下 `nginx.conf` 的配置，就可以访问 [https://localhost](https://localhost) 了，但放在谷歌云上却无法正确运行，不知道为什么...  

那么，我们去买一个 `https` 证书来配置，==...发现有免费的，那自然用免费的，申请下载请参考 [这儿](http://www.zslin.com/web/article/detail/72)，文章中阿里云的免费证书已经不可以申请了，所以我申请了腾讯云的免费证书，不枉我玩了那么多腾讯游戏...手动笑哭

### 修改nginx配置
免费的证书有 1 年的使用时间，下载下来的证书长这样：![https腾讯云证书](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/ca-dir.png)
<!-- more -->
在 `/etc/nginx` 下创建个 `ssl` 文件夹，此路径下的文件如图：![nginx目录](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/nginx-dir.png)
将下载下来 `nginx` 下的证书上传到 `ssl` 文件夹下。然后修改 `nginx.conf` 文件，只需要添加一个 `server` 配置，其他的都不变：
``` yml
http {
    # http 的 server 配置，不变
    server {
        #
    }
    # https 的 server 配置 
    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # 添加的证书信息, 主要修改下证书的路径
        ssl_certificate "/etc/nginx/ssl/1_cloud-tv.top_bundle.crt";
        ssl_certificate_key "/etc/nginx/ssl/2_cloud-tv.top.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
            proxy_pass http://localhost:3000;
            proxy_set_header Host $host;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
```
最后重启 `nginx` 服务就可以访问了。我是这样重启的
``` bash
$ systemctl stop nginx
$ systemctl start nginx
```
感觉自己好傻逼...