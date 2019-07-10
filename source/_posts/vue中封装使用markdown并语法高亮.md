title: vue中封装使用markdown并语法高亮
date: 2017-03-22 09:23:15
tags: 
- vue
- highlight.js
categories: 前端
---
>最近学习Vue2.0，感觉很有意思，给大家分享一个在`vue`项目中写`markdown`的方法。国际惯例,先附上一些链接。  

- [marked](https://github.com/chjj/marked)：A full-featured markdown parser and compiler, written in JavaScript.
- [highlight.js](https://github.com/isagalaev/highlight.js/):Javascript syntax highlighter
- [vue自定义指令](http://cn.vuejs.org/v2/guide/custom-directive.html)

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
    Vue.directive('marked',{
      //注意，这儿得使用bind钩子函数，因为我们使用此指令主要是为了写文档，
      //文档里不会有变量且一次性生成,而update在自定义指令所在模板变化时就会重新执行，
      //会影响渲染文档的方法，所以不能使用update钩子，也不能使用函数简写
      bind:function(el,binding,vnode){
        el.innerHTML = marked(el.innerText);
      }
    })
}

export default install;
```
### 使用自定义指令:`v-marked`
里面的缩进和空格也是`markdown`语法的一部分  
![vue mark](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/vue_mark.png)  
**结果： **   
![vue mark result](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/vue_mark_result.png)  

**ps:**
代码语法高亮的样式可以有多种选择:  
![highlight style](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/highlight.png)

### `vue`自定义指令相关知识

##### 钩子函数

指令定义函数提供了几个钩子函数（可选）：  

- `bind`: 只调用一次，指令第一次绑定到元素时调用，用这个钩子函数可以定义一个在绑定时执行一次的初始化动作。
- `inserted`: 被绑定元素插入父节点时调用（父节点存在即可调用，不必存在于 document 中）。
- `update`: 被绑定元素所在的模板更新时调用，而不论绑定值是否变化。通过比较更新前后的绑定值，可以忽略不必要的模板更新（详细的钩子函数参数见下）。
- `componentUpdated`: 被绑定元素所在模板完成一次更新周期时调用。
- `unbind`: 只调用一次， 指令与元素解绑时调用。

##### 钩子函数的参数
- **el**: 指令所绑定的元素，可以用来直接操作 `DOM` 。
- **binding**: 一个对象，包含以下属性：
    + **name**: 指令名，不包括 `v-` 前缀。
    + **value**: 指令的绑定值， 例如： `v-my-directive="1 + 1"`, `value` 的值是 2。
    + **oldValue**: 指令绑定的前一个值，仅在 `update` 和 `componentUpdated` 钩子中可用。无论值是否改变都可用。
    + **expression**: 绑定值的字符串形式。 例如 `v-my-directive="1 + 1"` ， expression 的值是 `"1 + 1"`。
    + **arg**: 传给指令的参数。例如 `v-my-directive:foo， arg` 的值是 `"foo"`。
    + **modifiers**: 一个包含修饰符的对象。 例如： `v-my-directive.foo.bar`, 修饰符对象 `modifiers` 的值是 `{ foo: true, bar: true }`。
- **vnode**: `Vue` 编译生成的虚拟节点，查阅 `VNode API` 了解更多详情。
- **oldVnode**: 上一个虚拟节点，仅在 `update` 和 `componentUpdated` 钩子中可用。

##### 函数简写
大多数情况下，我们可能想在 `bind` 和 `update` 钩子上做重复动作，并且不想关心其它的钩子函数。可以这样写:
``` js
//首先bind的时候执行一次，再多次执行update
Vue.directive('color-swatch', function (el, binding) {
  el.style.backgroundColor = binding.value
})
```

>- **[我的demo](https://jintangwang.github.io/hello-vue/dist/#/my)  **  
- **[源代码](https://github.com/jintangWang/hello-vue)**