title: angularJs我们所应该知道的
date: 2015-12-23 15:45:09
tags: angular需知
categories: angular
---
### $scope.$on(name,function):

在`controller`里放了这样的语句:
``` javascript
    $scope.$on('$ionicView.enter', function() {
    //do something
    });

    $scope.$on('$ionicView.beforeEnter', function() {
    //do something
    });
```
在刚进入controller的时候会先执行直接放在controller里的代码，然后再执行上面的
两个方法。所以，无法用上面的方法对进入controller前进行预处理。 

>- [官方视图生命周期及事件集](http://ionicframework.com/docs/api/directive/ionView/)
- [中文视图生命周期](http://ngionic.com/2014/12/ionic-javascript-api-ion-view-%E8%A7%86%E5%9B%BE%E7%9A%84%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E5%8F%8A%E4%BA%8B%E4%BB%B6%E9%9B%86%E5%90%88/)  

视图生命周期:

| 事件名称 | 作用  |
| ----- | -------- |
| `$ionicView.loaded`  | 视图已经被加载了。这事件只发生一次当视图被创建并添加到Dom中。当跳出页面并且被缓存了的话，再次访问这个页面时这个时间将不会被激活。Loaded事件是个好方式让你为这个视图设置你的代码； 然而，他并不是我们推荐的时间去监听视图被激活。 |
| `$ionicView.enter` |      进入视图并被激活。这事件被激活来判断这个视图是第一个加载还是被缓存了的。 |
| `$ionicView.leave` | 离开这个视图并且不是活动页面。调用这个事件判断应该被缓存还是摧毁。 |
| `$ionicView.beforeEnter` | 视图即将被打开变成活动页面。 |
| `$ionicView.beforeLeave` | 视图将被关闭并且不是活动页面。 |
| `$ionicView.afterEnter` | 进入视图并是当前的活动页面 |
| `$ionicView.afterLeave` |     已经离开视图，并成为非激活页面 |
| `$ionicView.unloaded` | 视图的Controller已经被摧毁并且他的页面元素也从Dom中移除 |
<!-- more -->

### run():注射器加载完所有模块时，此方法执行一次
``` javascript
    angular.module('yongche',[])
        .run(function(param){
            //do something
        })
```