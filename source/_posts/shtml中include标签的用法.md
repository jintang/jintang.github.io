title: .shtml中include标签的用法
date: 2016-07-13 14:34:40
tags: 
- 前端
- SSI
categories: HTML
---
> 我们的`html`文件类似的有`.shtml`、`shtm`，这种和`html`文件的区别在于：

- html是一种静态生成的页面
- shtml是一种基于`SSI(Server Side Include)`技术的文件,它的机制是动态包含。
    - SSI 就是在 HTML 文件中，可以通过注释行调用的命令;
    - 当我们向 web服务器比如 apache 请求访问页面时，如果解析到其中有 SSI 包含指令时，就会自动包含被包含的页面;
    - 包含动作是在每次用户请求页面时发生，所以如果被包含的页面内容有变化，也能实时的反应出来，正因为如此，就很容易用来实现静态页面的动态嵌入，我们就可以把**出现很多的重复区域内容发布成一个独立静态页面**，然后在需要的地方用SSI指令包含进去，比如像**全站的头部和尾部**，**全站最新新闻**等等;

深入理解参考：http://www.cnblogs.com/zichi/p/5111159.html

那么，常用的SSI指令是什么呢？是`include`,用例如下：
``` html
<!-- 通过注释的方法来嵌入 -->
<!--#include virtual="/modelExample/common/title.shtml"-->
```
<!-- more -->
### include标签的语法`<!-- #include PathType = FilePath -->  `
- **FilePath:**分为`绝对路径`与`相对路径`
    - 绝对路径：以`/`开头
    - 相对路径：不是以`/`开头的都是相对路径
- **pathType:**`virtual`与`file`
    - virtual:可以使用绝对路径，这样就可以使用指向上层目录
    - file:只能是相对路径，不能使用绝对路径，无法指向上层目录

**共同点：**`virtual`与`file`都使用相对路径时，效果一样；

可以参考：http://ttaale.iteye.com/blog/1030439

但我测试他说的`virtual`通过相对路径访问上层目录是不行的

**Tip:**假如`include`引入了公共头，而在公共头里又引入了其他文件，此时我们的路径是引入公共头的路径，而不是公共头所在的路径。这时候，如果公共头里引入的其他文件是相对路径，就有可能访问不到，所以公共头里引入的其他文件最好是绝对路径。

 


