title: angularJs我们所应该知道的
date: 2015-12-23 15:45:09
tags: angular
categories: angular
---
### 1.`$scope.$on(name,function)`:

在`controller`里放了这样的语句:
```javascript
    $scope.$on('$ionicView.enter', function() {
    //do something
    });

    $scope.$on('$ionicView.beforeEnter', function() {
    //do something
    });
```
在刚进入controller的时候会先执行直接放在controller里的代码，然后再执行上面的
两个方法。所以，无法用上面的方法对进入controller前进行预处理。

### 2.run():注射器加载完所有模块时，此方法执行一次
``` javascript
    angular.module('yongche',[])
        .run(function(param){
            //do something
        })
```