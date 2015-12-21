title: angularJs———directive创建自定义指令
date: 2015-12-13 14:40:37
tags:
---
   **directive:中文是"指令”的意思。**
   
    angular.module('myApp', [])
    .directive('myDirective', function() {
        // 接受两个参数，第一个参数是自定义指令名，第二个是一个方法
        return {
            restrict://有E(element)、A(Attribute)、C(Class)、M(Mark)，默认为A。
            priority: Numbmer,//优先级
            terminal: Boolean,
            template: String or Template Function:function(tElement, tAttrs) (...},
            templateUrl: String,
            replace: Boolean,//默认为false，表示模板会被当作子元素插入到调用此指令的元素内部；为true表示模板会代替调用次指令的元素。
            scope: Boolean or Object,//当为Object时，指令的作用域与dom所对应的controller绑定的规则有：@(dom绑定到指令作用域)、=(dom与指令作用域双向绑定)、&(将dom对方法的引用传到指定作用域)。
            transclude: Boolean,//嵌入，默认为false
            controller: String or function($scope, $element, $attrs, $transclude,otherInjectables) { ... },//String时表示controller的名字，会查找定义在应用中的controller；function时表示是一个内部的controller，直接定义在这儿。
            controllerAs: String,//给controller起的别名
            require: String,
            link: function(scope, iElement, iAttrs) { ... },
        };
    });

#  nhao
    
    