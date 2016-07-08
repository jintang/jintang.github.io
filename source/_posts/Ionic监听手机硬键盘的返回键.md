title: Ionic监听手机硬键盘的返回键
date: 2016-06-22 17:45:35
tags: 
- ionic
- $ionicPlatform
categories: ionic 
---
> 我们用ionic打包的app在真机上需要处理手机硬键盘的返回键,下面提供几种方法:

**首先,放上[官方文档](http://ionicframework.com/docs/api/service/$ionicPlatform/)和[源码地址](https://github.com/driftyco/ionic/blob/master/js/angular/service/platform.js#L2),懒得看英文的,就先看我这个吧**

### $ionicPlatform.registerBackButtonAction(callback, priority, [actionId])

这个方法一般放在`app.js`文件下的`run()`中,`controller`中不起作用,实例如下:
``` javascript
$ionicPlatform.ready(function() {
    $ionicPlatform.registerBackButtonAction(function(e) {
        //1.可以通过$state.current或$location.href()来判断处于哪个页面
        if($state.current.name=="order"){
            //2.因为run方法中无法注入$scope,只能注入$rootScope,此处通过$rootScope来判断子scope中的变量
            if($rootScope.$$childHead.button1.state){
                e.preventDefault();
                return false;
            }else{
                $window.history.back();
            }
        }else if($state.current.name=="map"){
            if($rootScope.$$childHead.locInterval){
                $interval.cancel($rootScope.$$childHead.locInterval);
                console.debug('清除map计时器');
            }
            $window.history.back();
        }
        //3.阻止默认的行为
        e.preventDefault();
        return false;
    },101)//101优先级常用于覆盖‘返回上一个页面’的默认行为  
})
```
<!-- more -->
|参数 | 说明|
| ----|----|
|callback|回调方法|
|priority|**优先级**:常用的优先级有:100=返回上一个页面;150=side menu;200=关闭modal;300=关闭action sheet;400=关闭popup;500=关闭loading overlay;***大于哪个就会覆盖掉哪个默认行为***
|actionId|唯一id(选填)|

### $ionicPlatform.onHardwareBackButton(callback)

这个方法可以写在`controller`中,但有个很严重的bug,实例如下:
``` javascript
$ionicPlatform.ready(function() {
    $ionicPlatform.onHardwareBackButton(back);
})
function back(e){
    console.log('真机返回键事件');
    //严重的bug:无法阻止默认的返回事件:返回到上个页面,下面的语句都不起作用
    e.preventDefault();
    e.stopProgation();
    return false;
}
```
取消注册的返回事件:`$ionicPlatform.offHardwareBackButton(callback)`

我将此方法写入controller,在按返回键的时候,发生了很奇怪的事:

- 第一次进入此页面按返回键:console打印了一遍
- 第二次进入此页面按返回键:console打印了二遍
- 第三次进入此页面按返回键:console打印了三遍

***我分析的原因:***虽然事件注册在这个controller里,但是此事件是全局的,每次进入此页面都会多注册一次

***解决方案:***代码如下:
``` javascript
$ionicPlatform.offHardwareBackButton($scope.goBack);
$ionicPlatform.onHardwareBackButton($scope.goBack);
$scope.goBack=function(){
    /*这儿要先把之前注册的事件清掉*/
    $ionicPlatform.offHardwareBackButton($scope.goBack);
    // do something...
}
```

### document.addEventListener('backbutton',function,false)
这个方法也有那个严重bug,跟上面的`onHardwareBackButton`的bug一样.
***因为***:`onHardwareBackButton`的源码就是封装的document.addEventListener('backbutton',function,false)


