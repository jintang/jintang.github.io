title: less实战全解
date: 2016-11-10 19:55:49
tags:
- less
- css
categories: css
---
附上我的**开发规范**与**公用mixin**:
>- [less开发规范](https://gist.github.com/jintangWang/7633204455a2b992f08252f82fac1d58#file-_less-md)
- [less公用mixin](https://gist.github.com/jintangWang/7633204455a2b992f08252f82fac1d58#file-base-less)

本文所有的实例都可以在[less公用mixin](https://gist.github.com/jintangWang/7633204455a2b992f08252f82fac1d58#file-base-less) 找到  
### 不同主题的颜色字体等变量定义规范：
假设有一蓝色主题，且起名为"Blue"。那么：   

- 其下的所有变量都以"Blue"为开头起名
- 变量名应包含主要特征和用途,若用途较多用"color"声明
- 对于一些动作变化效果，如hover的颜色效果，最后再跟上对应的动作名  

实例：
``` less
@Blue-color-blue:#1D89E4;//用途较多,是此主题的主色
@Blue-border-lightgray-a:#e4e4e4;//常用作border
@Blue-border-lightgray-b:#dddddd;
@Blue-bg-lightgray:#f9f9f9;//常作背景色
@Blue-font-blue-hover:#0f79d5;//常作字体颜色,当hover时字体为这个颜色
```
这样，就定义了一套主题的颜色。下面的语句决定我们使用的主题：
``` less
@theme-color:@Blue-color-blue;
@theme-border-a:@Blue-border-lightgray-a;
@theme-border-b:@Blue-border-lightgray-b;
@theme-bg:@Blue-bg-lightgray;
@theme-font-hover:@Blue-font-blue-hover;
```
这里定义的变量才是实际在项目中用的，这些名称只包含了主要作用，而不包含特征。要切换不同的主题，只需要该这些变量对应的值就可以了。

### 跟主题无关的颜色字体等变量定义规范：
和跟主题相关的颜色名称定义类似，只不过开头不用加主题名，使用的时候可以明显区分主题相关的颜色和不相关的颜色。  

- 用途较多的颜色：不用声明作用，只需用单词表明特征即可
- 一些有常规用途的颜色：声明主要作用和特征  

这个比较灵活，具体视情况而定。  
实例：
``` less
@white:#fff;
@font-red:#f00;
```

### 兼容不同浏览器的样式mixin
以`.`开头，其名称与样式的名称一致：  
实例1：
``` less
.border-radius(...){
  -webkit-border-radius: @arguments;
  -moz-border-radius: @arguments;
  border-radius: @arguments;
}
```
<!-- more -->
实例2：`linear-gradient`的兼容处理  
这儿就能感觉到`less`的缺陷，判断关键词只有个`when`，为后面sass的用法埋个伏笔
``` less
//gradient开始
//相反方向
@top_opposite:bottom;
@bottom_opposite:top;
@left_opposite:right;
@right_opposite:left;
.opposite(@origin) when (length(@origin)=1) and (isstring(@origin)){
  @opposite:~"@{@{origin}_opposite}";
  @to_opposite:~"to @{opposite}";
}
.opposite(@origin) when (length(@origin)=1) and (isnumber(@origin)) and(@origin<180){
  @opposite:@origin+180;
  @to_opposite:@origin;
}
.opposite(@origin) when (length(@origin)=1) and (isnumber(@origin)) and(@origin>=180){
  @opposite:@origin+(-180);
  @to_opposite:@origin;
}
.opposite(@origin) when (length(@origin)=2) and ("@{origin}"="left top"){
  @opposite:~"right bottom";
  @to_opposite:~"to @{opposite}";
}
.opposite(@origin) when (length(@origin)=2) and ("@{origin}"="left bottom"){
  @opposite:~"right top";
  @to_opposite:~"to @{opposite}";
}
.opposite(@origin) when (length(@origin)=2) and ("@{origin}"="right top"){
  @opposite:~"left bottom";
  @to_opposite:~"to @{opposite}";
}
.opposite(@origin) when (length(@origin)=2) and ("@{origin}"="right bottom"){
  @opposite:~"left top";
  @to_opposite:~"to @{opposite}";
}
.gradient (@origin:top, @start, @stop) {
  .opposite(@origin);
  background-color: mix(@start,@stop);
  background-image: -webkit-linear-gradient(@origin, @start, @stop);
  background-image: -webkit-gradient(linear, @origin, @opposite, from(@start), to(@stop));
  background-image: -moz-linear-gradient(@origin, @start, @stop);
  background-image: -o-linear-gradient(@origin, @start, @stop);
  background-image: -ms-linear-gradient(@origin, @start, @stop);
  background-image: linear-gradient(@to_opposite, @start, @stop);
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=@start, endColorstr=@stop, GradientType=0);
}
//gradient结束
```
### 特殊的mixin
#### 一些常用的
实例： 
``` less
.clearfix{
  &:before,&:after,{
    display: table;
    content: '';
  }
  &:after{
    clear: both;
  }
}
```
#### 特殊的keyframes(只能生成单属性的动画定义)
实例： 
``` less
.keyframs(2,@prop,@start,@end){
      0%{
        @{prop}:@start;
      }
      100%{
        @{prop}:@end;
      }
}
 //只是支持单属性opacity的动画定义
.keyframes-opacity(10,@value) when (@value<=1){
    @indicate:percentage(@value);
      @{indicate} {
    opacity: @value;
}
.keyframes-opacity(10,@value+0.1);
}
```
### 复合样式mixin:
**注意：此部分废弃，因为项目中大多数是设了部分属性，如`margin-top`和`margin-right`,但如果用了此`mixin`，会造成多了`margin-bottom`和`margin-left`属性，即使他们设的是默认属性。这样很不好，如果要修改这个`mixin`，由于`less`中的判断只有`when`关键字，类似于上面的`line-gradient`,所以要写11条(怎么算出来的：$C_4^2+C_4^3+1$)的判断，很麻烦，所以废弃。后面会有`sass`的方法，完美解决这个问题**  
实例：
``` less
//根据不同的参数只设置部分属性,其他的还是默认值0
.margin(@top:0;@right:0;@bottom:0;@left:0){
  margin-top: @top;
  margin-right: @right;
  margin-bottom: @bottom;
  margin-left: @left;
}
```
为了区分兼容不同浏览器的mixin，这个采用"驼峰命名法".



