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

#### 自定义组件
分为函数式组件和 class 组件，我们一般使用 class 组件。
- 函数式组件：
    ``` js
    /* 接受的参数是 props */
    function Welcome(props) {
        return <h1>Hello, {props.name}</h1>;
    }
    ```
- class 组件：
    ``` js
    class Welcome extends React.Component {
        render() {
            return <h1>Hello, {this.props.name}</h1>;
        }
    }
    ```
**注意：** 组件名称必须以大写字母开头。

#### 组件触发事件
``` js
class Toggle extends React.Component {
  render() {
    return (
        // 方法1. 在Render中使用bind绑定，此时方法的定义用es5的这种语法
        <Text onPress={this.handleClick1.bind(this)}>点击</Text>
        // 方法2. 定义类属性，使用es6的语法定义方法
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
推荐使用方式2，简单明了，且没有副作用。详解请参看 [官方文档](https://react.docschina.org/docs/faq-functions.html)
<!-- more -->

#### 遍历渲染组件：
`jsx` 中只能写表达式，不能写多行语句,所以不能写 `if else` 、 `for` ... 最佳循环写法是使用 `map` 函数
``` html
<View>
{
    arr.map((item, index) => <View key={item.id || index} />);
}
</View>
<!--  或----------------------------------  -->
<View>
{
    arr.map((index, index) => {
        return (<View key={index.id || index} />);
    })
}
</View>
```
*注意：* 
- `key` 必须在其兄弟节点中是唯一的，而非全局唯一
- 并不建议使用元素在数组中的索引作为 `key` 。若数组没有重排，该方法效果不错，但若重排了（比如数组内重新排序、数组头部插入新元素），那样，内容相同的元素他们的 `key` 并不相同， `React` 就会都重新渲染，而且相同 `key` 元素也有可能以意想不到的方式混淆和更新。详情参考 [这儿](https://react.docschina.org/docs/reconciliation.html)

#### [Ref](https://react.docschina.org/docs/refs-and-the-dom.html) :
分为 String 类型 和 回调函数类型，推荐使用回调函数类型，`React` 官方称 String 类型已过时并在未来版本可能被删除。还有一种是传递 `createRef()` 创建的 `ref` 属性 ，个人感觉不太方便，具体请看标题的超链接。

- 当 `ref` 属性被用于一个普通的 `HTML` 元素时，回调函数将接收底层 `DOM` 元素作为它的参数
- 当 `ref` 属性被用于一个自定义类组件时，回调函数将接收 该组件已挂载的实例 作为它的参数
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
*注意:* `ref` 只能用于 class 组件 ，不能用于 函数式组件， 因为函数式组件没有实例。

#### PureComponent 与 shouldComponentUpdate(nextProps, nextState)
`shouldComponentUpdate(nextProps, nextState)`：
- 不在初始化渲染或当使用 `forceUpdate()` 时被调用。当接收到新属性或状态时，`shouldComponentUpdate()` 在 `render()` 前被调用。
- 默认返回 `true` ，表示重新渲染。若我们想要在 `props`、 `state` 中的某些值变化时不重新渲染，通过与 `nextProps` 、 `nextState` 比较实现逻辑，在你想要的地方返回 `false`

`PureComponent` ：
在某些场景下你可以使用 `React.PureComponent` 来提升性能。与 `React.Component` 几乎完全相同，但 `React.PureComponent` 通过 `prop` 和 `state` 的浅对比来实现 `shouldComponentUpate()`

更多查看 [这儿](https://react.docschina.org/docs/react-api.html)

### react-native 调试
在调试网页的时候我们使用`Chrome Devtool` ，它上面有些面板非常好用，我最常用的有： `Source`、`Console` 、`Elements`、`NetWork`，现在我们调试 `React Native` 的 app 。我们分别使用以下工具来操作上面各项的调试：
- `Source`、`Console` : 模拟器上打开 `Debug JS Remotely`， 就会在 [http://localhost:8081/debugger-ui](http://localhost:8081/debugger-ui) 上打开调试页面，将这个页面在 `Chrome` 中打开，然后就可以跟调试网页一样，可惜只能调试这两个面板，无法监控 `Network`
- `Elements`； 安装 `react-devtools`， 并在模拟器上打开 `Toggle Inspector` 配合使用。具体参考 [官方文档](https://reactnative.cn/docs/debugging/)
- `NetWork`: 前面说到 `Debug JS Remotely` 没法监控 `Network` , 这个问题官方还没解决，可以查看这个 [issue](https://github.com/facebook/react-native/issues/934)。当然聪明人很多，有大佬开发了 [reactotron](https://github.com/infinitered/reactotron) ,使用的话：
    - 需要安装这个软件、项目中安装依赖 `yarn add reactotron-react-native -D`
    - 添加配置文件`ReactotronConfig.js` 并引入到入门文件——`index.js`/`App.js` 首行即可

    具体的请参考 [官方链接](https://github.com/infinitered/reactotron/blob/master/docs/quick-start-react-native.md) 或 [掘金的这篇文章](https://juejin.im/post/5a61641751882573443cc202)。  
    *注意：* 如果要监听 `Android` 模拟器的请求，需要运行 `adb reverse tcp:9090 tcp:9090` （**9090**是 `Reactotron` 的默认端口） , 并且在 `ReactotronConfig.js` 中配置
    ``` js
    Reactotron.configure({ host: '宿主机ip' }).connect()
    ```
    详情参考[此issue](https://github.com/infinitered/reactotron/issues/174)

#### 开启自动刷新：真机或者模拟器中`Enable Live Reload` 和`Enable Hot Reloading`同时打开，下面的情况需要重新编译:
- 增加了新的资源(比如给 `iOS` 的Images.xcassets或是 `Andorid` 的res/drawable文件夹添加了图片)
- 更改了任何的原生代码（objective-c/swift/java）

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
*tip: 其他常用 `adb` 命令*
``` bash
# 进入模拟器shell命令
cd ...sdk/platform-tools/
adb -s 设备名称 shell 
# 获取模拟器配置(进入模拟器shell之后)
getprop
```
3. 如果是两个模拟器，和电脑在同一个wifi下，那分别在 **dev-setting** => **Debug server host & port for device** 下添加：**电脑ip:port** 。设置之后按两次R重新加载 `bundle` 即可。  
**注意：两个模拟器都必须指定端口,即使一个`packger`是默认端口。**  
**疑问： 同时启动 ios 和 android 模拟器经常有一个会没反应，原因未知**

### react-native 打包
[官方文档](https://reactnative.cn/docs/signed-apk-android/)介绍的很详细，下面只是些临时用作测试的打包
#### android
不使用签名的简单打包： 
``` bash
cd android
./gradlew assembleRelease
```

### react-native 常见错误
#### Native module 模块名 tried to override 模块名 for module name xxx. If this was your intention, set canOverrideExistingModule=true
**原因：** 通常重复执行 `react-link` 引起的，会在 `MainApplication.java` 、 `build.gradle` 、 `settings.gradle` 里重复导入包。这是 facebook 的官方bug，详情可以看 [stackoverflow](https://stackoverflow.com/questions/43032841/react-native-link-causes-duplicate-imports-in-android-settings-gradle)

**解决方法:** 检查 `MainApplication.java`，删除重复出现的包 。一般是在两个地方重复，一是 `import` ，二是 `protected List<ReactPackage> getPackages()` 里面。 `build.gradle` 、 `settings.gradle` 里虽然也重复了，但不会报错，项目也可以正常跑起来。

**注意：** 有些包虽然你执行了 `react-native link`， 但并不会正确引入到原生代码里。比如说：[react-native-permissions](https://github.com/yonahforst/react-native-permissions)，需要单独执行 `react-native link react-native-permissions` 。具体情况还是多看看人家的 `README`

#### react-native-scrollable-tab-view 有时候不显示内容，升级到^0.7.4即可

#### genymotion 模拟器滑动时老切换到搜索页面，并出现00003。关闭有道词典的划词翻译即可。

#### android打包错误
本来好好地项目打包出错，比如这样的错误:`:app:packageDebug`,或者说什么解压不了文件什么的，可以尝试用下面的语句：
```
cd android
gradlew clean 
```
清理缓存后重新打包

#### 权限问题
1. 官方对 `android` 出了 [PermissionsAndroid](https://reactnative.cn/docs/permissionsandroid/) API，刚开始检测 相机权限 ，无论我在 app 中给没给相机权限，这个 API 给我返回的结果都是有权限。

    **原因：** `Android 6.0` 之前的版本只要是在 `AndroidManifest.xml` 申明的权限这个 API 都会返回有权限。

    **解决方法：** 需要修改 `build.gradle` 里的 `targetSdkVersion` 为 23 才可以。*注意： 需要卸载原来的 app 重新装。*

2. `Ios` 的权限判断使用 [react-native-permissions](https://github.com/yonahforst/react-native-permissions) , 其实 `android` 也可以使用这个，很方便。下面有个 demo：
    ``` js
    _requestCameraIosPermission = async () => {
        let permitStr = 'camera';
        let response = await Permissions.check(permitStr);
        if (response === 'undetermined') { /* 之前没有弹出来过权限申请 */
            let requestResult = await Permissions.request(permitStr);
            return requestResult === 'authorized';
        } else if (response !== 'authorized') {
            Alert.alert(
                '权限提醒',
                '请到设置中开启INKubator Pay的相机权限',
                [
                    { text: 'Ok', onPress: Permissions.openSettings }, /* 跳转到IOS系统的权限设置 */
                    { text: 'Cancel', style: 'cancel'}
                ]
            );
            return false;
        }
        return true;
    };
    ```

### react-native 杂谈
#### `Android` api与版本号对应关系
`react native` 要求我们安装的 `sdk` 都是 api 23 的对应版本，这个对应的版本号是 `Andrid 6.0` ，其他的对应关系请参考 [这儿](https://source.android.com/source/build-numbers)

#### `require`只能使用静态字符串，因为它是在编译期执行，而不是运行期。js执行过程:
![react-native-run](http://7xphbb.com1.z0.glb.clouddn.com/react-native-run.png)
`React Native`从0.5.0版本开始已经内置`Babel`转换器

#### Android Studios 常用快捷键
```

```

#### XCode 常用快捷键
- 快速打开某一个文件: **command + shift + O**
- 返回至上一次光标位置： **control + command + ← , control + command + →**
- 快速查看当前class的方法： **control + 6**