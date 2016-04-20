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
给末尾的li元素后面加：`<div class="clear"></div>`
其样式为：
``` css
.clear{clear:both;height:0;overflow:hidden;}
```

### 2.最优浮动闭合方案：
在父类元素上面加类：`<ul class="clearfix"></ul>`，后面的两个方法也是在父元素上加clearfix类
其样式为：
``` css
.clearfix:after{content:".";display:block;height:0;clear:both;visibility:hidden}
.clearfix{*+height:1%;}
```

### 3.很拉轰的浮动闭合办法：
``` css
.clearfix{overflow:auto;_height:1%}
```

### 4.一位网友(radom)提供的:
``` css
.clearfix{overflow:hidden;_zoom:1;}
```

**tip**:后面三种css设置原理完全不明白，有评论的可以联系我qq：841107370