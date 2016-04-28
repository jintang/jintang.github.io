title: html屏幕自适应
date: 2016-02-19 11:14:28
tags:
categories: 前端
---
参考：[阮一峰的博客](http://www.ruanyifeng.com/blog/2012/05/responsive_web_design.html)
#### "自适应网页设计"的核心是：利用media属性判断不同的屏幕分辨率，并根据不同的分辨率适配不同的css


首先，在网页代码的头部，加入一行viewport元标签:允许网页宽度自动调整。

- 主流浏览器：
``` html
<meta name="viewport" content="width=device-width, initial-scale=1" />
<!-- 网页宽度默认等于屏幕宽度（width=device-width），原始缩放比例（initial-scale=1）为1.0，即网页初始大小占屏幕面积的100% -->
```
- 老式浏览器（主要是IE6、7、8）：要用[css3-mediaqueries.js](https://code.google.com/archive/p/css3-mediaqueries-js)
``` html
<!--[if lt IE 9]>
　　<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
<![endif]-->
```
<!-- more -->

**1.适配不同css文件**

html中：
``` html
<link rel="stylesheet" type="text/css" media="screen and (max-device-width: 400px)" href="tinyScreen.css" />
<!-- 如果屏幕宽度 小于400像素（max-device-width: 400px），就加载tinyScreen.css文件 -->

<link rel="stylesheet" type="text/css" media="screen and (min-width: 400px) and (max-device-width: 600px)" href="smallScreen.css" />
<!-- 如果屏幕宽度在400像素到600像素之间，则加载smallScreen.css文件 -->
```
css中：
``` css
@import url("tinyScreen.css") screen and (max-device-width: 400px);
/*如果屏幕宽度 小于400像素（max-device-width: 400px），就加载tinyScreen.css文件*/
```

**2.同一个css文件中也可以适配不同的分辨率**
``` css
@media screen and (max-device-width: 400px) {
　   /*屏幕宽度 小于400像素（max-device-width: 400px）时采用的样式*/　　　
}    
```