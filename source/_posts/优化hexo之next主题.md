title: 优化hexo之next主题
date: 2016-12-01 13:13:07
tags: 
- hexo
- 博客
categories: 杂说
---
>[next](http://theme-next.iissnan.com/)主题是一款黑白色的主题，简单大方，时间久了难免有点厌烦。于是自己遍想做点优化和美化,让它色彩缤纷些。下面的方法也适用于其他主题

### 样式方面
[官方默认样式](http://notes.iissnan.com/)对比[我的主题样式](http://jintang.github.io/)  
- `next/source/css/_custom/custom.styl`:这里面写自定义样式，浏览器中`f12`调试，看哪儿不好看，直接写在此文件中覆盖。我的自定义样式：
``` css
// Custom styles.
::selection {
  background: #3399FF;
}

a {
    border-bottom: none;
}
article a, .about-page a{ // about页面下也用此样式
	color: $my-link-color;
	&:hover {
	    color: $my-link-hover-color;
	}
}
.posts-expand .post-body ul li{
	list-style: disc;
}
//最近访客
#ds-recent-visitors .ds-avatar{
	float:left;
}
//最新评论
.ds-recent-comments{
	padding-left:0;
}
//打赏样式
#wechat p{
	margin-top:-16px;
}
#alipay{
	vertical-align:top;
}
.lrc{
	width:100%;
	text-align:center;
}
.tip{
	color: #DF0101;
	font-weight:bold;
}
// 行内代码
$code-block {
  overflow: auto;
  margin: 20px 0;
  padding: 15px;
  font-size : $code-font-size;
  color: $highlight-foreground;
  background: $my-highlight-background;
  border:1px solid $my-highlight-border;
  line-height: $line-height-code-block;
}
code {
  padding: 2px 4px;
  word-break: break-all;
  color: $my-code-foreground;
  background: $my-code-background;
  border-radius: $code-border-radius;
  font-size : $code-font-size;
}

p {
    margin: 0 0 15px;
}
```
<!-- more -->
- `next/source/css/_variables/custom.styl`:这里面可以自定义一些[Stylus](http://www.zhangxinxu.com/jq/stylus/)的变量，一般用作全局的东西，可以覆盖主题默认的变量。我的自定义变量：
``` css
//字体:
// 标题，修改成你期望的字体族
$font-family-headings = Georgia, sans
// 正文, 修改成你期望的字体族
$font-family-base = "Helvetica Neue","Helvetica","Microsoft YaHei","WenQuanYi Micro 	Hei",Arial,sans-serif

//行内代码字体颜色
$my-code-foreground = #c7254e
//行内代码背景颜色
$my-code-background = #f8f5ec
//代码块背景颜色
$my-highlight-background = #eee;
//代码块border颜色
$my-highlight-border = #ddd;

//a标签的颜色
$my-link-color = #0d8abf;
$my-link-hover-color = #29B4F0;

//bootstrap的颜色
$brand-primary = #428bca;
$brand-success = #5cb85c;
$brand-info =    #5bc0de;
$brand-warning = #f0ad4e;
$brand-danger =  #d9534f;
```

### 主页添加热评文章、最新访客、最新评论
>这几种功能都是利用了[多说](http://dev.duoshuo.com/docs)，所以想要这几个功能你的博客必须得添加`多说`,如何添加请点[这儿](http://theme-next.iissnan.com/third-party-services.html)。

**原理**：在需要的页面上加上`多说`的`通用代码`，`多说`的`embed.js`会解析生成对应的模块，next主题使用的是[swig](http://yangxiaofu.com/swig/)模板来生成对应的`html`，所以我们在模板中添加`通用代码`。实例讲解：
#### 热评文章
通用代码：
``` html
<ul  class="ds-top-threads" 
    data-range="monthly" 
    data-num-items="5">
</ul>
```
属性说明:
``` 
//以下参数均为可选参数
 data-range="weekly"      //热评统计时间范围：daily：日；weekly：周；monthly：月；默认值daily
 data-num-items="5"     //显示最新文章的条数，默认值5
```

我要显示在**侧边栏**，所以我将通用代码添加到`sidebar.swig`,此文件在`next/layout/_macro`目录下。我要放在许可协议![许可协议](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/blog_license.png)的下面：

首先，在文件中找到证书对应的代码：  
``` html
    <div class="cc-license motion-element" itemprop="license"></div>
```
然后，在下面加入通用代码和样式：
``` html
    <div class="links-of-blogroll motion-element">
      <div class="links-of-blogroll-title"> <i class="fa fa-globe fa-fw"></i>热评文章</div>
      <ul  class="ds-top-threads" data-range="monthly" data-num-items="5"></ul>
    </div>
```
重新部署，就ok了  
>如果没有生效，用`hexo clean`后再部署试试

#### 最新访客
通用代码：
``` html
<div class="ds-recent-visitors"
  data-avatar-size="42"
  id="ds-recent-visitors" 
  data-num-items="24" >
</div>
```
属性说明:
``` 
data-num-items="10"     //显示访客的数量
data-avatar-size="42"   //访客头像大小   
```
在**热评文章**下添加**最新访客**通用代码和样式：
``` 
{# Blogroll:只在主页显示 #}
{% if !display_toc %}
//{%%}、{##}是swig模板的语法
<div class="links-of-blogroll motion-element clearfix">
  <div class="links-of-blogroll-title"> <i class="fa fa-globe fa-fw"></i>最近访客</div>
  <div class="ds-recent-visitors"
      data-num-items="36"
      data-avatar-size="42"
      id="ds-recent-visitors" 
      data-num-items="24" >
  </div>
</div>
{% endif %}
```
重新部署，ok了。  

#### 最新评论
通用代码：
``` html
<ul class="ds-recent-comments" 
    data-num-items="5" 
    data-show-avatars="1" 
    data-show-time="1" 
    data-show-admin="0" 
    data-excerpt-length="70">
</ul>
```
属性说明:
``` 
//以下参数均为可选
data-num-items="10"     //显示最新评论的条数，最大支持200条
data-show-avatars="1"   //是否显示头像，1：显示，0：不显示
data-show-time="1"      //是否显示时间，1：显示，0：不显示
data-show-title="0"     //是否显示标题，1：显示，0：不显示
data-show-admin="1"     //是否显示管理员的评论，1：显示，0：不显示
data-excerpt-length="70"//最大显示评论汉字数
```
在**最新访客**下添加**最新评论**通用代码和样式：
``` html
<div class="links-of-blogroll motion-element">
  <div class="links-of-blogroll-title"> <i class="fa fa-globe fa-fw"></i>最新评论</div>
  <ul class="ds-recent-comments" data-num-items="5" data-show-avatars="1" data-show-time="1" data-show-admin="0" data-excerpt-length="70"></ul>
</div>
```
重新部署，生效了。
