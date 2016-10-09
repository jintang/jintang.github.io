title: js我们应该知道的
date: 2016-07-08 15:09:44
tags:
- 前端
- css
categories: 前端
---
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
