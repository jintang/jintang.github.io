title: nginx反向代理豆瓣接口
date: 2018-03-05 16:57:36
tags:
- nginx
categories: 杂说
---
>`nginx`是一个`web`服务器，类似`apache`。又不仅仅是个服务器，还可以`反向代理`、`负载均衡`...很多牛逼的网站都是用了`nginx`二次开发，比如说大名鼎鼎的 **草榴**。我们普通人可以通过`反向代理`来转发接口，实现 **跨域**。

不论你是`windows`还是`linux`，都可以用下面三个步骤来概括：
1. 下载安装，`windows`下不需安装，解压即可
2. 修改配置：`conf/nginx.conf`
3. 重启：第一次启动：`start nginx`；修改配置后重启：`nginx -s realod`
然后访问就可以看到结果。

那么，下面放上其中的重点——**修改配置**：
``` yml
server {
    listen       80;
    server_name  localhost;

    location / {
        root   html;
        index  index.html index.htm;
    }

    location ~ /v2/ {
        # 反向代理https://api.douban.com
        proxy_pass https://api.douban.com;
    }
}
```
所谓**反向代理**，就是当你访问你的`nginx`服务器时，会转发到你设置的服务器上。比如上面当你访问`localhost`时，就转发到 https://api.douban.com 上。即你访问`localhost`相当于访问 https://api.douban.com 。

重启后就可以访问下豆瓣的接口了，比如：https://api.douban.com/v2/book/1220562 可以用 [localhost/v2/book/1220562](/v2/book/1220562) 访问。
<!-- more -->
**Tip:** `nginx`默认不支持`https`，如果要访问 https://localhost 来转发接口。需要 `https`证书，这种证书可以用两种方法获得：
- 用[openSSL]( http://slproweb.com/products/Win32OpenSSL.html)自己生成一个，这样转发的接口访问时谷歌浏览器会提示**您的连接不是私密连接**，你需要点击：高级——继续前往...就可以了，其他的浏览器类似。具体的做法可以参考[这里](http://www.xymiao.com/archives/769)
- 买一个认证的证书，可以去阿里云等地方买一个，然后配置和上面差不多。
