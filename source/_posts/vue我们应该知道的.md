title: vue我们应该知道的
date: 2018-05-11 09:42:20
tags: 
- vue
categories: 前端
---
### route开启h5模式
路由里面加一个 `mode: 'history'`  
**作用:** 实现页面后退时，还原滚动位置

### vuex模块话
*默认：* 内部的 `action` 、 `mutation` 和 `getter` 是注册在全局命名空间的。不包括 `state`  

所以，当 `commit` 一个子模块的 `mutation` 时，若还有其他子模块有相同的 `mutation` 时,
这两者都会触发。**bug:**  再次发现中，下一步的扫描时间初始化不是0，而是先变成了上一步的扫描时间，然后才变成0。因为点击下一步的时候触发了上一步的同名 `mutation`

**解决方案：** 给子模块添加 `namespaced: true` 让子模块成为命名空间模块，这样可以封装单独作用域

此时要 `commit` 一个子模块的 `mutation` 时，就需要`this.$store.commit('子模块名/事件名')`

**tip:** 不论是不是命名空间模块， `state` 的获取都是这样的： `this.$store.state.子模块名.变量名`
或者利用 `mapState` :
``` js
...mapState('子模块名', [
    '变量名'
])
```
<!-- more -->
### 引用类型的复制可以用 lodash 
``` js
_.clone(obj)
_.cloneDeep(obj)
```

### unicode字符串(如\u0000)页面显示乱码
使用 `v-html` 代替 `{% raw %}{{}}{% endraw %}` 、`v-text` ,这样才可以显示不转义的字符串

### 使用debounce节流函数
``` js
import {debounce} from 'lodash';

methods: {
    checkChange: debounce(function() {
        // do something
    }, 500),
}
```
### vue-cli分析工具
`npm run build --report`

### vue的循环v-for如何一次循环2条项目？
``` html
<ul v-for="i in (items.length / 2)">
  <li>{{items[(i - 1) * 2].name}}</li>
  <li>{{items[(i - 1) * 2 + 1].name}}</li>
</ul>
```
需要处理奇数问题