title: vue中遇到的坑
date: 2017-05-17 10:04:05
tags:
- vue
categories: 前端
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

1. **浅拷贝：**
``` js
    Object.assign({}, obj)
```
2. **深拷贝：** 参考 [这儿](https://smalldata.tech/blog/2018/11/01/copying-objects-in-javascript)
    - **将对象序列化为字符串，然后将其反序列化**
    ``` js
    JSON.parse(JSON.stringify(obj))
    ```
    非常简单，但是有两个常见的错误:
         - 如果属性是不可序列化值类型，结果并不是期盼的值。比如 函数会被忽略， `Date` 类型会被 `JSON.parse()` 解释为字符串
         - 如果有循环引用会报错
         
    `JSON.stringify()`拥有三个参数(参考[官方描述](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify))，第一个错误可以用下面的代码修复：
    ``` js
    JSON.parse(JSON.stringify(json, function(key,val){
            if(typeof val=='function'){
                return val+''//手动将其字符串化
            }
            return val;
        }
    ),function(key,val){
        if(val.indexOf&&val.indexOf('function') !== -1){
            return eval("(function(){return "+val+" })()")
        }
        return val;
    });
    ```
    第二个错误只能望而叹之。
    - **递归拷贝：**
        可以使用`lodash`的`_.cloneDeep(obj)`方法,通过学习这个库，咱们可以简单实现这样的一个方法：
        ``` js
        function cloneDeep(value) {
            if(value instanceof Object) {
                var result;
                if(value.constructor === Object) { // 对象
                    result  = {};
                    for (let i in value) {
                        result[i] = cloneDeep(value[i]);
                    }
                } else if (value.constructor === Array) { // 数组
                    result  = [];
                    value.forEach(function(item, index) {
                        result[index] = cloneDeep(item);
                    });
                } else if (value.constructor === Function) { // 函数
                    // 方式1
                    result = new Function("return " + value.toString())();
                    // 方式2
                    result = function() {
                        return value.apply(this, arguments);
                    }
                } else if (value instanceof Date) { // new Date() 时间对象
                    result = new Date();
                    result.setTime(result.getTime());
                } else { // new String...的instanceof Object也为true，这个直接赋值，
                    result = value;
                }
                return result;
            } else {
                return value;
            }
        }
        ```
        里面对于循环引用没做处理，因为对`lodash`的封装的`Stack`还不是很明白...