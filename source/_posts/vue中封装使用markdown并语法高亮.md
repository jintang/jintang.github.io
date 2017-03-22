title: vue中封装使用markdown并语法高亮
date: 2017-03-22 09:23:15
tags: 
- vue
- marked
- highlight.js
categories: 前端
---
>最近学习Vue2.0，感觉很有意思，给大家分享一个在`vue`项目中写`markdown`的方法。国际惯例,先附上一些链接。  

- [marked](https://github.com/chjj/marked)：A full-featured markdown parser and compiler, written in JavaScript.
- [highlight.js](https://github.com/isagalaev/highlight.js/):Javascript syntax highlighter

### 安装依赖包
``` bash
    npm install -S marked
    npm install -S highlight.js
```
### vue中注册自定义指令
`main.js`:
``` javascript
import Vue from 'vue'
import Marked from './common/directive/marked.js'
Vue.use(Marked);
```
**ps:**`Vue.use()`会自动调用参数文件里的`install()`
<!-- more -->
`marked.js`:
``` javascript
import marked from 'marked';
import 'highlight.js/styles/monokai-sublime.css';//这个样式有多种类型可选择


marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: false,
  highlight: function (code) {
    return require('highlight.js').highlightAuto(code).value;
  }
});


let install = function(Vue){
    /* istanbul ignore if */
    if (install.installed) return;
    Vue.directive('marked',function(el,binding,vnode){
        el.innerHTML = marked(el.innerText);
    })
}

export default install;
```
### 使用
里面的缩进和空格也是`markdown`语法的一部分  
![vue mark](http://7xphbb.com1.z0.glb.clouddn.com/vue_mark.png)  
**结果： **   
![vue mark result](http://7xphbb.com1.z0.glb.clouddn.com/vue_mark_result.png)  

**ps:**
代码语法高亮的样式可以有多种选择:  
![highlight style](http://7xphbb.com1.z0.glb.clouddn.com/highlight.png)

>- **[我的demo](https://jintangwang.github.io/hello-vue/dist/#/my)  **  
- **[源代码](https://github.com/jintangWang/hello-vue)**