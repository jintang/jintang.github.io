title: sass VS less
date: 2016-11-17 10:53:41
tags: 
- less
- sass
- css
categories: 前端
---
>为了重构项目的css代码，先体验了`less`，但发现less不能满足我的需求，没办法转为`sass`,在此描述一下自我感受这两者的区别。我描述的只是我直观使用的部分，大部分的不同点百度一下，第一页的全一样。。。

### 判断条件的区别(感觉最重要的地方)
- `less`写`mixin`时判断的唯一关键字就是`when`，而我需要生成复合样式中的一部分，像这样：
``` css
a{
    border-right:1px;
    border-bottom:2px;
}
```
要选择性的生成部分属性，`less`很不方便，可以参考前面一篇文章[less实战全解之复合样式mixin](http://jintang.github.io/2016/11/10/less%E4%BD%BF%E7%94%A8%E5%85%A8%E8%A7%A3-%E9%99%84%E5%BC%80%E5%8F%91%E8%A7%84%E8%8C%83%E4%B8%8E%E5%9F%BA%E6%9C%ACminix/#复合样式mixin)

- `sass`的判断关键字很符合我们的习惯`@if`、`@else`、`@else if`,还有其他的`@for`、`@each`，非常强大。额...有点跑题，继续。那么用`sass`处理符合属性可以写成这样,不会生成多余的属性：
``` scss
@mixin position($position,$top:null,$right:null,$bottom:null,$left:null,$z-index:null){
  position: $position;
  @if $top{top: $top;}
  @if $right{right: $right;}
  @if $bottom{bottom: $bottom;}
  @if $left{left: $left;}
  @if $z-index{z-index: $z-index;}
}
```
假设要编译成这样的css:
``` css
  position: absolute;
  right: 0;
  bottom: 0;
```
使用的方式有两种：
``` sass
//方法1,最后一个"有效参数"前面的参数设为null，后面的不用管，因为参数默认值就是null
@include position(absolute,null,0,0);
//方法2,指定参数名称
@include position(absolute,$right:0,$bottom:0);
```
<!-- more -->
而且像`sass`写的这种：支持多属性的0%和100%
``` sass
@mixin frames($props,$starts,$ends){
  $length:length($props);
  0% {
    @for $i from 1 through $length{
      $prop:nth($props,$i);
      #{$prop}:nth($starts,$i);
    }
  }
  100%{
    @for $j from 1 through $length{
      $prop:nth($props,$j);
      #{$prop}:nth($ends,$j);
    }
  }
}
```
`less`由于缺少`for`这种关键字，只能通过递归实现循环，要实现上面的效果，想想就醉了

### `import`的路径问题
- `less`:可以使用相对路径和绝对路径，可以参考[前面的文章](http://jintang.github.io/2016/11/07/less%E4%BD%BF%E7%94%A8mixin%E7%9A%84%E5%B0%8F%E6%8A%80%E5%B7%A7/#import导入的路径问题)
- `sass`:可以使用相对路径，绝对路径好像不可以，我尝试了很多次，依旧不行，不知道是不是我尝试的有问题，请知道的前辈告诉我。语法没有`less`的小括号，如下：
``` sass
@import "../../furnace/sass/_base";
```

### 使用`mixin`
- `less`:只能放在选择器内，不能放在外面，以至于我只能这样定义一个动画,而不能使用公共mixin定义动画
``` less
.blink {
  .animation(blink 1.8s infinite);
}
@-webkit-keyframes blink {.keyframes-opacity(10,0);}
@-moz-keyframes blink {.keyframes-opacity(10,0);}
@-o-keyframes blink {.keyframes-opacity(10,0);}
@keyframes blink {.keyframes-opacity(10,0);}
```
- `sass`:可以放在外面，然后代码就变成了这样：
``` sass
.blink {
  @include animation(blink 1.8s infinite);
}
@include keyframes-opacity(blink);
```
是不是简练了很多？

### 内部函数
- `less`:自定义函数比较多，很方便
- `sass`:官方自己封装的都是基本的，比较少，如三角操作函数就没有，所以需要用sass扩展库:[compass](http://compass-style.org/)、[sassCore](http://www.w3cplus.com/sasscore/index.html)

### 编译
#### grunt插件编译
很多人选择用`less`是因为用`sass`是基于`ruby`的,所以选择了`less`,我在使用的过程中用了这样两个插件，都是`grunt`的，`gulp`当然也有。下面我的两个插件：

- [grunt-contrib-less](https://github.com/gruntjs/grunt-contrib-less)
- [grunt-sass](https://github.com/sindresorhus/grunt-sass)

>此处不使用grunt官方团队的[grunt-contrib-sass](https://github.com/gruntjs/grunt-contrib-sass),因为它需要ruby环境的支持

使用`grunt-sass`,就不需要安装ruby环境了，因为它是用[node-sass](https://github.com/sass/node-sass)编译的,只需要用`npm`安装了`node-sass`就可以编译了。这是我的`Gruntfile.js`:
``` js
grunt.initConfig({
    sass: {
        dist:{
          options: {
              sourceMap: true,
              outputStyle:"expanded"
          },
          dist:{
              files:{
                  'sass/style.css':'sass/style.scss'
              }
          }
        }
    },
    less:{
        dist:{
            options:{
                // paths: ['WebRoot/css']//Directory of input file.
            },
            files:{
                'WebRoot/css/less/tvwall.css':'WebRoot/css/less/tvwall.less'
            }
        }
    },
    watch:{
        css:{
            files:[
                'WebRoot/css/less/tvwall.less',
                'WebRoot/css/sass/tvwall.scss',
            ],
            tasks:['less','sass'],
            options:{
                reload:true
            }
        },
        self:{
            files:['Gruntfile.js'],
            tasks:['watch:css']
        }
    }
});
grunt.loadNpmTasks('grunt-sass');
grunt.loadNpmTasks('grunt-contrib-less');
grunt.loadNpmTasks('grunt-contrib-watch');
grunt.registerTask('default', ['less','sass','watch']);
```
命令行使用：
``` shell
grunt watch
```
#### js编译，方便调试
- `less`是基于JavaScript，所以，是在客户端处理的。官方提供了`less.js`文件，放在html里直接就可以编译，很方便.
- `sass`是基于服务端的，但有牛人创造了[sass.js](https://github.com/medialize/sass.js),主要由：`sass.js`、`sass.work.js`和`sass.sync.js`组成。如果你的浏览器支持h5的[ Web Worker](https://developer.mozilla.org/en/docs/Web/API/Worker),请使用`sass.js`和`sass.work.js`，我这儿就用的这两个文件。如果不支持，就使用`sass.js`和`sass.sync.js`。使用如下：  

**(1)直接在html中使用`sass.js`**   
``` html
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <script src="/js/sass/sass.js"></script>
        <script>
            var sass = new Sass('/js/sass/sass.worker.js');
            sass.destroy();
            var sass = new Sass();
            sass.options({
                style: Sass.style.expanded//这种格式我们比较习惯
            });

            var base = '../../furnace/';
            var directory = '';
            /*因为我的'audio.scss'引入了公共的文件:
             *   @import "../../sass/_base";
             * 所以'_base.scss'文件也必须使用preloadFiles()"注册"文件之后再编译
            */
            var files = [
                'audio/sass/audio.scss',
                'sass/_base.scss'
            ];
            sass.preloadFiles(base, directory, files, function() {
                sass.compileFile('audio/sass/audio.scss',function(result) {
                    var style=document.createElement('style');
                    style.innerHTML=result.text;
                    document.head.appendChild(style);
                });
            });
        </script>
    </head>
    <body>
    </body>
</html>
```
**(2)在对应的模块js中使用**      
我们使用了`sea.js`来模块化，本来官方介绍是简单的`require`之后就可以使用，官方demo:  
``` js
define(function defineSassModule(require) {
  // load Sass.js
  var Sass = require('path/to/sass.js');
  // tell Sass.js where it can find the worker,
  // url is relative to document.URL - i.e. outside of whatever
  // Require or Browserify et al do for you
  Sass.setWorkerUrl('dist/sass.worker.js');
  // initialize a Sass instance
  var sass = new Sass();
  var scss = '$someVar: 123px; .some-selector { width: $someVar; }';
  sass.compile(scss, function(result) {
    console.log(result);
  });
});
```
但是在我的项目里并不成功,提示`require`返回的对象是`underfined`,注意到了`sass.js`里面的这段代码：
``` js
(function (root, factory) {
    'use strict';
    if (typeof define === 'function' && define.amd) {
      define([], factory);
    } else if (typeof exports === 'object') {
      module.exports = factory();
    } else {
      /*走到了这个逻辑里，可能是因为用的是sea.js而非require.js*/
      root.Sass = factory();
    }
  }(this,function(){...})
)
```
所以，`require`之后的对象被绑定到了window上，于是，代码修改为：
``` js
define(function(require, exports, module) {
    require('/js/sass/sass.js');
    Sass.setWorkerUrl(suninfo.getRootPath()+'js/sass/sass.worker.js');
    var sass=new Sass();
    sass.options({
        style: Sass.style.expanded
    });

    var base = '../../furnace/';
    var directory = '';
    var files = [
        'audio/sass/audio.scss',
        'sass/_base.scss',
        'sass/_variables.scss'
    ];
    sass.preloadFiles(base, directory, files, function() {
        sass.compileFile('audio/sass/audio.scss',function(result) {
            var style=document.createElement('style');
            style.innerHTML=result.text;
            document.head.appendChild(style);
        });
    });
});
```
然后在浏览器中开心的调试`sass`吧...   

{% pullquote tip %}
最终，我还是比较喜欢sass。最后放个我总结的**sass使用规范**和**_base.scss**:
{% endpullquote %}
>- [sass使用规范](https://gist.github.com/jintangWang/15b7175268946b9cef21d94625180ee7#file-sass-md)
- [_base.scss](https://gist.github.com/jintangWang/15b7175268946b9cef21d94625180ee7#file-_base-scss)