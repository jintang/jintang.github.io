title: angular中promise的用法
date: 2016-04-19 17:22:57
tags: angular之promise
categories: angular
---
本文参考自http://www.cnblogs.com/mliudong/p/4151594.html

## 实例演示
Promise是一种模式，以同步操作的流程形式来操作异步事件，避免了层层嵌套，可以链式操作异步事件。

**Service:HelloWorld的定义如下:**
``` javascript
.factory('HelloWorld', function($q, $timeout) {
    var getMessages = function() {
        var deferred = $q.defer();
        $timeout(function() {
            deferred.resolve(['Hello', 'world']);
        }, 500);
        return deferred.promise;
    };
    return {
        getMessages: getMessages
    };
})
```
<!-- more -->
**Controller代码:**
``` javascript
    function async(sex) {
        var defer = $q.defer();
        setTimeout(function() {
            $scope.$apply(function() {
                defer.notify("查询性别中");
                if (sex=='male') {
                    defer.resolve('性别是' + sex );
                } else {
                    defer.reject('性别不是 ' + sex);
                }
            });
        }, 1000);
        return defer.promise;
    }
    var sex='male';
    var age=11;
    var promiseA = async(sex);
    promiseB=promiseA.then(function (response) {
        console.log("第一次promise:"+response);
        //可以直接返回值
        return response;
    }); 
    promiseC=promiseB.then(function (response) {
        var defer=$q.defer();
        HelloWorld.getMessages().then(function(rrr){
            defer.resolve('rrr===='+rrr);
            console.log("第二次promise:"+rrr);
        })
        //如果promise里面有回调,不能直接返回,还是要用defer处理后返回defer.promise
         return defer.promise; 
    })
    promiseC.then(function (response) {
        setTimeout(function () {
         console.log("第三次promise:"+response);
        }, 800);
    })
```
**结果如下:**
promiseA花费的时间为:1000ms;
promiseB花费的时间为:500ms;
promiseC花费的时间为:800ms;
虽然promiseB花费的时间最短,但是还是按链式执行,结果如下:
![结果](http://7xphbb.com1.z0.glb.clouddn.com/promise.png)


## 用法
#### 1. 通过调用 `$q.defferd` 返回`deffered`对象以链式调用
获得`var defer = $q.defer()`;
**defer有三种方法:**

* resolve(value):表示promise执行成功
* reject(reason):表示promise执行失败
* notify(value): 通知promise的执行状态,会被调用0到多次

**deffered 对象属性:**

`promise` ：最后返回的是一个新的deferred对象 promise 属性，而不是原来的deferred对象。这个新的Promise对象只能观察原来Promise对象的状态，而无法修改deferred对象的内在状态。

#### 2. 当创建 deferred 对象时会创建一个新的 promise 对象,并可以通过 deferred.promise 得到该引用。
promise 对象的目的是在 deferred 任务完成时,允许感兴趣的部分取得其执行结果。

**promise的方法:**

- *then(errorHandler, fulfilledHandler, progressHandler)* ：then方法用来监听一个Promise的不同状态。errorHandler监听failed状态，fulfilledHandler监听fulfilled状态，progressHandler监听unfulfilled（未完成）状态。此外,notify 回调可能被调用 0到多次，提供一个进度指示在解决或拒绝（resolve和rejected）之前
- *catch(errorCallback)* : promise.then(null, errorCallback) 的快捷方式
- *finally(callback)* : 让你可以观察到一个 promise 是被执行还是被拒绝, 但这样做不用修改最后的 value值。 这可以用来做一些释放资源或者清理无用对象的工作,不管promise 被拒绝还是解决

**Tip:通过then()方法可以实现promise链式调用**
``` javascript
promiseB = promiseA.then(function(result) {  
  return result + 1;  
}); 
//promiseB 将会在处理完 promiseA 之后立刻被处理, 并且其result值是promiseA的返回值  
promiseB.then(function(result){
    //do something   
})
```

