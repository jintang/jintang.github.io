title: debounce与throttle
date: 2017-12-23 14:31:00
tags: 
- javascript
categories: 前端
---
- [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
- [官方文档](https://lodash.com/docs/4.17.4#debounce)

>在`lodash`的方法里，有两个比较有趣的方法：`debounce`与`throttle`，这两个方法是用来限制连续事件的触发频率的。具体的使用请查看[官方文档](https://lodash.com/docs/4.17.4#debounce)。

## debounce: 防抖
``` js
_.debounce(func, [wait=0], [options={
    leading: false,
    maxWait: Number,
    trailing: true
}])
```
**作用：**连续触发的事件，如果一直在触发，没有中途暂停且暂停时间超过`wait`,那么这些事件会合并为一次，直到暂停时间超过`wait`时执行。然后判断下一轮...直到事件最后一次触发。  
**使用：**  
`debounce()`接受一些配置参数，返回一个 *new debounced function*，这个对象拥有`cancel`、`flush`方法，这两个方法都不咋用，就看看配置参数就行了。
默认的效果图：
![debounce默认效果图](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/debounce.webp)
使用`leading`属性的效果图：
![debounce使用leading属性的效果图](https://tang-blog-1257996120.cos-website.ap-chengdu.myqcloud.com/debounce-leading.webp)
所以，当设置`leading:true, trailing: false`时会在`wait`时间段的开始触发合并后的事件。

<!-- more -->

*注意：*`leading: true,trailing: true`时同默认情况  
自己尝试一下,鼠标在*trigger area*上不停的动:
<div style="min-width:900px;transform: translateX(-50%);margin-left: 50%;margin-bottom: -85px">
<p data-height="360" data-theme-id="0" data-slug-hash="GZWqNV" data-default-tab="result" data-user="dcorb" data-embed-version="2" data-pen-title="Debounce. Leading" class="codepen">See the Pen <a href="https://codepen.io/dcorb/pen/GZWqNV/">Debounce. Leading</a> by Corbacho (<a href="https://codepen.io/dcorb">@dcorb</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</div>

还有一个`maxWait`属性，请查看**区别**这一部分。
*注意：*
``` js
// WRONG
$(window).on('scroll', function() {
   _.debounce(doSomething, 300); 
});

// RIGHT
$(window).on('scroll', _.debounce(doSomething, 200));
```
**使用场景：**  
- `scroll`、`resize`、`输入验证`这种连续触发的事件，触发时运行某些代码，大多数时候你可能不需要每次事件都要运行这些代码。比如`input`输入时验证
- 有个新增弹框，为了防止快速点击两次确定按钮提交两次接口，可以使用`debounce`

## throttle：节流
``` js
_.throttle(func, [wait=0], [options={
    leading: true,
    trailing: true
}])
```
**作用：**连续触发的事件，如果一直在触发，不论有没有中途暂停,`wait`时间段里的事件会被合并为一次。  
**使用：**  
参数少了个`maxWait`，其他的不论是参数还是返回值和`debounce`都一样。
自己尝试一下，无限滚动：

<div style="min-width:900px;transform: translateX(-50%);margin-left: 50%;margin-bottom: -85px;">
<p data-height="500" data-theme-id="0" data-slug-hash="eJLMxa" data-default-tab="result" data-user="dcorb" data-embed-version="2" data-pen-title="Infinite scrolling throttled" class="codepen">See the Pen <a href="https://codepen.io/dcorb/pen/eJLMxa/">Infinite scrolling throttled</a> by Corbacho (<a href="https://codepen.io/dcorb">@dcorb</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
</div>

**使用场景：**
- `scroll`无限滚动翻页，此时不能用`debounce`，因为一直连续触发，只要你没有中间暂停时间超过`wait`，那你滚动的那么多事件都会合并为一次。此时用`throttle`,连续触发的事件在每`wait`事件内触发的多次会合并为一次，还是可以连续触发，只不过频率降低了

## 区别
这两个方法非常相似，都降低了触发频率，只有一点细微的差别：  
`throttle`方法其实是加了`maxWait`选项的`debounce`方法，`lodash`的源码中就可以看到。
``` js
function throttle(func, wait, options) {
  var leading = true,
      trailing = true;

  if (typeof func != 'function') {
    throw new TypeError(FUNC_ERROR_TEXT);
  }
  if (isObject(options)) {
    leading = 'leading' in options ? !!options.leading : leading;
    trailing = 'trailing' in options ? !!options.trailing : trailing;
  }
  return debounce(func, wait, {
    'leading': leading,
    'maxWait': wait,
    'trailing': trailing
  });
}
```
**结语：**
大神David Corbacho说建议直接使用`lodash`或`underscore`的这两个方法。这里放下源码的地址：[debounce](https://github.com/lodash/lodash/blob/master/debounce.js),利用的是`setTimeout`方法实现这种效果。
