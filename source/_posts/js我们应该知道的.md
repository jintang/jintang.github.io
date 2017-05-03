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

### setInterval(function,time)
1. 此方法是在time的延迟之后才可以循环执行，而不是马上开始循环执行
2. 用`clearInterval()`来清除循环，往往不能马上停止循环，而是会继续执行一次之后再停止。解决办法是用`setTimeout()`的递归来代替`setInterval()`
3. `clearInterval(myInterval)`之后myInterval的值的问题：
``` javascript
    var myInterval;
    function click1(){
        clearInterval(myInterval);
    }
    function click2(){
        function click2(){
            if(!myInterval){
                myInterval=setInterval(function(){
                    console.log('循环执行一次');
                },2000);
            }
        }
    }
    click2();//首先执行一遍click2()
```
Q:点击click1之后再点击click2,log还打印吗？

A:不再继续打印了，因为`clearInterval(myInterval)`后myInterval是一个整数，是`myInterval=setInterval()`语句指定的唯一辨识符:`intervalID`，所以click1()改为这样：
``` javascript
    function click1(){
        clearInterval(myInterval);
        myInterval=null;//正好也可以方便js的CG回收该对象
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
<!-- more -->
