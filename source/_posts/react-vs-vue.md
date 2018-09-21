title: react vs vue
date: 2018-09-05 16:14:03
tags:
- react
- react native
- vue
categories: 前端
---
> 先接触了 `vue` ，感觉 `vue` 特别方便，优雅的想让你上瘾。后面接触了 `react native` 开发 App， 过来过去都感觉不适应，再慢慢用过一段日子之后，感觉 `react` 也有自己鲜明的特点，在使用 `react` 的时候，总想着和 `vue` 对比一下。由于自己使用 `react` 主要是在用 `react native`， 所以有些东西可能了解不深，望海涵。通过对比借此加深下理解的。


| Vue        | React   | 补充说明  |
| --------   | :----:  | :----:  |
| Computed、watch | React 不监听数据变化  |    React可以使用 `mobx` 库来实现这些功能，在 vue 官方描述的 [对比其他框架](https://cn.vuejs.org/v2/guide/comparison.html#MobX) 里面有这样一句话： 在有限程度上，React + Mobx 也可以被认为是更繁琐的 Vue     |
| v-model, 这只是通过语法糖定义了一个自定义指令，本质跟 React 一样. 修饰符`.async` 也是一样     | React是单向数据流，只能通过事件触发，然后再setState，React没有自定义指令   |     /    |
| 传统 HTML标签渲染 / jsx render渲染     | jsx   | / |
| Vuex       | Redux  | react 有一个中间件react-redux 可以让我们方便的使用 Redux |
| EventBus 非父子组件通信  | [PubSubJS](https://github.com/mroderick/PubSubJS) 或 [js-signals](http://millermedeiros.github.io/js-signals/) | react-native 中还没用过，没遇到需要的场景  |
| 混入：mixins | class组件不可用，在使用 `createReactClass` 创建 `React` 组件的时候可用 mixins   | 我们可以要把 mixin 的东西写到单独的 js 文件里，通过 import 实现 mixin，这个本来就是锦上添花，不甚重要 |
| slot        | props.chldren   | 自定义组件获取使用时传入的子元素  |
| 自定义指令    | 自己通过事件触发实现类似效果  | 自定义指令可以实现类似于 限制 input 输入格式 等效果 |

还有一些是两者非常类似的，只要会了一个，另一个也就会了：

- 生命周期方法： 虽然名称不同，但使用一样
- ref ： react 有多种使用 ref 的方法， 具体请看 [另外一篇文章](https://jintang.github.io/2018/05/11/react-native%E6%88%91%E4%BB%AC%E5%BA%94%E8%AF%A5%E7%9F%A5%E9%81%93%E7%9A%84/)

<!-- more -->

## React 补充
### JSX
本质上来讲， `JSX` 只是为 `React.createElement(component, props, ...children)` 方法提供的语法糖， 所以文件中必须引入 `React` —— `import 'React' from 'react'`
- `JSX` 中使用的标签，小写代表内置组件，大写代表自定义组件。如 `<div></div>` 与 `<Hello>` 分别是内置组件和自定义组件
- `JSX` 可以直接使用的判断运算符： `&&` 、 ` ? : ` ；可以直接使用的循环遍历方法： `map` ，因为 `map` 会返回一个新数组
    
*注意：* 循环渲染时，数组元素中使用的 `key` 在其兄弟之间应该是独一无二的。然而，它们不需要是全局唯一的。当我们生成两个不同的数组时，我们可以使用相同的键。 另外 `key` 尽量不要使用 index 或其他随机数，如果数组重排的话 React 的差异比较算法会认为全部需要重新渲染。
 
### props.children
``` js
render() {
    return (
        <FancyBorder color="blue">
            <h1 className="Dialog-title">
                Welcome
            </h1>
        </FancyBorder>
    )
}
```
如上我们定义了一个 `FancyBorder` 自定义组件， 那么它内部的 `props.children` 就是它的子元素，即 `<h1>` 包裹的那一段。

### 构造函数是唯一能够初始化 this.state 的地方。而其他地方更新 `state` 只能用 `setState(updater, [callback])` 

*注意：* `setState()` 认为是一次请求而不是一次立即执行更新组件的命令。为了更为可观的性能， `React` 可能会推迟它，稍后会一次性更新这些组件。 `React` 不会保证在 `setState` 之后，能够立刻拿到改变的结果。

第一个参数 updater 如下:
- 普通对象，最常见，如： `this.setState({name: '小明'})`
- updater函数，因为 this.state 可能是异步更新的，如果之后的状态依赖于之前的状态，此时就需要这种方式实现。
    ``` js
    /* Wrong */
    this.setState({
        counter: this.state.counter + this.props.increment,
    });
    /* Correct */
    this.setState((prevState, props) => ({
        counter: prevState.counter + props.increment
    }));
    ```
第二个参数在 `setState` 执行完成同时组件被重渲之后执行。通常，对于这类逻辑，我们推荐使用 `componentDidUpdate`

### 事件绑定 this : `JSX` 回调函数中的 this，类的方法默认是不会绑定 this 的
``` js
funciton handleClick1(param, e) {
    // ...
}

handleClick2 = () => {
    // ...
}

render() {
    return (
        <div>
            /* 1. 利用 bind, 此时 e 会是参数中的最后一个 */
            <button onClick={this.handleClick1.bind(this， param)}>方法1</button>
            /* 2. 利用 箭头函数，需将 handleClick 定义为箭头函数格式 */
            <button onClick={this.handleClick2}>方法2</button>
        </div>
    )
}
```
*注意：* 事件回调事件不能通过 `reture false` 来阻止默认行为，必须得通过 `e.preventDefault()`