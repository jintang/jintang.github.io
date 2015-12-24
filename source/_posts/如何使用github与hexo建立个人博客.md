title:  如何使用github与hexo建立个人博客
date: 2015-12-09 14:38:10
tags: 博客
categories: git 
---
>   刚刚用github与hexo搭建了个人博客，对于这么个专属于自己的东西还是蛮开心的，不过过程中也遇到了很多不懂的东西，所以还是想把这个过程写下来，希望对新人有些帮助！

## 前言
[github](https://github.com/)是全世界最大的"开源"社区，有很多神奇的功能，有许许多多的大牛，所有著名的大公司都收益于github，我们的博客就是依托于github，github可以给你一个二级免费域名，这就是我们的博客，名字是我们自己起的，比如我的: [堂的博客](http://jintang.github.io/)，前面的jintang是我的名字，是不是很炫酷！那么[hexo](https://hexo.io/zh-cn/)是什么呢？hexo我简单理解为一个工具，就是用来发布博客的，你在本地电脑上写了文章，然后就可以通过hexo命令来发布你的文章。
了解了这是什么东西，我们就开始建立博客吧！！
    
## 安装环境与工具
1.  [git](http://git-scm.com/)：版本控制工具，可以向github推送你的代码，github是免费托管的
2.  [node.js](https://nodejs.org/en/download/)：一个js环境，很强大的，内置了许多对象与方法，我们在这儿只需要使用npm命令装一些东西，装了node.js就可以使用npm命令了。
下载安装你对应系统的即可，最新的node.js在安装的过程中会自动配置你的环境变量，所以这个就不用我们操心了。

## 注册github账号并发布博客页面
 **1.访问github网址：**https://github.com/
 
起个好听的username吧，虽然只能是英文数字连字符，唉，可惜了我的文艺细胞，可以起中文的话可以给博客起一个很好听的域名。对，你没理解错，起的名字就会成为你的博客域名，我的名字是jintang，然后域名就是http://jintang.github.io/,其实说了些废话，现在github是可以改username的，单字的恐怕已经都被注册光了，唉...

注册了之后要另外绑定一个邮箱，不是创建账号绑定的那个，而是要在个人账号设置里另外在绑定一个，这个邮箱专门用来接受github的各种通知,比如建立博客时就会发送通知。如果你收不到激活的邮件，可以尝试下gamil等国外邮箱。

 **2.新建Repository(仓库)：**之前说我们的博客是依托于github的，准确的说，有两种博客页面：

- 依托于Repository（仓库）
- 依托于Organization（组织）

位置如下（暂不放图）：

推荐使用第一种方式，新建一个Repository，新建的过程如下图：（图片先不放了）

**tip：**仓库的名字必须是：**username.github.io**，里面的username和你github账号的username一致，大小写不要紧。

点击确定即可，仓库已创建成功。

 **3.发布你的博客：**

点击setting——点击Launch automatic page generator——点击Continue to layouts——选一个默认的模板点击Publish page即可。如图所示：

**tip:这只是将博客页面发布了出去，使用的github默认工具渲染的页面，选什么模板并不重要，之后都会用hexo修改掉**

现在已经可以访问你自己的博客页面了，网址是：http://username.github.io  ，跟你的仓库名是一样的哦。第一次发布需要等几分钟才可以访问。如果404不要着急哦！如果一直访问不了，去github上绑定的邮箱上看看，不论你的github pages建立成功还是失败，github都会发邮件通知你的！我刚开始失败了，原因是没有给github账号绑定一个邮箱。



