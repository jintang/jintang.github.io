title: CSS我们所应该知道的
date: 2015-12-24 17:34:54
tags: 
- css
- 前端
categories: Css
---
### 文字换行属性:`white-space`
该属性的常用的值(容器的宽度固定)：

- `normal`: 默认，超出容器范围时换行
- `nowrap`: 超出容器的范围也不换行

### 为什么要设置`margin:0;padding:0;`
``` css
body{
    margin:0;
    padding:0;
}
ul{
    list-style-type:none;/*去除li前默认的小圆点*/
    margin:0;
    padding:0;
    overflow:hidden;/*防止li出现再ul外*/
}
*{
    margin:0;
    padding:0;
}
```
IE浏览器的内核Trident、 Mozilla的Gecko、google的WebKit、Opera内核Presto。不同的浏览器默认的margin和padding等属性都不相同，为了保证各浏览器的一致性，所以用下述办法：  
1. 直接用`*{margin:0;padding:0;}`(不推荐)
2. 使用[normalize.css](https://github.com/necolas/normalize.css/blob/master/normalize.css)，优于`Reset CSS`。  

*淘宝的css初始化：*
``` css
body, h1, h2, h3, h4, h5, h6, hr, p, blockquote, dl, dt, dd, ul, ol, li, pre, form, fieldset, legend, button, input, textarea, th, td { margin:0; padding:0; }
body, button, input, select, textarea { font:12px/1.5tahoma, arial, \5b8b\4f53; }
h1, h2, h3, h4, h5, h6{ font-size:100%; }
address, cite, dfn, em, var { font-style:normal; }
code, kbd, pre, samp { font-family:couriernew, courier, monospace; }
small{ font-size:12px; }
ul, ol { list-style:none; }
a { text-decoration:none; }
a:hover { text-decoration:underline; }
sup { vertical-align:text-top; }
sub{ vertical-align:text-bottom; }
legend { color:#000; }
fieldset, img { border:0; }
button, input, select, textarea { font-size:100%; }
table { border-collapse:collapse; border-spacing:0; }
```
<!-- more -->

### `DOCTYPE`
``` html
<!DOCTYPE html>
```
`<!DOCTYPE>` 声明位于文档中的最前面，处于 `<html>` 标签之前。告知浏览器的解析器，用什么文档类型 规范来解析这个文档。

### 权重
翻译自：[这儿](http://archives.molly.com/2005/10/06/css2-and-css21-specificity-clarified/)  

| 例子 | 行内css | ID 选择器 | class 选择器| 节点 选择器|
| -- | -- | -- | -- | -- |
| #name p.warning | 0 | 1 | 1 | 1 |

每一项的默认值都是`0`，哪一项满足一次就`+1`，比较最终的值  
*特殊：*  

- `*`选择器：`0 0 0 0`
- 继承的权重，所有继承的权重都是`null`。若某项属性继承自多个父辈元素，那取最近的父辈元素的属性
- 伪元素的权重 **=** 节点选择器的权重，伪类的权重 **=** 属性选择器的权重 **=** class选择器的权重

>伪元素的权重还有争议，有种说法是伪元素的权重忽略不计

### 多类选择器:`class="sty1 sty2"`
    在html中声明的`<p class="sty1 sty2">你好</p>`的对应的css样式为:
``` css
.sty1{
    font-weight:bold;
}
.sty2{
    font-style:italic;
}
.sty1.sty2{/*中间没有空格*/
    background:#FF00FF;
}
```
结果如下:  
![多类选择器结果](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/css-float-1.png)

总结:  
**多类选择器**会匹配其所有***子元素***任意组合的样式，如：  
`class="sty1 sty2 sty3"`会匹配`.sty1{}`,`.sty2{}`,`sty3{}`,`.sty1.sty2{}`,`.sty1.sty3{}`,`.sty2.sty3{}`,`.sty1.sty2.sty3{}`;  

**当有属性重叠时,根据权重来适应**.

### 乱码问题:
我们知道,乱码问题都是因为编码问题引起的,但是具体哪儿导致的问题,整个过程其实不清楚,现总结如下:  

- 编辑器的编码:我用的`sublime3`,下了`ConvertToUTF8`这个插件,可以让**内容**使用`utf-8`编码,当然,默认就是`utf-8`;
- 网页的源代码编码:html文件在头部声明了如下代码:`<meta charset="utf-8">`,浏览器的核心其实是渲染器与js解析器,那么,渲染器会根据网页源文件里面设定的编码渲染网页;

**只要这两个地方统一了,一般浏览器上就不会再出现乱码.如果还有,看看是不是浏览器设定的编码格式不统一.**

### 浏览器的滚动条:
![百度首页更多产品bug](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/jike_baidu_product_bug.jpg)  在批改极客学院作业的过程中，有个小bug印象特别深刻，让我想了一个周都没有想明白，表现为：
当移动到右侧的更多产品时，会向下弹出来该下拉列表，而且会向左偏移一段距离。原因是为了沾满整个屏幕，给此div设置了`min-height=667`，而这个高度大于我的屏幕高度，所以导致右侧出来了一个滚动条，这个滚动条是占宽度的。所以会向左偏移。

解决方案：设置滚动条的宽高为0，如下：
``` css
::-webkit-scrollbar {
    width: 0;
    height: 0;
}
```

### calc()
这是css3中常用到的计算方法，但是当要使用`+ - * /`等运算符的时候，+、-运算符两边要使用**空格**隔开，否则不起作用，如下是正确的方法：
``` css
.box{
    width:calc(100% - 10px);/*运算的具体数值要带单位*/
}
```

### box-shadow
此属性对 **tr** 不起作用，因为 **tr** 为`display:table-row;`,`box-shadow`只对`display:block;`生效

### 常用的`CSS hack`技巧
``` css
.bb{
       background-color:#f1ee18;/*所有识别*/
      .background-color:#00deff\9; /*IE6、7、8识别，ie8的最终样式*/
      +background-color:#a200ff;/*IE6、7识别，ie7的最终样式*/
      _background-color:#1e0bd1;/*IE6识别，ie6的最终样式*/
}
```

### 超链接访问过后hover样式就不出现了   
因为被点击访问过的超链接样式不在具有 `hover` 和 `active` 了。解决方法是改变 `CSS` 属性的排列顺序 **L-V-H-A**:
``` css
a:link {} a:visited {} a:hover {} a:active {}
```

### background-position
**提示**：需要把 `background-attachment` 属性设置为 `fixed`，才能保证该属性在 **Firefox** 和 **Opera** 中正常工作。  
**理解**: 一个宽高固定的 **div** ，如果背景图片大于那个宽高，显示的背景图只是从左上角开始的一部分，而并不会缩放该图片  
`background-position:x y;`

|值          |    描述|  
| --------   | -----  | 
| top left<br>top center<br>top right<br>center left<br>center center<br>center right<br>bottom left<br>bottom center<br>bottom right     | 如果您仅规定了一个关键词，那么第二个值将是"center"。<br>默认值：0% 0%。 |  
| x% y%     |  第一个值是水平位置，第二个值是垂直位置。<br><strong style="color:#f00;">左上角是 0% 0%。右下角是 100% 100%。</strong><br>如果您仅规定了一个值，另一个值将是 50%。   | 
| xpx ypx        |    第一个值是水平位置，第二个值是垂直位置。<br>左上角是 0 0。单位是像素 (0px 0px) 或任何其他的 CSS 单位。<br>如果您仅规定了一个值，另一个值将是50%。<br>您可以混合使用 % 和 position 值。