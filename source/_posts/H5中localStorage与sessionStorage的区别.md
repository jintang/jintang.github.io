title: H5中localStorage与sessionStorage的区别
date: 2016-10-08 11:19:01
tags: 
- HTML5
- localStorage
- sessionStorage
categories: 前端
---
>本文参考：[邹润阳](http://jerryzou.com/posts/cookie-and-web-storage/)  
>Storage的用法：[Storage的API](https://developer.mozilla.org/en-US/docs/Web/API/Storage) 

### 相同点
`localStorage`与`sessionStorage`都是h5中出现的，都继承于`Storage`，用法完全相同，大小一般都是5M左右。
### 不同点
- localStorage：除非被手动清除，否则永久保存
- sessionStorage：仅在当前会话下有效，关闭tab或浏览器(window)后被清除  
*注意*：  
1. 刷新页面时不会清除
2. 页面跳转时，如果还在当前网站范围内则不清除。如果跳转到了其他网站则清除
<!-- more -->