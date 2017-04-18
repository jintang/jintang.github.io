title: vue自定义树组件s-tree
date: 2017-04-18 13:14:14
tags: 
- vue
- tree
- 自定义组件
categories: vue
---
>本组件是基于`Vue2`的自定义tree组件，参考了[weibangtuo](https://github.com/weibangtuo/vue-tree)的实现，实现了以下功能:    

- 节点单击钩子函数与选中效果
- 树节点默认的增删改

### 使用
#### 代码
**1.**基础使用：给`s-tree`组件传递`tree-data`即可,`treeData`中单个节点的数据结构:
``` js
{
  name: 'Node Name',
  title: 'Node Tag title attr',
  isParent: true, // Requested for parent node
  isOpen: false, //  Control node to fold or unfold
  icon: 'fa fa-folder', // Icon class name
  openedIcon: 'fa fa-folder-open', // 节点打开时的icon样式
  closedIcon: 'fa fa-folder', // 节点折叠时的icon样式
  children: [], 
  buttons: [ 
    {
      title: 'icon button tag title attr', //[opt]
      icon: 'fa fa-edit',
      click: function (node) { 
          // 自定义事件
      }
    }
  ],
}
```
本例所使用的[json数据](https://github.com/jintangWang/hello-vue/blob/master/src/components/my/tree/tree.json)  
**2.**节点单击事件：监听`node-click`,此方法接受了`node`参数(点击的节点对象)  
**3.**节点后的按钮事件: `buttons`下`click`的值可以是自定义方法，也可以默认方法，默认有`addNode`、`delNode`、`editNode`字符串
``` html
<template>
    <div class="tree-demo">
        <s-tree :tree-data = "treeData" @node-click="nodeClick"></s-tree>
    </div>
</template>
<script>
import sTree from "src/common/component/tree";
let treeData =  require("./tree.json");
//自定义事件
treeData[0].children[1].buttons[0].click=function(node){
    alert('自定义添加事件');
}
export default {
    data(){
        return {
            treeData: treeData
        }
    },
    components:{
        sTree
    },
    methods:{
        nodeClick(node){
            console.log(node);
        }
    }
}
</script>

```
<!-- more -->
#### 效果图
![s-tree](http://7xphbb.com1.z0.glb.clouddn.com/vue_tree.png)
### 组件原理
下面是一部分需要注意的地方讲解，其他的请查看底部的源代码链接
#### 使用递归组件
因为不确定树有多少层，所以必须得使用递归组件，递归组件最重要的是什么时候跳出递归,本例使用了如下条件：  
*tree.vue*
``` html
<template>
    <ul class="s-tree">
        <s-tree-item v-for="node in innerTreeData" :key="node.name" 
            :node="node">
            <s-tree v-if="node.isOpen && node.children" :tree-data="node.children"></s-tree>
        </s-tree-item>
    </ul>
</template>
```
#### node-click事件实现
由于组件是递归的，无法直接`$emit`事件给外部钩子函数，所以循环获取到了最外层的`s-tree`vue实例，通过此实例`$emit`事件暴漏给外部钩子函数  
*tree-item.vue*:
``` js
export default {
    methods:{
        nodeClick(){
            let _this = this;
            while(isNotTree(_this.$parent)){
                _this = _this.$parent;
            }
            _this.$emit('node-click',this.node);
        }
    }
}
function isNotTree(vm){
    let classStr = vm.$el.className;
    if(classStr.indexOf('s-tree')!==-1){
        return true;
    }
    return false;
}

```
#### 单击节点选中效果实现
 `s-tree-item`如果是单个循环的组件，不是递归的，那么直接在外层的`s-tree`创建变量储存选中的值，在`s-tree-item`内部与该值判断来实现选中效果就可以了，但是递归组件中`s-tree`也可能生成了多个，所以这个值不能储存在`s-tree`里，只能储存在一个单例里，这儿我使用了`事件中心`，代码如下:   
*tree-item.vue*:
``` html
<template>
    <li class="s-tree-item" @click.stop="nodeClick">
        <i :class="[statusIconClass]"></i>
        <a :class="{'is-active': activeValue === node.name}">
            <i  :class="[node.icon,nodeIconClass]"></i>
            {{node.name}}
            <i v-if="node.buttons" v-for="button in node.buttons" class="iButton" 
                :class="[button.icon]" 
                :title="button.title"></i>
        </a>
        <slot></slot>
    </li>
</template>
<script>
    import Bus from './bus.vue';
    export default {
        computed:{
            activeValue(){
                return Bus.activeValue;
            }
        },
        methods:{
            nodeClick(){
                Bus.$emit('active',this.node.name);
            }
        }
    }
</script>
```
*bus.vue*:
``` html
 <script>
    import Vue from 'vue';
    export default new Vue({
        name: 'bus',
        data(){
            return {
                activeValue: ''
            }
        },
        created(){
            this.$on('active',this.active);
        },
        methods:{
            active(value){
                this.activeValue = value;
            }
        }
    });
 </script>
```

### 结语
- [源代码](https://github.com/jintangWang/hello-vue/tree/master/src/common/component/tree)
- [实例](https://jintangwang.github.io/hello-vue/#/my/tree-demo)