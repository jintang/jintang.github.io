title: 各种环境下使用es6
date: 2017-09-28 14:07:23
tags: 
- es6
- babel
categories: 前端
---
>不讲为什么使用es6，只讲es6如何在各种环境下使用。目前浏览器...环境都不支持es6，所以我们需要[babel](http://babeljs.cn/)

## 浏览器中使用
``` html
<script src="node_modules/babel-core/browser.js"></script>
<script type="text/babel"> // 注意type
class Test {
  test() {
    console.log("test");
  }
}

var test = new Test;
test.test(); // "test"
</script>
```
**Note:**`Babel`可以用于浏览器环境,但是从`Babel 6.0`开始，不再直接提供浏览器版本，而是要用构建工具构建出来。所以，我们只是做简单的`html`时，又不想使用构建工具，可以通过`安装5.x版本的babel-core模块获取`。
``` shell
npm install babel-core@5
```
<!-- more -->
## 命令行转换使用
我们创建了一个用`es6`写的js文件，想要运行，但是不想使用构建工具,可以使用`babel`提供的命令行工具。  
1. 安装命令行工具:
    ``` shell
    npm install babel-cli -g // 全局安装
    ```
2. 配置编译规则
    - 添加`babel`用来转换的依赖包
    ``` shell
    # ES2015转码规则
    $ npm install --save-dev babel-preset-es2015
    # ES7不同阶段语法提案的转码规则（共有4个阶段），选装一个
    $ npm install --save-dev babel-preset-stage-0
    $ npm install --save-dev babel-preset-stage-1
    $ npm install --save-dev babel-preset-stage-2
    $ npm install --save-dev babel-preset-stage-3
    ```
    - 在根目录下创建`.babelrc`文件并添加配置:  
    ``` js
    // 只是为了演示添加的简单配置
    {
      "presets": [
        "es2015",
        "stage-2"
      ],
      "plugins": []
    }
    ```
3. 使用：  
    放个[官方链接](http://babeljs.cn/docs/usage/cli/)，懒得写了。  
    因为我不想让`babel`编译了之后重新生成个文件，所以我一般用`babel-node`命令测试：
    ``` shell
    babel-node 文件名
    ```
    即可在命令行看到结果。

## 构建工具中使用
...未完待续