title: less使用mixin的小技巧
date: 2016-11-07 17:43:14
tags: 
- less
- css
categories: Css
---
>less是一种css的扩展，可以编译成css。将它定位为"工具"即可，最终 浏览器/app 识别的还是css  

参考网站：
>- [less中文官网](http://less.bootcss.com/)，是bootstrap帮忙翻译的，但容我吐槽一句：翻译翻一半，惆怅也疼蛋。  
- [css88的less中文文档](http://www.css88.com/doc/less/features/)，这个翻译完了，不喜欢英文的可以看这个


### css3中calc在less编译时被计算的解决办法
目标：
``` css
    width: -moz-calc(100% - 10px);
    width: -webkit-calc(100% - 10px);
    width: calc(100% - 10px);
```
错误`less`:
``` less
//less的mixin
.calcWidth(@width){
    width:-moz-calc(@width);
    width:-webkit-calc(@width);
    width:calc(@width);
}
//使用
div{
    .calcWidth(100% - 10px);
}
```
错误结果:
``` css
    width: -moz-calc(90%);
    width: -webkit-calc(90%);
    width: calc(90%);
```
原因：`less`把这个当成运算式去执行了  
**正确`less`**:
``` less
//less的mixin
.calcWidth(@width){
    width:-moz-calc(@width);
    width:-webkit-calc(@width);
    width:calc(@width);
}
//使用
div{
    .calcWidth(~"100% - 10px");
    //~是less内置的转义函数，就是以前的e函数，语法：~"value"
}
```
结果就是目标，验证通过
<!-- more -->

### less写一个可复用的帧动画类型的 函数
目标：
``` css
div {
  animation: blink 1.8s infinite;
  -webkit-animation: blink 1.8s infinite;
  -moz-animation: blink 1.8s infinite;
  -o-animation: blink 1.8s infinite;
}
//定义的动画还有-webkit-、-moz-、-o-、-ms-，此处为了省篇幅没有加
@keyframes blink {
  0% {
    opacity: 0;
  }
  10% {
    opacity: 0.1;
  }
  20% {
    opacity: 0.2;
  }
  30% {
    opacity: 0.3;
  }
  40% {
    opacity: 0.4;
  }
  50% {
    opacity: 0.5;
  }
  60% {
    opacity: 0.6;
  }
  70% {
    opacity: 0.7;
  }
  80% {
    opacity: 0.8;
  }
  90% {
    opacity: 0.9;
  }
  100% {
    opacity: 1;
  }
}
```
方法：
``` less
//mixin开始
.animation(...){
  animation: @arguments;
  -webkit-animation: @arguments;
  -moz-animation: @arguments;
  -o-animation: @arguments;
}
.opacityLoop(@count) when (@count<=1){
  //percentage是less的内置函数，作用：将浮点数转换为百分比字符串
  @keysname:percentage(@count);
  /*注意：less不能直接在属性名上调用内置函数*/
  @{keysname} {
    opacity: @count;
  }
  .opacityLoop((@count+0.1));
}
//mixin结束
div {
  .animation(blink 1.8s infinite);
}
@-webkit-keyframes blink {.opacityLoop(0);}
@-moz-keyframes blink {.opacityLoop(0);}
@-o-keyframes blink {.opacityLoop(0);}
@keyframes blink {.opacityLoop(0);}
```
经过验证,结果正确。  
其实，上述的代码是否看起来还有点累赘，`@keyframes`的定义没有用`mixin`，但是`less`没办法做到，而`sass`可以像下面这样写：
``` sass
//支持多属性的0%和100%
@mixin keyframes($name,$props,$starts,$ends){
  @-webkit-keyframes #{$name} {@include frames($props,$starts,$ends);}
  @-moz-keyframes #{$name} {@include frames($props,$starts,$ends);}
  @-o-keyframes #{$name} {@include frames($props,$starts,$ends);}
  @keyframes #{$name} {@include frames($props,$starts,$ends);}
}
@mixin frames($props,$starts,$ends){
  $length:length($props);
  0% {
    @for $i from 1 through $length{
      $prop:nth($props,$i);
      #{$prop}:nth($starts,$i);
    }
  }
  100%{
    @for $j from 1 through $length{
      $prop:nth($props,$j);
      #{$prop}:nth($ends,$j);
    }
  }
}
//外部直接调用
@include keyframes(blink,background-color border-width,#f00 1px,#0f0 5px);
```

### import导入的路径问题
我们通常会将公共的颜色和mixin提取出来，放在一个文件里。那么如何引入此文件呢？  
默认:当前路径
``` less
    @import (keyword) "filename";
```
现在，我有一个`demo1.less`需要引用`base.less`，他们的路径如图:
![引用base.less](http://7xphbb.com1.z0.glb.clouddn.com/less%E4%B9%8Bimport.png)  
使用相对路径：
``` less
    @import (keyword) "../../../furnace/less/base.less";    
```
使用绝对路径:
``` less
    @import (keyword) "WebRoot\furnace\less\base.less";
```
**ps**:还可以直接从你的 node_modules 文件夹中加载 LESS 文件。  

**结语：**不论是`less`还是`sass`，都只是个工具，不应该在这上面花费大量的精力来玩花它。附一张百度找的`less`的思维导图,如下：
![less思维导图](http://7xphbb.com1.z0.glb.clouddn.com/less%E6%80%9D%E7%BB%B4%E5%AF%BC%E5%9B%BE.png)
话说这思维导图不全，以后有时间自己做个。所谓的有时间，大概又是了了无期...