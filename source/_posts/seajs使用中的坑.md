title: seajs使用中的坑
date: 2016-09-21 18:44:45
tags: 
- seajs
- 模块化
categories: Javascript
---
>早有耳闻`模块化`的优点，最近在使用的过程中才慢慢加深了感触，恩...确实方便，下面讲讲我遇到的坑,提一下,seajs是CMD规范

### seajs约定的书写规范：
``` javascript
var path='./test';
require(path);
```
恩，没错，这样是错误的。`require`只能使用**直接量**,即：字符串常量

替换的方案：
```
var moduleName='test';
require.async('./'+moduleName,function(m){
    m.render();
})
```
<!-- more -->
### 同步加载多个模块
在改写项目的时候，有这样一个插件：

![kendo](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/seajs/kendo.png)  

没错....要使用这个插件，必须加载这些模块：`kendo.button.min.js`、`kendo.core.min.js`、`kendo.draganddrop.min.js`、`kendo.userevents.min.js`、`kendo.window.min.js`。你又猜对了，这些模块间是有依赖关系的，原项目用的是`requirejs`，依赖如图：
![kendo_depend](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/seajs/kendo_depend.png)

改写如下：
``` javascript
require.async('kendoCore',function(){
    require.async('kendoUserevents',function(){
        require.async('kendoDraganddrop',function(){
            require.async('kendoWindow',function(){
                require('kendoButton');     
            })
        });
    });
}); 
```
感觉好傻逼，有木有。。。谁有好点的方法请留言！

### 路径解析
`seajs.user('path')` ： `seajs` 引用路径时默认给加后缀 `js`，除非路径有 `?` 或者 尾部以 `#` 结束 或者载入的是 `css` 模块。它的与普通的路径解析略有不同： 
> `seajs.use()` 一般用于载入入口模块，当只有一个入口模块时可以用 `data-main` 标签代替
 
- 相对路径: 以`.`开头
- 绝对路径：以`/`或`http://cdn.com/js/a`(这种类型)开头
- 顶级路径：不以`.`或`/`开头的路径都是顶级路径，此时以`Seajs`设定的`base`路径来解析  
