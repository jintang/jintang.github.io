title: js发布订阅者模式简单实现
date: 2019-02-11 18:00:07
tags: 
- javascript
categories: 前端
---
> 之前在对比 `react` 和 `vue` 的时候，发现 `vue` 有 `EventBus` 处理非父子组件通信， 而 `react` 推荐使用 [PubSub.js](https://github.com/mroderick/PubSubJS) 实现。这种发布订阅者模式应用广泛，`vue` 根据 `Object.defineProperty` 实现双向绑定也是一种发布订阅者模式。下面是根据 [PubSub.js](https://github.com/mroderick/PubSubJS) 简化后的版本。

[简化PubSub](https://gist.github.com/jintangWang/35d96dc2491a45a9a5a674305dc374cf)

[测试demo](https://jsfiddle.net/jintang/xuk9Lemj/), 查看 log 即可看到效果
