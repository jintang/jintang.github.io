title: angularJs 常见错误
date: 2015-12-17 21:53:24
tags: angular常见错误
categories: angular
---
#### ng-show和ng-hide作用相反了，即：ng-show="true"时隐藏，ng-hide="true"时显示。

**原因：**指令前带ng的都是AngularJs的内置指令，对应的值不应该带"花括号"，以ng-show为例，而我是这样写的:
    
    <div ng-show="{% raw -%}{{myArg}}{%- endraw %}"></div>

应该这样写：

    <div ng-show="myArg"></div>

当时百思不得其解，ng-show与ng-hide的规则竟然会相反，原来是因为这样。

** 结论：AngularJs自带的指令不能使用"{% raw -%}{{}}{%- endraw %}"**
<!-- more -->

#### Unknown Provider：某某1 <—— 某某2 <—— 某某3：
**原因：**js文件中有不能识别的"依赖"，从属关系为：某某1出现在某某2中，某某2出现在某某3中，所以直接找某某3中依赖的东西，将不能识别的删除即可。以前老看不明白这是什么意思，今天明白了。

#### 打包在真机的app在三星手机上ng-click不触发

**原因:**无法触发`ng-click`的元素都是脱离了普通文档流的:`position:absolute;float`等。不知道三星的手机浏览器具体是什么内核,而其他品牌的手机都可以

**解决方案:**既然知道了浅层次的原因,解决方法也呼之欲出。使用其他布局代替`position:absolute;float`就好了。