title: vue动态添加组件
date: 2018-03-27 17:24:21
tags: 
- vue
categories: 前端
---
> 大多数时候，我们都用单文件.vue文件来实现功能。比如添加一个dialog，代码如下：

`hello.vue`
``` html
<template>
    <div>
        <button @click="showDialog">显示一个弹框</button>
        <dialog v-if="dialogFlag"></dialog>
    </div>
</template>
<script>
    import Dialog from './Dialog.vue';
    export default {
        data() {
            return {
                dialogFlag: false
            }
        },
        methods: {
            showDialog() {
                this.dialogFlag = true
            }
        },
        components: { Dialog }
    }
</script>
```
点击按钮即可显示弹框。很简单明了，功能划分也清晰，表示很开心。下面列出动态创建弹框的代码，可以跟上面的比较一下有啥优缺点，在不同的情景下选用不同的方案：
<!-- more -->
`hello.vue`
``` html
<template>
    <div>
        <button @click="showDialog">显示一个弹框</button>
        
    </div>
</template>
<script>
    import Dialog from './Dialog.vue';
    export default {
        data() {
            return {
                dialogComp: null
            }
        },
        methods: {
            showDialog() {
                let dialogClass = Vue.extend(Dialog);
                this.dialogComp = new dialogClass().$mount()
                document.body.appendChild(this.vm.$el)
                this.vm.dialogFlag = true
            }
        },
        components: { Dialog }
    }
</script>
```
下面做一些解析：

- `extend()`: 
    - 参数是一个包含组件选项的对象，此处 `Dialog` 是 `import` 的一个单文件组件，其值为：
        ``` js
        {
            data() {
                return {...}
            },
            methods: {...},
            ...
        }
        ```
        引申一下，我们的单文件组件通过`import`后解析为一个`js`对象，在添加到`components`里后才可以按组件使用，内部机制请原谅我没深究...
    - 返回值： 返回一个"子类"，通过`console`看到结构如下：
        ``` js
        VueComponent(options) {
            this._init(options);
        }
        ```
- `$mount([elementOrSelector])`: 通过`new`一个"子类"创建了一个**未挂载**的 `vue` 组件，`$mount()`用来挂载组件到页面，如果没有提供 elementOrSelector 参数，模板将被渲染为文档之外的的元素，并且你必须使用原生 `DOM API` 把它插入文档中。如上面的 `appendChild()` 。返回值是挂载后的 `vue`组件。

**总结：** 各有妙用,嘿嘿