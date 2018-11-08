title: html我们应该知道的
date: 2016-09-30 17:05:49
tags: 
- html
- 前端
categories: HTML
---
### document.documentElement
html页面按大小排序：
1. window:整个浏览器窗口，包含工具栏、菜单栏...
2. document:整个html，包含`<DOCTYPE>`
3. html：根节点,`document.documentElement`就是`html`节点
4. body: 页面主体

然后有这样一个问题：如何获取如图的高度?

![高度](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/html_height.png)
这样获取：
``` javascript
    document.documentElement.clientHeight;
    //document.documentElement.offsetHeight不可以，有时候会出错
```

### 调试鼠标hover时提示框的样式
我们经常需要设计提示框，在`hover`时浮现，但是如何在控制台调试这个提示框的样式呢，每次鼠标移开提示框就消失，不胜其烦，这儿有个小技巧

1. 在提示框上右键*检查*,找到对应的dom![inspect](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/inspect.gif)
2. 添加dom断点给`node removal`:![debugger](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/debug.gif)  
 
然后就可以在断点阻塞到提示框显示的时候开心的调试样式了

### 在location中传递中文参数
传递的时候：
``` js
location.href = window.encodeURI(url + '?key=你妹');
```
获取的时候:
``` js
let search = window.decodeURI(location.search);
// 结果是 ?key=你妹
```