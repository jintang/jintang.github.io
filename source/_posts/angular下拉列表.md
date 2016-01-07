title: angular下拉列表
date: 2016-01-07 23:26:18
tags:
categories: angular.js
---
先自定义用的变量
``` javascript
    $scope.list=[
        {id:1,name:'小明'},
        {id:2,name:'小红'}
    ];
    //select默认选中的值
    $scope.default=$scope.list[0].id;
```

``` html
<!-- as前的变量会实现为：<option value="item.id">
     as后的变量会实现为：<option>item.name</option>
     ng-model绑定的值是选中的<option value>，数据是双向绑定的，所以不再事件传值
     -->
<select ng-options="item.id as item.name for item in list"
        ng-model="default">
    <!-- 下面这个可以不要，有的话会多一个无用选项 -->
    <option>请选择</option>
</select>
```
**上面的效果是：**
