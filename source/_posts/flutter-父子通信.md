title: flutter 父子通信
date: 2019-04-02 17:28:22
tags: 
- flutter
categories: 
- flutter
---

> 很早之前看过一句话，最近又重新看到。一个程序员，应该花80%的时间做代码设计、画UML图、画时序图，20%的时间写code和debug。而我恰恰相反，是不是得改变一下做法了？

`flutter` 做出来的 App 性能非常好，比 `react-native` 好太多了，基本和原生一样。`flutter` 里面的组件叫做 `Widget` ，名称不同，思想一样，下面是一些组件通信的技巧。

### 子组件调用父组件的函数

这个简单，父组件给子组件传递回调函数参数，子组件在需要的地方调用传进来的回调函数即可

### 父组件调用子组件的函数

#### globalKey
类似于 `vue` 中的 `refs` ， 可以直接获取子组件 `state` 的引用

示例代码：

`main.dart`:
``` dart
import 'package:flutter/material.dart';

// 1. 创建 globalKey
GlobalKey<_HomePageState> globalKey = GlobalKey();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // 3. 通过 globalKey 的 currentState 获取方法
             globalKey.currentState.methodA();
            },
          ),
        ),
        // 2. 给子组件传递一个 globalKey
        body: HomePage(key: globalKey),
      ),
    );
  }
}
```
<!-- more -->
`home.dart`:
``` dart
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void methodA() {}
}
```

**注意：** `GlobalKey` 使用在 使用 `AutomaticKeepAliveClientMixin` 的 `TabBarView` 上会出问题。假如有 3 个 tab ，如果从第1个直接切换到第3个，会提示使用了重复的 `GlobalKey`。我是用的是 `flutter 1.0` ，此问题还没有解决，参见[这儿](https://github.com/flutter/flutter/issues/27010)。 `flutter 1.2` 已经出来了，但是此 `Issue` 还没有关闭 
#### Stream
订阅管理模式，类似 **EventBus** 。通过 `sink` 发送事件，`listen()` 监听事件。 

严格来说，这不是父调用子函数,而是通过事件监听。

示例代码： 注意查看上面代码有数字标志注释的代码

`home.dart`:
``` dart
class Home extends StatefulWidget {
  @override
  HomeState createState => HomeState();
}
class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  TabController controller;
  static StreamController streamController;

  @override
  void initState() {
    super.initState();
    // 1. 创建一个 广播 streamController ，可以订阅多个事件。（还可以创建 单订阅 stream）
    streamController = StreamController.broadcast();
    ConnectionListener.init(context);
    controller = new TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          this._tabIndex = controller.index;
        });
        // indexIsChanging是为了防止切换tab时触发两次
        if (controller.indexIsChanging && controller.index < 2) {
          if (controller.index == 0) {
            // 2. 触发广播， 并传递一个字符串标识符
            streamController.sink.add('refresh_wallet');
          }
        }
      });
  }

  @override
  void dispose() {
      controller.dispose();
      // 5. 销毁 streamController
      streamController.close();
      super.dispose();
  }

  Widget getTabItem(int tabIndex) {
    return Container(
      height: ScreenUtil().setHeight(58),
      child: new Tab(
        child: Text('tab' + tabIndex.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      return  new Scaffold(
        body: new TabBarView(
          children: <Widget>[
            WalletTab(streamController: streamController),
            FinancialTab(),
            UserTab()
          ],
          controller: controller,
        ),
        bottomNavigationBar: new Material(
          child: new TabBar(
            tabs: [
              getTabItem(0),
              getTabItem(1),
              getTabItem(2),
            ],
            controller: controller,
          ),
        ),
    );
  }
}
```
`walletTab.dart`（ `home` 下的第一个 `tab` ） :
``` dart
class WalletTab extends StatefulWidget {
  StreamController streamController;
  WalletTab({this.streamController});

  @override
  WalletTabState createState() => new WalletTabState();
}

class WalletTabState extends State<WalletTab> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  StreamSubscription streamSubscription;

  @override
  initState() {
    super.initState();
    // 3. 订阅广播，并判断标识符是否为 'refresh_wallet'
    streamSubscription = widget.streamController.stream.listen((value) {
      if (value == 'refresh_wallet') {
        // do something...
      }
    });
  }

  @override
  dispose() {
    // 4. 销毁广播订阅
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ...
    );
  }
}
```

### flutter 状态管理
下面这些暂时没用到，但经常看到，功能非常强大，先做了解记录一下。

#### InheritedWidget
统一状态管理，类似 `Redux` （ `flutter` 中可以使用 `Redux` ）、 `Vuex` ，子组件可以通过 `of()` 获取祖先的 `state`

#### ScopedModel
用于给子组件传递 `data` ，不用层层传递

#### BLOC
`Stream` 在 `Flutter` 中的最佳实践
