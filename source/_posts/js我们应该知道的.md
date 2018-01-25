title: js我们应该知道的
date: 2016-07-08 15:09:44
tags:
- 前端
- css
categories: Javascript
---
### eval()方法的替换方法
js里有个神奇的方法：`eval()`，但是不建议使用，原因看看[知乎的回答](https://www.zhihu.com/question/20591877)，但是有时候我们确实需要一个这样作用的方法，下面是替换的方法：  
来源于[这位前辈的文章](http://blog.csdn.net/xundh/article/details/48153121)
``` javascript
//计算表达式的值
function evil(fn) {
    var Fn = Function;  //一个变量指向Function，防止有些前端编译工具报错
    return new Fn('return ' + fn)();
}
```
**解释一下**：  
我们创建方法通常有三种方式：
``` javascript 
/*1.函数声明*/
function fun(){}
/*2.函数表达式*/
var aaa=function(){}
/*3.用Function构造函数：
* 可接受多个参数，但最后一个参数总是函数体,前面的才是新方法的参数
*/
var aaa=new Function(arg1,arg2...argn);
```
所以,利用`Function()`构造方法就可以实现`eval()`的功能
<!-- more -->
### setTimeout(fun,time)与setInterval(fun,time)
返回值是个唯一标识符，通常是个数字。 用于清除定时器和gc回收，比如：
``` js
    var timer = setTimeout(function() {}, 500)
    clearTimeout(timer); // 清除定时器
    timer = null; // 释放让gc回收
```
**注意：**
1. 在`time`的延迟之后才可以执行第一次，而不是马上开始执行。即使是`setTimeout(fun, 0)`，也是在主线程执行后再执行`fun`.
    ``` js
    setTimeout(function() {
        console.log('a')
    }, 0)
    console.log('b')
    // b
    // a
    ```
2. 要想循环体立即执行，可以这样：
    ``` js
    function hand() {
        setTimeout(function() {
            hand()
        }, 500)
        console.log(new Date())
    }
    ```
### 方法内部的`return false`
经常可以看到这样的语句:
``` javascript
    $('a').bind('click',test);
    function test(){
        console.log(123);
        return false;
    }
```
`return false`等于`e.preventDefault()`
### 从一个数组中删除子数组
先看下**第一版**：
``` js
function del(arr, delArr) {
    for (let i = 0; i < arr.length; i ++) {
      let item = arr[i];  
      for (let j = 0; j < delArr.length; j++) {
        let delItem = delArr[j];
        if (item === delItem) { // 满足某种条件
            arr.splice(i , 1);
        }
      }
    }
}
```
乍看之下没问题，但有问题。
``` js
let arr = [1,2,3,4,5];
let delArr = [4,5];
del(arr, delArr);
console.log(arr) // [1,2,3,5]
```
原因很简单，先删除了4，此时5的下标已经往前移动了1，然而循环的i已经到了5当前的下标，所以就跳过了5的判断。下面来个**修复版1**：
``` js
function del(arr, delArr) {
    for (let i = 0; i < delArr.length; i ++) {
      let delItem = delArr[i];  
      for (let j = 0; j < arr.length; j++) {
        let item = arr[j];
        if (item === delItem) { // 满足某种条件
            arr.splice(j , 1);
            break;
        }
      }
    }
}
```
只是换了两个循环的顺序，就ok了。因为两个数组里没有重复数据，所以在删除一个元素之后可以通过`break`直接进行下一次外层循环。得到正确的结果。试试下面的例子：
``` js
let arr = [1,2,3,4,4,5];
let delArr = [4,5];
del(arr, delArr);
console.log(arr) // [1,2,3,4]
```
可能是`del`方法里用了`break`的原因，去掉之后发现还是同样的结果。原因同**第一版**。  
再来看看**修复版2**：
``` js
function del(arr, delArr) {
    for (let i = 0; i < delArr.length; i ++) {
      let delItem = delArr[i];  
      for (let j = arr.length - 1; j > 0 ; j--) {
        let item = arr[j];
        if (item === delItem) { // 满足某种条件
            arr.splice(j , 1);
        }
      }
    }
}
```
再试试上面的例子，得到的结果正确。不论是数组中有没有重复数据，都可以得到正确的结果。原因想必大家一看就明白了，对`arr`的循环一定要倒序，这样才不会跳过某一项。