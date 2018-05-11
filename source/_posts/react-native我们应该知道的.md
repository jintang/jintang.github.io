title: react-native我们应该知道的
date: 2018-05-11 09:16:20
tags:
- react-native
categories: react-native
---
> 记录下自己遇到的...

### react-native 须知
#### `React`的每个组件里，必须`import React`
``` js
import React from 'react';
```
因为组件内部隐式的使用了`React`，比如`jsx`语法等

#### `require`只能使用静态字符串，因为它是在编译期执行，而不是运行期。js执行过程:
![react-native-run](http://7xphbb.com1.z0.glb.clouddn.com/react-native-run.png)
`React Native`从0.5.0版本开始已经内置`Babel`转换器

#### 开启自动刷新：真机或者模拟器中`Enable Live Reload` 和`Enable Hot Reloading`同时打开，下面的情况需要重新编译:
- 增加了新的资源(比如给 `iOS` 的Images.xcassets或是 `Andorid` 的res/drawable文件夹添加了图片)
- 更改了任何的原生代码（objective-c/swift/java）
<!-- more -->

#### 自定义组件
- 文件名可以小写，但是导出的对象必须大写开头
- 必须正确导出( `module.exports` 或 `export default` )

#### 组件的render()里的组件标签上调用类中的非静态方法
``` js
class Toggle extends React.Component {
  render() {
    return (
        // 方法1. 使用bind()，此时方法的定义用es5的这种语法
        <Text onPress={this.handleClick1.bind(this)}>点击</Text>
        // 方法2. 使用es2015的语法定义方法
        <Text onPress={this.handleClick2}>点击</Text>
    )
  }
  handleClick1() {
    // do something1
  }
  handleClick2 = () => {
    // do something2...  
  }
}
```
#### 遍历渲染组件：
`jsx` 中只能写表达式，不能写多行语句,所以最佳循环写法是使用 `map` 函数
``` js
<View>
{
    arr.map((item, index) => <View key={item.id || index} />);
}
</View>
// 或----------------------------------
<View>
{
    arr.map((index, index) => {
        return (<View key={index.id || index} />);
    })
}
</View>
```

#### 同时启动两个项目:需要同时启动两个packger与模拟器
1. 同时启动两个`packger`:
``` shell
react-native start --port 端口号
```
2. 启动两个模拟器之后
``` shell
react-native run-android --deviceId [device_id]
# device_id可以通过下面的命令进行查看：
# adb devices
```
3. 如果是两个模拟器，和电脑在同一个wifi下，那分别在 **dev-setting** => **Debug server host & port for device** 下添加：**电脑ip:port** 。设置之后按两次R重新加载 `bundle` 即可。  
**注意：两个模拟器都必须指定端口,即使一个`packger`是默认端口**

#### callback ref的含义:
``` js
class AutoFocusTextInput extends React.Component {
    componentDidMount() {
    this.textInput.focusTextInput();
    }

    render() {
        return (
            <CustomTextInput
            // input是CustomTextInput的实例
            ref={(input) => { this.textInput = input; }} />
        );
    }
}
```
上面代码的效果是：`CustomTextInput`在`mounted`之后立即执行`focusTextInput()`自动获取焦点  
*注意:* `callback ref` 只能用于 `class` 的 `component` ，不能用于 `function ref`
  
### react-native 常见错误
#### Native module UpdateModule tried to override UpdateModule for module name RCTHotUpdate. If this was your intention, set canOverrideExistingModule=true

**解决方法:** 检查 `MainApplication.java` 或 `MainActivity.java` ，查看是否出现了两次 `UpdatePackage` 。有可能在 `import` 或者重写的方法里重复了

#### react-native-scrollable-tab-view 有时候不显示内容，升级到^0.7.4即可

#### genymotion 模拟器滑动时老切换到搜索页面，并出现00003。关闭有道词典的划词翻译即可。

#### android打包错误
本来好好地项目打包出错，比如这样的错误:`:app:packageDebug`,或者说什么解压不了文件什么的，可以尝试用下面的语句：
```
cd android
gradlew clean 
```
清理缓存后重新打包