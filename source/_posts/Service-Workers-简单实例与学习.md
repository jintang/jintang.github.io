title: Service Workers 简单实例与学习
date: 2019-07-12 16:41:15
tags: 
- Service Workers
categories: 前端
---

> `Service Workers` 可以让你的网页在离线模式下访问。 附几个链接：
> - [Service Workers 使用文档](https://developer.mozilla.org/zh-CN/docs/Web/API/Service_Worker_API/Using_Service_Workers)
> - [Workbox](https://developers.google.com/web/tools/workbox/guides/get-started)：快速构建 `Service Workers` 的工具
> - [A 5 minute intro to Workbox 3.0](https://medium.com/google-developer-experts/a-5-minute-intro-to-workbox-3-0-156803952b3e)

### 前情提要

- 目前有的浏览器还不支持，比如 `IE` ... 使用前请用 [caniuse](https://caniuse.com/#search=service%20worker) 查询支持情况
- `https` 的页面才支持。为了调试，本地 `localhost` 也可以

通过观察拥有 `Service Workers` 的网站，比如说 [996.ICU](https://996.icu) ,通过打开 **Chrome dev tools => Application => Service Workers** 选项，可以看到这个网站注册了一个 `Service Workers`， 它使用的源文件是 [service-worker.js](https://996.icu/service-worker.js) ，点击打开可以看到里面的代码，这个很简单，而且使用 `workbox` 生成的。

其实我们的浏览器会记录所有访问过的网站里面有 `Service Workers` 的。在上面的调试窗口下，可以看到 **996.icu** 下面还有一个 **Service workers from other domains** 的选项，打开就可以看到其他使用 `Service Workers` 的网站了。我看了我访问过的那些网站， 除了 [lodash 的 sw.js](https://lodash.com/sw.js) 不知道用什么生成的外，其他的都用的是 `workbox` 生成的。


下面简单说一下步骤，简单明了，保证你一看就会。就以 [frontend-nanodegree-mobile-portfolio](https://github.com/jintangWang/frontend-nanodegree-mobile-portfolio)（这是上一篇博文[网页关键渲染路径](https://jintang.github.io/2019/07/02/%E7%BD%91%E9%A1%B5%E5%85%B3%E9%94%AE%E6%B8%B2%E6%9F%93%E8%B7%AF%E5%BE%84/)中的实例仓库） 为例

<!-- more -->
### 安装
```
npm install workbox-cli --save-dev
```
### 生成配置文件
```
npx workbox wizard
```
这个命令会产生交互式的操作，询问你要缓存的文件：
![workbox-wizard](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/workbox-wizard.png)
在填写完之后会在根目录生成一个 `workbox-config.js`， 里面就是你选择的内容
### 生成 sw.js
从上图可以看到，命令行提示你输入
```
workbox generateSW workbox-config.js
```
然后再 `dist/` 目录下就会多出一个 `sw.js` ，这就是我们需要的。

### 注册 service worker
在 `index.html` 下添加如下代码， 因为我 `dist/` 目录下的文件都是由 `src/` 下的文件生成的，所以我修改的是 `src/` 下的 `index.html` 并重新打包
``` html
<script>
if ('serviceWorker' in navigator) {
   window.addEventListener('load', () => {
      navigator.serviceWorker.register('/sw.js');
   });
 }
</script>
```

### 部署并访问
本地启动服务测试一下，因为我这只是简单的静态页面，所以我用 [Browsersync](http://www.browsersync.cn/) 工具启动服务。

`dist/` 目录下运行以下命令
```
browser-sync start --server --files "**/*.css, **/*.html, *.html"
```
关闭网络后刷新页面，页面还是可以访问，说明缓存成功。

将这些代码重新部署到服务器上进行访问，这儿我用的是 `github pages` ，正好有 `https`。 

在 **Chrome dev tools => Network** 下可以看到很多带有 ⚙️ 图标的请求，这些都是 `Service Workers` 的请求，同时可以在**Chrome dev tools => Application => Service Workers** 下看到当前网站注册的 `Service Workers`。

![service worker result](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/service-worker-result.png)

最后附上该实例的 [地址](https://jintangwang.github.io/frontend-nanodegree-mobile-portfolio/dist/)

### 添加自己的 `sw.js` 的代码
上面我们的 `sw.js` 是由命令行生成的。如果我们想添加点自己的代码，直接修改 `sw.js` 是不行的，因为每次重新运行命令行都会重新生成。做法如下：

1. 创建 `src-sw.js`,如：
  ``` js
  importScripts("https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js");

  // 自己的代码开始...
  console.log('this is my custom service worker'); 
  // 自己的代码结束...

  workbox.precaching.precacheAndRoute([]);
  ```
2. 在 `workbox-config.js` 底部添加一行;
  ``` js
  "swSrc": "src-sw.js"
  ```
3. 运行命令将预缓存的资源数组注入：
  ``` js
  // 会注入到我们写的 workbox.precaching.precacheAndRoute([]);
  // 不能使用 workbox generateSW workbox-config.js 语句生成 sw.js 了。
  npx workbox injectManifest
  ``` 

重新查看 `sw.js` 即可看到里面既有自己的代码，也有生成的关于缓存的代码。

### 其他
如果要缓存 `api` 请求，要使用 `workbox.routing.registerRoute()` 。此处不再详述。