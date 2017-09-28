title: vue中遇到的坑
date: 2017-05-17 10:04:05
tags:
- vue
categories: vue
---
>仅以此记录 vue 中遇到的坑

### 组件的复用问题
>`Vue`的虚拟DOM中，`Vue`会使用一种最大限度减少动态元素并且尽可能的尝试修复/再利用相同类型元素的算法。  

*然后我遇到了这样的bug：*同事做了一个`scrollbar`的组件,我用在了`steps`组件中，用了多个。在点击**下一步**的时候当前`step`下的组件会销毁，我特意加了`v-if`，下一个`step`下的组件会创建，问题来了...上一步的`scrollbar`组件影响到了当前创建下的`scrollbar`组件。

*原因：*`Vue`的算法会尝试复用组件  

**解决方案：**使用`key`，它会基于`key`的变化重新排列元素顺序，并且会移除`key`不存在的元素。加了`key`之后，就会重新渲染，而不是复用了。    
代码：
``` html
<div class="stepContent" key="1" v-else-if="currentStep == 1">
    <s-scrollbar wrap-class="scrollheight">
      ...
    </s-scrollbar>
</div>
<div class="stepContent" key="2" v-else-if="currentStep == 2">
    <s-scrollbar wrap-class="scrollheight">
      ...
    </s-scrollbar>
</div>
```

*结语：*我想大多数玩家和我一样，都是在`v-for`里用到了`key`，我虽然用到了，但是没有真正理解它，所以才会碰到这个bug不知道原因，还傻乎乎的去看组件的源码，浪费了很长时间。理解最值得重视...

最后附上：[key的官方介绍](https://cn.vuejs.org/v2/api/#key)
<!-- more -->

### 数据的拷贝和动态组件产生的bug
>自己用`element`的`input`和`tree`合成了一个`inputTree`组件

想使用动态组件来生成不同的表单，代码如下：
``` vue
<component :is="getDynamicComp(item)" v-for="(item,index) in list" :key="index"></component>
export default {
    data() {
        return {
            list: [
                {
                    htmlType: 'udf_char_single_line',
                    value: ''
                },{
                    htmlType: 'udf_char_list',
                    value: '',
                    listvalues: [
                        {value：1},
                        {value：2}
                    ]
                }

            ]
        }
    },
    methods: {
        getDynamicComp(item) {
            let dynamicComp = {
              data() {
                return {
                  item: item
                }
              },
              template: ''
            };
            if (item.htmlType === 'udf_char_single_line') {
              dynamicComp.template = `<s-input v-model="${item.value}"></s-input>`;
            } else if (item.htmlType === 'udf_char_list') {
              dynamicComp.template = '<s-select v-model="item.value">' +
                  '<s-option v-for="(option,index) in item.listvalues" :key="index" :value="option.value"></s-option>' +
                '</s-select>';
            }
            return dynamicComp;
        },
    }
}
```
**结果：**`input`和`select`都生成了，但是改变不了数据  
**原因:**改变`input`和`select`的值时，`list`数组会变化，这个`list`其实还在我另外一个组件中使用，另外一个组件监听了这个`list`的变化,由此`getDynamicComp()`重新计算，然后重新生成动态组件，动态组件里面的`input`、`select`又恢复到了初始渲染状态,所以改变数据无效

**最后:**提供对象浅拷贝和深拷贝的方法  

- 浅拷贝：
```
    Object.assign()
```
