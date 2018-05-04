title: 关于我
date: 2018-5-4 10:36:00
type: "about"
---
> 嗨，大家好，我是堂！看了很多大佬的博客，向大佬们学习，在此记录下自己学过的东西。有问题大家可以留言给我，也可以加我的 qq : 841107370，或者发送邮件到： LCX6916356@163.com ,盼与你交流。回忆与记录，总是对应着成长和感触...

### 时间线

#### 2018
- 谷歌云 ：免费申请的，可以免费用一年，2019年1月7日过期，下面部署到谷歌云上的服务在这个时间之前还可以体验... 选择了 `centos7` 系统，部署了 `ssr` 以供我翻墙, 买了个1年的域名并 `DNS` 解析到主机。
- `node` ：跟着 [nswbmw](https://github.com/nswbmw) 大佬的 [N-blog](https://github.com/nswbmw/N-blog) 过了一下，里面用的数据库是 `mongodb`,大佬写的真好，最后部署到我的谷歌云上了
- `koa` ：跟着 [koa2-note](https://chenshenhai.github.io/koa2-note/note/project/start.html) 项目 学习了下 `koa2`，用的数据库是 `mysql`, 同样部署到了谷歌云上
- `nginx` :学习了它的反向代理、负载均衡、`http` 服务器 功能，在谷歌云上反向代理了上面写的 `node` 项目和 `koa` 项目，`nginx` 的 `http` `server` 代理了 `node` 项目，`https` `server` 代理了 `koa` 项目。可以通过访问 [http://cloud-tv.top](http://cloud-tv.top) 与 [https://cloud-tv.top](https://cloud-tv.top) 来体验，`https` 证书是我下载的腾讯云免费一年试用的证书。不知道为什么，[http://cloud-tv.top](http://cloud-tv.top) 经常会失效
- 微信小程序——**乐趣十足**：最终还是调用了第三方的接口，本来想自己写接口的，数据都存好了，最后却发现小程序要求的 `api` 服务器要求 备案，我一个国外的服务器怎么备案。这个是乐一乐的小程序，欢迎大家访问，持续优化中...
- `docker` ： 为了分享给同事，跟着 阮一峰 大佬学习了下 `docker`，真实体验了其强大之处，要安装一个 `wordpress` + `mysql` 博客，只需要一个配置文件就可以，具体请看我的文章 [docker初识](http://jintang.github.io/2018/04/24/docker%E5%88%9D%E8%AF%86/)
- 微信公众号——**堂网tang** ：里面是我讲的小故事,因为我是个会讲故事的程序员。欢迎访问，二维码我放在下面，希望带给你轻松的片刻，逃离鸡汤和长篇的压力。
    ![wechat-qcode](/uploads/wechat-qcode.jpg)
- AIOps : 这是我一直工作的项目，是一个平台型产品，包括用户统一身份管理（IAM）、资产配置管理（CMDB）、业务资产综合监控、业务运维及安全综合审计、IT流程管理（ITIL）及数据智能分析六大核心产品模块。使用的是 `vue` 技术栈：`vue-router` 、 `vuex` 、 `异步组件` ...组件用的我们改造的 `element` 组件，我们团队： [sunflower](https://github.com/SunInfoFE)。业务方面我主要负责 CMDB 和 ITIL 中的事件部分，组件方面给 `table` 内嵌了 `scrollbar`，改造了 `switch` 、 `pagination` 、`steps`...
