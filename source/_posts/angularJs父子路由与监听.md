title: angularJs父子路由与监听
date: 2015-12-23 09:18:54
tags: angular.js
categories: angular.js
---
``` angularjs
$scope.$on("$destroy", function() {
    alert("leave the view");
});
 
```