title: es6常用语法
date: 2017-04-20 10:16:30
tags: 
- es6
categories: Javascript
---

### ...
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
`keys`  是一个包含所有在  `object`  之后的参数的剩余参数（这与包含所有参数的  `arguments`  不同，后者会连第一个参数都包含在内）

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

### export与import
- 命名导出: 对导出多个值很有用。在导入期间，必须使用相应对象的相同名称
    ``` js
    // module "modules.js"
    export function cube(x) {}
    const foo = Math.PI + Math.SQRT2;
    export var a = 1;
    export { cube,foo };
    // 导入时：
    import { cube, foo, a } from 'modules.js';
    ```
- 默认导出: 可以使用任何名称导入默认导出,且一个模块只能有一个默认的导出
    ``` js
    // module "modules.js"
    export default k = 12;
    // 导入时：
    import x from 'modules.js';
    ```
    
**注意：**不能直接使用`var`，`let`或`const`作为默认导出
``` js
var a = 1;
export default a;　　// 正确,可以用这种方式
export default var a = 1; // 错误
```
**原因：**`export`后面需要跟变量声明或者大括号作为输出，而`export default`命令其实只是输出一个叫做`default`的变量，所以它后面不能跟变量声明语句。
``` js
// modules.js
function add(x, y) {
  return x * y;
}
export default add;
// 等同于 export {add as default};

// app.js
import xxx from 'modules';
// 等同于 import { default as xxx } from 'modules.js';
```

**综合用法：**
一些成熟的框架都是这样导入的：
```  js
import React, { Component } from 'react';
```
下面就是我们的实例：
``` js
// modules.js
export add() {}
export reduce() {}
const calcObj = {add, reduce};
export default calcObj;
// 导入时:
import calcObj, {add, reduce} from 'modules.js'
```

### Generator  函数
``` js
function* fun() {
  yield 'a';
  yield 'b';
  return 'c';
}
/* 该函数并不执行返回的值，也不是函数运行结果，
*  而是一个指向内部状态的指针对象：遍历器对象*/
var funIte = fun(); 

/* 每次调用next方法，内部指针就从上一次停下来的地方
开始执行，直到遇到下一个yield语句（或return语句）为止*/
funIte.next(); // {value: 'a', done: false}
funIte.next(); // {value: 'b', done: false}
funIte.next(); // {value: 'c', done: true}
funIte.next(); // {value: undefined, done: true}
```
这种函数有两个特征：
- function关键字后紧跟`*`
- 函数内部用`yield`语句。yield意思是*产出*