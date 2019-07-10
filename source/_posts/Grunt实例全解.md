title: Grunt实例全解
date: 2016-08-29 17:02:08
tags: 
- Grunt
categories: 杂说
---
> 早闻自动化部署大名，可惜我性子懒散，至今才了解了解。官网看了是一头雾水，直到跟着[叶小钗](http://www.cnblogs.com/yexiaochai/p/3603389.html)一笔一画，才了解这个`Grunt`是怎么一回事，回头再看[官方案例](http://www.gruntjs.net/sample-gruntfile)。对它也再无神秘的面纱，纸上得来终觉浅，绝知此事要躬行。

### 安装grunt的环境
首先需要`node`环境，用`npm`安装`grunt`
``` shell
npm install -g grunt-cli
```

### 基础实例
#### 新建一个空文件夹，并添加两个文件：`package.json`与`Gruntfile.js`
> 这两个文件要在项目的根目录下

![新建的grunt项目](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/grunt/grunt1.png)

`package.json`中添加如下代码，`Gruntfile.js`中暂且不管：
``` javascript
{
  "name": "my-project-name",
  "version": "0.1.0",
  "devDependencies": {
    "grunt": "~0.4.5",
    "grunt-contrib-jshint": "~0.10.0",
    "grunt-contrib-nodeunit": "~0.4.1",
    "grunt-contrib-uglify": "~0.5.0"
   }
}
```
调用npm命令安装：
``` shell
npm install
```
结果如图：
![npm install后结果图](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/grunt/grunt2.png)
<!-- more -->
#### 创建测试的用例
如图：

![测试用例](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/grunt/grunt3.png)

里面的代码也是随便写的，只用来演示,为了对比效果，将代码粘贴如下：

`test.js`：
``` javascript
function test1(){
    console.log('test1');
}
function test2(){
    console.log('test2');
}
test1();
test2();
for(var i=0;i<3;i++){
    cosnole.log(i);
}
```
`event.js`:
``` javascript
function addEvents1(){
    console.log("添加event1");
}
function addEvents2(){
    console.log("添加event2");
}
addEvents1();
var x=10,
    y=10;
console.log(x*y);
```
`require.js`是从requirejs官网下载的
#### 编辑`Gruntfile.js`
下面是对`grunt`插件`uglify`的简单实例
``` javascript
module.exports = function (grunt) {
  // 项目配置
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {//任务，名称是插件名
      build: {//目标：可以多个
        src: ['src/test.js','src/event.js'],
        dest: 'dest/uglifyResult.min.js'
      }
    }
  });
  // 加载提供"uglify"任务的插件
  grunt.loadNpmTasks('grunt-contrib-uglify');
  // 默认任务
  grunt.registerTask('default', ['uglify']);
}
```
#### 运行`grunt`
``` shell
grunt
```
结果如图：

![uglify的结果](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/grunt/grunt4.png)

查看`uglifyResult.min.js`的内容，已经将`test.js`和`event.js`的内容压缩到一起了，这儿就不放图了，有兴趣的自己试试。

经过上面的基础实例，想必已经对`grunt`的作用和工作原理有所理解,只需写个配置文件，运行下grunt命令，就可以压缩文件了，果然方便。上面只是对`grunt`插件`uglify`的演示，其他插件的用法，我们继续。

### Grunt相关配置
从上面我们看到了`grunt`有种种插件，各种插件的用法也不尽相同，除此之外，`grunt`还有一些约定，使得每个`grunt`插件都可以配置公共属性：
#### options
#### files
>小技巧: 

> - `src`匹配所有的`.styl`文件：设置`src: '*.styl'`是匹配不到的，因为`*`不匹配`/`。`**`可以匹配`/`，且一个路径中只可以出现一个`**`，所以可以设置为：`src: '**/*.styl'`
> - 生成多个`dest`文件：`dest`只能是一个字符串，表示单个文件，设置为['result/*.css*']会报错，只能用动态创建文件对象：
``` js
files: [
    {
        expand: true,
        src: ['*.styl'],
        cwd: 'css/stylus/src/',
        dest: 'css/stylus/result/',
        ext: '.css'
    }
]
```


### 更多实例
#### 实例1:单独使用concat插件
##### `package.json`不变，`Gruntfile.js`如下：
``` javascript
grunt.initConfig({
    pkg:grunt.file.readJSON('package.json'),
    concat:{
      options:{
        separator:';'//文件连接处的分隔符
      },
      mytarget:{
        src:'src/*.js',
        dest:'dest/concatResult.js'
      }
    }
  })
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.registerTask('default', ['concat']);
```
##### 运行`grunt`
``` shell
grunt
```
结果如图：

![concat结果图](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/grunt/grunt5.png)

`concatResult.js`内容