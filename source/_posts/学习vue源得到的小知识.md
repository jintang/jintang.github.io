title: 学习vue源码得到的知识
date: 2018-12-10 17:57:59
tags:
- vue
categories: 前端
---
### Vue.extend(): 创建 "Vue" 的 子类

### window.performance: 监控代码性能
``` js
const perf = inBrowser && window.performance;
mark('start')
// do something
mark('end')
```

### 小技巧
1. 遍历数组：
``` js 
let i = props.length
while (i--) {   、
    // ...
}
```
2. js 中一个值与自身都不相等: NaN 。通过下面的方式判断
``` js
if (newVal === value || (newVal !== newVal && value !== value)) {
  // newVal 是 NaN
}
```
3. IE11 才开始支持 `__proto__` , 之前的不支持
如何拦截 读取和写入 纯对象/数组 

4. 缓存一个纯函数: cached 实现？