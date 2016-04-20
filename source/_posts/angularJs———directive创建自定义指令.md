title: angularJs———directive创建自定义指令
date: 2015-12-13 14:40:37
tags: angular
categories: directive 
---
   **directive:中文是"指令”的意思。**
   
``` javascript
angular.module('myApp', [])
.directive('myDirective', function() {
    // 接受两个参数，第一个参数是自定义指令名，第二个是一个方法
    return {
        restrict://有E(element)、A(Attribute)、C(Class)、M(Mark)，默认为A。
        priority: Numbmer,//优先级
        terminal: Boolean,
        template: String or Template Function:function(tElement, tAttrs) (...},
        templateUrl: String,
        replace: Boolean,
        /*默认为false，表示模板会被当作子元素插入到调用此指令的元素内部；
        为true表示模板会代替调用次指令的元素；*/

        transclude: Boolean,//是否允许指令嵌入，默认为false(不允许嵌套)

        scope: Boolean or Object,
        /*创建独立作用域。
        当为Object时，指令的作用域与dom所对应的controller绑定的规则有：
            @(dom绑定到指令作用域)、
            =(dom与指令作用域双向绑定)、
            &(将dom对方法的引用传到指定作用域)。
        */

        controller: String or function($scope, $element, $attrs, $transclude,otherInjectables) { ... },
        /*在此controller中定义的方法是暴露给外面，供外面调用的。
            String时表示controller的名字，会查找定义在应用中的controller；
            function时表示是一个内部的controller，直接定义在这儿；
        */

        controllerAs: String,//给controller起的别名
        require: String,//此指令依赖的对象，可以是另一个指令
        link: function(scope, element, attr, 父控制器(可选)) { 
            //给此指令绑定一个dom事件:滑动
            element.bind('mouseenter',function(){
                console.log('鼠标滑动了');
                //可直接调用controller中的$scope.test()
                scope.test();
                //也可以这样写,作用和上面一样
                scope.$apply("test()");
            });
         },
    };
});
```

### 指令的一些技巧：
##### 1.指令的复用
上面学会了如何在link()中调用controller中的方法，那指令在不同的地方如何调用不同的方法呢？
``` html
<!-- 为自定义指令添加了一个自定义属性,自定义属性绑定了controller中的方法 -->
<div ng-controller="myCtrl1">
    <myDirective whereUse="use1()"></myDirective>
</div>
<div ng-controller="myCtrl2">
    <myDirective whereUse="use2()"></myDirective>
</div>
```
``` javascript
.controller('myCtrl1', function() {
    $scope.use1=function(){
        console.log("111111");
    }
})
.controller('myCtrl2', function() {
    $scope.use2=function(){
        console.log("22222");
    }
})
```
``` javascript
.directive('myDirective', function() {
    return {
       restrict:'EA',
       link: function(scope, element, attr) { 
            element.bind('mouseenter',function(){
/*tip:若页面上是驼峰式写法，此处获取属性要用小写，因为directive是json格式的，至于json为什么要小写，我也不明白。这儿是个坑*/
                //attr.whereuse();//获取到绑定的方法
                scope.$apply(attr.whereuse);//调用该方法，里面不是whereuser()
            });
         }
    }
})

```




###  指令执行的机制：
#### 1.加载阶段
加载angular.js，找到ng-app指令，确定应用边界。
#### 2.编译阶段(compile)
##### （1）遍历dom，找到所有的指令
##### （2） 根据指令的属性，如replace、template等转换为dom结构
##### （3）如果指令中存在compile( )则调用。
但一般不在指令内部写compile()，因为要写的话里面还需要调用angular默认的compile()
#### 3.链接阶段(link)
##### （1）对每一条指令运行link()
##### （2）link函数一般用来操作dom、绑定事件监听器    
比如：指令和数据间的操作，就是在link()里面执行的。


tip：
> 1.compile()用于对模板自身进行转换，而link()负责在模型和视图之间进行动态关联；
> 2.compile()仅在编译阶段运行一次，而对于指令的每个实例，link()都会执行一次；
> 3.如前所述，大多数时候我们不写compile()，只写link()；

> 以下几点先做留存，没有理解：
> 4.compile()可以返回preLink()与postLink()，而link()只会返回postLink();
> 5.如果需要修改dom，应该在postLink()中修改，在preLink()中修改会出错；
> 6.作用域在链接阶段才会绑定到编译之后的link()上；







    