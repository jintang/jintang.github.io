title: es6常用语法
date: 2017-04-20 10:16:30
tags: 
- es6
categories: Javascript
---

### `...`
含义：
**1.** 函数中的剩余参数
``` js
function pick(object, ...keys) {
    let result = Object.create(null);
    for (let i = 0, len = keys.length; i < len; i++) {
        result[keys[i]] = object[keys[i]];
    }
    return result;
}
```
`keys`  是一个包含所有在  `object`  之后的参数的剩余参数（这与包含所
有参数的  `arguments`  不同，后者会连第一个参数都包含在内）
**2.** 数组的扩展运算: 将一个数组分割，返回分离的各个项
在`vuex`中的辅助函数中常有这样的用法，如下:
``` js
import { mapGetters } from 'vuex'

export default {
  // ...
  computed: {
  // 使用对象展开运算符将 getters 混入 computed 对象中
    ...mapGetters([
      'doneTodosCount',
      'anotherGetter',
      // ...
    ])
  }
}
```
作用是将`mapGetters`返回的数组分割开来放到了`computed`属性里  
还有这样一个例子：
``` js
let values = [25, 50, 75, 100]
// 等价于 console.log(Math.max(25, 50, 75, 100, 120));
console.log(Math.max(...values, 120)); // 120
```
**3.** 对象的扩展运算：属于es7的内容
``` js
let { x, y, ...z } = { x: 1, y: 2, a: 3, b: 4 };
x; // 1
y; // 2
z; // { a: 3, b: 4 }
// 分隔符---------------------------
let n = { x, y, ...z };
n; // { x: 1, y: 2, a: 3, b: 4 }
```
<!-- more -->