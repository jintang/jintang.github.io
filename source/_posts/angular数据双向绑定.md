title: angular数据双向绑定bug
date: 2016-05-05 13:40:58
tags: angular数据双向绑定
categories: angular
---
本文主要参考:[http://www.ngnice.com/posts/2c8208220edb94](http://www.ngnice.com/posts/2c8208220edb94)

>angular不推荐直接操作dom,建议使用双向绑定的数据来操作

### 1.从controller绑定到html上,有时候数据改变了,但是html并不刷新

**原因:**一般是$apply导致的,对于大多数操作，$apply都会自动执行，所以不用担心，但是如果使用了angular之外的功能，比如直接调用了setTimeout函数、挂接了jquery的事件、使用了jquery的ajax操作等等.那么系统就没有机会帮你调用$apply，界面也就没有机会刷新了，但是你如果之后又做了其他会导致$apply的操作，你会发现以前“欠下”的那次界面刷新被正常执行了

*例:*
``` javascript
//这种情况下你在页面中绑定的time变量将不会被自动刷新
setTimeout(function() {
  $scope.time = new Date()
}, 1000);
```

**解决方案:**

(1). 手动刷新:
``` javascript
setTimeout(function() {
  $scope.$apply(function() {
    $scope.time = new Date();
  });
}, 1000);
```
(2). 使用angular内置指令:**因为angular内置指令最后会调用$apply()**
``` javascript

$timeout(function() {
  $scope.time = new Date();
});

```
<!-- more -->

### 2.从html绑定到controller里,html动态改变了数据,但是controller中数据并不改变
*例1:这段代码运行正常*
``` javascript
<label><input type="radio" ng-model="color" value="red">  Red </label><br/>
<label><input type="radio" ng-model="color" value="green"> Green</label><br/>
<label><input type="radio" ng-model="color" value="blue"> Blue </label><br/>
<!-- color的值会随着选中的单选按钮而改变 -->
{{color}}
```
*例2:这段代码工作不正常，color值将不会随着选择而变化*
``` javascript
<div ng-repeat="value in ['red', 'green', 'blue']">
  <label><input type="radio" ng-model="color" ng-value="value">  {{value}} </label>
</div>
{{color}}
```
**原因:**ng-repeat创建了一个子scope,对color值的修改，会去修改子级的变量，而父级的同名变量不会被修改。因为`angular的继承方式是js的原型继承,外层的color读到的是外层scope的变量,而不会读到子层scope的`

**解决方案:**
``` javascript
div ng-repeat="value in ['red', 'green', 'blue']">
  <label><input type="radio" ng-model="vm.color" ng-value="value">  {{value}} </label>
</div>
{{vm.color}}
```
**分析:**外层scope定义了对象$scope.vm={}(vm此处的寓意是ViewModel),根据js中基本类型与引用类型存储的堆栈方式,在子scope中绑定的是vm.color,改变的vm对象的属性,而不是vm这个对象,所以,赋值会正确的作用到父级scope上.

**关键理解:原型继承,基本类型与引用类型在堆栈中的存储方式**
