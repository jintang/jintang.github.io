title: js原生时间格式化
date: 2020-09-25 10:00:38
tags:
- javascript
categories: 前端
---

js 原生的时间格式化挺强的，内部用的是 `Intl.DateTimeFormat()` ，附 文档[https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/DateTimeFormat] , `Intl` 对象是 `ECMAScript` 国际化 `API` 的名称空间，它提供语言敏感的字符串比较、数字格式化以及日期和时间格式化。

以下附实用：
``` js
const date = new Date('2020/9/25 09:40:50');

// 日期
console.log(date.toLocaleDateString("zh-CN"));
// 2020/9/25

// 时间
console.log(date.toLocaleTimeString("zh-CN", {
  hour12: false
}));
// 09:40:50 

// 
console.log(date.toLocaleString("zh-CN", { 
  hour12: false
 }));
 // 2020/9/25 09:40:50 

console.log(date.toLocaleString("hc", { 
  hour12: false,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit',
  second: '2-digit'
 }));
 // 2020/09/25 09:40:50
```
**Tip:** 每个日期时间组件属性的默认值都是 `undefined`，但如果所有组件属性都未定义，则假定年、月和日为 `numeric` 。
