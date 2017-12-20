title: vue静态资源放在src/assets与static目录下的区别
date: 2017-11-03 09:22:02
tags: 
- vue
- webpack
categories: vue
---
> - [官方链接](http://vuejs-templates.github.io/webpack/static.html)
> - [翻译链接](https://segmentfault.com/q/1010000009842688)

## 官方解释  
### Assets
为了回答这个问题，我们首先需要了解Webpack如何处理静态资产。在 `*.vue `组件中，所有模板和CSS都会被 `vue-html-loader` 及 `css-loader` 解析，并查找资源URL。例如，在 `<img src="./logo.png">
和 background: url(./logo.png)` 中，`"./logo.png" `是相对的资源路径，将由**Webpack**解析为模块依赖。

因为 `logo.png` 不是 JavaScript，当被视为模块依赖时，需要使用 `url-loader` 和 `file-loader`处理它。vue-cli 的 webpack 脚手架已经配置了这些 loader，因此可以使用相对/模块路径。

由于这些资源可能在构建过程中被内联/复制/重命名，所以它们基本上是源代码的一部分。这就是为什么建议将Webpack 处理的静态资源放在 `/src` 目录中和其它源文件放一起的原因。事实上，甚至不必把它们全部放在 `/src/assets`：可以用`模块/组件`的组织方式来使用它们。例如，可以在每个放置组件的目录中存放静态资源。
<!-- more -->
### Static 
相比之下，`static/` 目录下的文件并不会被 Webpack 处理：它们会直接被复制到最终目录（默认是`dist/static`）下。必须使用绝对路径引用这些文件，这是通过在 `config.js` 文件中的 `build.assetsPublicPath` 和 `build.assetsSubDirectory` 连接来确定的。

任何放在 `static/` 中文件需要以绝对路径的形式引用：`/static/[filename]`。如果更改 `assetSubDirectory` 的值为 `assets`，那么路径需改为 `/assets/[filename]`。

## 使用区别
``` html
<template>
   <img :src="filterIcon(item.pollingState)" alt="" class="pollingIcon"> 
</template>
<script>
    export default {
        methods: {
            filterIcon(val) {
                let commonUrl = '../../../../static/images/assetpolling/';
                if (val === 1) {
                  return commonUrl + 'pollingSuccess.png';
                } else {
                  return commonUrl + 'pollingLoading.gif';
                }
              }
        }
    }
</script>
```
如果`src`的值是一个变量，放在`staic`下能访问到图片，放在`assets`下访问不到。如果是一个字符串常量，`static`和`assets`下都可以访问到。  

**分析：**官方说，在 `*.vue `组件中，所有模板和CSS都会被 `vue-html-loader` 及 `css-loader` 解析，并查找资源URL。所以对应的资源如果是个字符串常量，在**编译期**就已经被解析为`Base64`与代码融合为一体。而如果`src`对应的是个变量，只有在**运行期**才会被解析，这时候就访问不到`assets`目录下的资源了。  

**结论:**当资源对应的是变量时，资源放在`static`下。第三方的类库的资源也放在`static`下。其他时候个人感觉相同。

*tip: 如果有不对的地方请留言*