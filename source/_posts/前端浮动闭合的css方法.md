title: 浮动闭合的css方法
date: 2016-04-17 11:52:53
tags:
categories: 前端
---
本文参考自：[大前端](http://www.daqianduan.com/3606.html)
``` html
<style type="text/css">
    ul{background: #ff0;}
    li{float: left;}
</style>
    <ul>
        <li>小明</li>
        <li>小红</li>
        <li>小白</li>
    </ul>
```
### 1.传统的万能清除方法:
给末尾的li元素后面增加一个元素：`<div class="clear"></div>`
其样式为：
``` css
.clear{clear:both;height:0;overflow:hidden;}
```
### 2.常用的清除方法:
在父类元素上面加类：`<ul class="clearfix"></ul>`，后面的两个方法也是在父元素上加clearfix类
利用伪类,其样式为：
``` css
.clearfix:before,.clearfix:after{
    content: '';
    display: block;/*table也可以*/
}
.clearfix:after{
    overflow: hidden;
    clear: both;
}
```
### 3.最优浮动闭合方案：

``` css
.clearfix{*+height:1%;}
.clearfix:after{
    content:".";
    display:block;
    height:0;
    clear:both;
    visibility:hidden
}
```
<!-- more -->
### 4.很拉轰的浮动闭合办法：
``` css
.clearfix{overflow:auto;_height:1%}
```

### 5.一位网友(radom)提供的:
``` css
.clearfix{overflow:hidden;_zoom:1;}
```

