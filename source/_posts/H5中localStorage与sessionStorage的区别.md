title: H5中localStorage与sessionStorage的区别
date: 2016-10-08 11:19:01
tags: 
- HTML5
- localStorage
- sessionStorage
categories: HTML5
---
>本文参考：[邹润阳](http://jerryzou.com/posts/cookie-and-web-storage/)  
>Storage的用法：[Storage的API](https://developer.mozilla.org/zh-CN/docs/Web/API/Storage) 

### 相同点
`localStorage`与`sessionStorage`都是h5中出现的，都继承于`Storage`，用法完全相同，大小一般都是5M左右。
### 不同点
- `localStorage` ：除非被手动清除，否则永久保存
- `sessionStorage` ：仅在当前会话下有效，关闭 tab 或 浏览器(window) 后被清除  
    - 刷新页面时不会清除
    - 页面跳转时，如果还在当前网站范围内则不清除。如果跳转到了其他网站则清除
<!-- more -->

### 属性与方法
- `Storage.length` : 返回一个整数，表示存储在 Storage 对象中的数据项数量。只读。
- `Storage.key()` ：该方法接受一个数值 n 作为参数，并返回存储中的第 n 个键名。
- `Storage.getItem()` ：该方法接受一个键名作为参数，返回键名对应的值。
- `Storage.setItem()` : 该方法接受一个键名和值作为参数，将会把键值对添加到存储中，如果键名存在，则更新其对应的值。
- `Storage.removeItem()`: 该方法接受一个键名作为参数，并把该键名从存储中删除。
- `Storage.clear()` :调用该方法会清空存储中的所有键名。