title: jq的promise
date: 2016-09-30 09:23:51
tags: 
- jQuery
- ajax
- promise
categories:
- 前端
- js
---
>之前用angular的$http向接口发起请求，里面的回调写法感觉很好看，最近用jquery，也找到相同的写法，展示于此处。

### jq Ajax中的Promise

常规的`ajax`写法：
``` javascript
$.ajax({
    type : "post",
    dataType : "json",
    url : "project_getProJect.action",
    async : true,//默认就是true，表示异步
    data:{proUuid:uuid},
    success : function(result) {
    },
    error: function(error){
    },
    complete: function(){
    }
});
```
为了方便使用`ajax`，封装如下：
``` javascript
function AjaxServer(url,data){
    return $.ajax({
        type:'POST',
        url:url,
        data:data,
        dataType:'json'
    });
}
```
<!-- more -->
那么，这个`AjaxServer`返回的是什么呢？是一个`XMLHttpRequest`（`jqXHR`）对象，从jQuery1.5开始，该对象实现了`Promise`接口, 使它拥有了 `Promise` 的所有属性、方法和行为。可参考:[jQuery.Deferred对象](http://www.css88.com/jqapi-1.9/category/deferred-object/)

然后就可以这样调用ajax:

**写法1**
``` javascript
AjaxServer(url,data).done(function(data, textStatus, jqXHR){
    //取代了的过时的jqXHR.success()
}).fail(function(jqXHR, textStatus, errorThrown){
    //取代了的过时的jqXHR.error()
}).always(function(data|jqXHR, textStatus, jqXHR|errorThrown){
    //取代了的过时的jqXHR.complete()方法

    //在响应一个成功的请求后，该函数的参数和.done()的参数是相同的。
    //对于失败的请求，参数和.fail()的参数是相同的*/
})
```
**写法2**
``` javascript
AjaxServer(url,data).then(function(data, textStatus, jqXHR) {
    //封装的.done()
}, function(jqXHR, textStatus, errorThrown) {
    //封装的.fail()
});
```
从angular沿袭下来的习惯，我比较喜欢**写法2**。

**Tip:**在调用接口失败时或者接口返回的值不是我们期望的值时，我们经常需要提示，但这两种情况的提示一般是相近的(如果要求不严格的话),所以为了简练，可以这样写：
``` javascript
AjaxServer(url,data).always(function(result,textStatus,obj){
    if(result.data&&result.data==true){

    }else{
        //else里面全是不满足要求的情况，进行提示
    }
});
```
### [jQuery.Deferred对象](http://www.css88.com/jqapi-1.9/category/deferred-object/)
>对比参考：[angular中promise与defer](http://jintang.github.io/2016/04/19/angular%E4%B9%8Bpromise%E7%9A%84%E7%94%A8%E6%B3%95/)

#### 基本用法：强制同步(以点击事件触发为例)

html:
``` html
    <input type="text" value="小明" id="name">
    <input type="button" value="查询" onclick="search()">
    <br><br>
    <input type="button" value="点击" onclick="click1()" class="bt" id="click1">
    <input type="button" value="点击" onclick="click2()" class="bt">
    <input type="button" value="点击" onclick="click3()" class="bt">
    <input type="button" value="点击" onclick="click4()" class="bt">
```
js:
``` javascript
    function search(){
        delegateClick().done(function(result){
            console.log('search:'+result);
        })
    }
    var defer;
    function delegateClick(){
        defer=$.Deferred();
        $('.bt').click();
        return defer.promise();//将defer对象转为promise对象
    }

    function click1(){
        console.log('1');
    }
    function click2(){
        console.log('2');
    }
    function click3(){
        console.log('3');
    }
    function click4(){
        setTimeout(function(){
            console.log('模拟ajax的延迟');
            defer.resolve('click4执行完了');
        },2000);
    }
```
点击"查询"按钮的输出结果为：
![jq defer](http://7xphbb.com1.z0.glb.clouddn.com/jq/jq_promise1.png)

从结果可以看出：`resolve()`触发了`done(callback)`。其实：
- defer.resolve():触发 done 的回调执行,并传值给回调方法。
- defer.reject():触发 fail 的回调,并传值给回调方法。
- defer.notify():触发 progress 的回调,并传值给回调方法。
另外：上面这三个方法都会触发 always 的回调

#### 链式调用
有这样三个方法,让他们链式调用
``` javascript
    function delay(){
        var defer=$.Deferred();
        setTimeout(function(){
            console.log('delay()');
            defer.resolve();
        },2000);
        return defer.promise();
    }
    function animate(){
        return $('#name').animate({height:'100px'},1000,function(){
            console.log('动画执行完成');
        }).promise();
    }
    function click1(){
        var defer=$.Deferred();
        setTimeout(function(){
            console.log('click1()');
            defer.resolve();
        },500);
        return defer.promise();
    }
```
**写法1**
``` javascript
    function search(){
        var promiseA=delay();
        var promiseB=promiseA.then(function(){
            return  animate();
        });
        var promiseC=promiseB.then(function(){
            return click1();
        });
        promiseC.then(function(){
            console.log('链式调用完成');
        });
    }
```
结果如图：
![链式调用结果](http://7xphbb.com1.z0.glb.clouddn.com/jq/jq_promise2.png)
**写法2**
``` javascript
    function search(){
        //注意：then()里面是函数名，而不是animate()这种，这样then()里面得到的是一个匿名的函数体，
        //而该函数中返回的是 promise 对象，这样才符合了我们对 then 接受参数的要求
        $.when(delay()).then(animate).then(click1).then(function(){
            console.log('链式调用完成');
        })
    }
```
结果同**写法1**

`$.when()`接受一个Promise对象，[$.when更多介绍](http://www.css88.com/jqapi-1.9/jQuery.when/)

如果写作:
``` javascript
     $.when(delay()).then(animate()).then(click1());
```
那就相当于
``` jquery
     $.when(delay(),animate(),click1());
```
其结果是：三个方法异步一起执行。

**备注：promise与defer的区别**
promise:promise 对象是没有 resolve , reject , notify 等方法的，也就意味着，你无法针对 promise 对象进行状态更改，只能在 done 或 fail 中进行回调配置。promise相当于defer对象的子集。
