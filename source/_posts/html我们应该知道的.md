title: html我们应该知道的
date: 2016-09-30 17:05:49
tags: 
- html
- 前端
categories:
- html
- 前端
---
### document.documentElement
html页面按大小排序：
1. window:整个浏览器窗口，包含工具栏、菜单栏...
2. document:整个html，包含<DOCTYPE>
3. html：根节点,`document.documentElement`就是`html`节点
4. body: 页面主题

然后有这样一个问题：如何获取如图的高度?

![高度](http://7xphbb.com1.z0.glb.clouddn.com/html_height.png)
这样获取：
``` javascript
    document.documentElement.clientHeight;
    document.documentElement.offsetHeight;//两个都可以
```

