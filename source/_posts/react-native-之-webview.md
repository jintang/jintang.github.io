title: react-native 之 webview
date: 2018-12-04 16:07:11
tags:
- react-native
categories: react-native
---
> 前段时间公司要求写个游戏嵌入到 App 中，我们通过 `webview` 链接到 App 中，中间遇到了很多坑，在此记录一下。

``` js
const sourceAndroid = { uri: 'file:///android_asset/trivia-game/index.html' };
const sourceIOS = { uri: './trivia-game/index.html' };
source = Platform.OS === 'ios' ? sourceIOS : sourceAndroid;
<WebView
    ref={( webView ) => this.webView = webView}
    source={ source }
    originWhitelist={["file://", '*']}
    style={{height: this.state.webViewHeight}}
    javaScriptEnabled = { true }
    scrollEnabled = { false }
    domStorageEnabled = { true }
    scalesPageToFit = { true }
    startInLoadingState = { true }
    renderLoading = { () => <ActivityIndicator />}
    onLoadEnd={ this._onLoadEnd }
    onMessage={ this._onMessage }
    onNavigationStateChange={ this._onNavigationStateChange }
    allowUniversalAccessFromFileURLs={ true }
    mediaPlaybackRequiresUserAction={ false }
/>
```
官方介绍： [webview](https://reactnative.cn/docs/webview/)，其中像 `javaScriptEnabled` 这些属性是我们常用的，还有一些不常用但很能填坑的属性下面介绍下
### webview 与 react-native 通信
目前只能传递字符串
#### `webview` 给 `react-native` 发消息：
``` js
window.postMessage('str')
```
`react-native` 通过 `onMessage` 接受消息：
``` js
_onMessage = (e) => {
    console.log( "On Message", e.nativeEvent.data );
};
```
#### `react-native` 给 `webview` 发消息：
``` js
this.webView.postMessage('str');
```
`webview` 接受消息：
``` js
document.addEventListener( 'message', event => {
    console.log(event.data)
}, false)
```
<!-- more -->

### 自动计算 webview 高度
> 刚开始我使用的是 `onLoadEnd` 计算网页高度。当图片加载成功时 **Android** 和 **Ios** 都 OK 。如果有图片加载失败， **Ios** Ok ， **Android** 的高度会计算失败，内容显示不全。
 ``` js
 _onLoadEnd = () => {
     const script = `window.postMessage(document.body.scrollHeight)`;
     this.webView.injectJavaScript(script);
 };
 _onMessage = (event) => {
         const height = parseInt(event.nativeEvent.data) || 0;
         if (height > 0) {
             this.setState({ webViewHeight: height });
         }
     };
 ```

下面的方案可以修复上面的问题：  
在 `index.html` 中添加：
``` html
<head>
    <style>
        #height-wrapper {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
        }
    </style>
</head>
<body>
    <script>
        ;(function() {
            var wrapper = document.createElement("div");
            wrapper.id = "height-wrapper";
            while (document.body.firstChild) {
                wrapper.appendChild(document.body.firstChild);
            }
            document.body.appendChild(wrapper);
            var i = 0;
            function updateHeight() {
                document.title = wrapper.clientHeight;
                window.location.hash = ++i;
            }
            window.addEventListener("load", function() {
                updateHeight();
            });
        }());
    </script>
</body>
```
在 `react-native` 监听 `onNavigationStateChange` ：

``` js
_onNavigationStateChange = (navState) => {
    if (navState.title && (navState.title - this.state.webViewHeight > 0)) {
        this.setState({
            webViewHeight: parseInt(navState.title)
        });
    }
};
```

### 打包后 react-native 找不到资源
我们的 `index.html` 引用了其他的 js ， 而 js 中引用了很多图片、音乐、字体 ...  
**Android** 和 **Ios** 中需要放在各自的资源目录下，具体是：

- **Android** ： 
    `android/app/src/main/assets/` 下，将游戏打包后的文件夹 `trivia-game` 放到前面的目录下。
    `webview` 中 `source` 对应的地址为 `file:///android_asset/trivia-game/index.html`。
    `webview` 必须添加 `allowUniversalAccessFromFileURLs={ true }` ，不然只能读到 js ，而不能读取到 js 引用的其他资源。
    这是这个属性的介绍： Boolean that sets whether JavaScript running in the context of a file scheme URL should be allowed to access content from any origin. Including accessing content from other file scheme URLs
- **Ios** : 
    `ios/external/` 下，若没有 external 目录则先新建一个， 将游戏打包后的文件夹 `trivia-game` 放到前面的目录下。
    `webview` 中 `source` 对应的地址为 `./trivia-game/index.html`。

另外，**Android** 下的 `Webview` 不识别 `svg` 文件 ，我目前的做法是将文件转为了 `base64` 格式，不知道有大佬有更好的方案吗？

### ios 下 音乐不自动播放
添加属性： `mediaPlaybackRequiresUserAction={ false }` , 原因是 **Ios** 默认需要用户操作才可以播放音乐和视频

### 调试工具
- **Android** :
    [chrome://inspect/#devices](chrome://inspect/#devices) 是很好用的工具，之前调试 `webview` 、手机网页 都很好用。但在 **genymotion** 模拟器中，整个调试器的样式都是乱的。查询到这个 [答案](https://stackoverflow.com/questions/47980279/google-chrome-devtools-broken-when-inspecting-android-webview), 原因是 **Chrome** 去掉了一个 `api` ，所以我下了旧版的 **Chromium**。前面答案的超链接里有下载地址。
- **Ios** : 使用 **Safari** ,具体参考 [这儿](https://stackoverflow.com/questions/47991959/how-to-debug-a-webview-in-react-native)