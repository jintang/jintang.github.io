title: dart需知
date: 2019-04-24 16:12:30
tags: 
- dart
categories: flutter
---

谷歌开发了 `dart` 语言，目前已经可以用作 `web` 端 和 移动端(`flutter`)，在谷歌的展望中以后还可以做桌面端，大一统啊。 此处记录下一些基本又重要，自己会选择性忽视和经常要用的点。

特点：

- 基于类，面向对象，类可以继承，但只可以单继承
- 接口实现（多态），抽象类，泛型
- 单线程（拥有异步处理）
- 动态类型(类似 `js` ，拥有 `var`) 或 类型注解(使用 静态类型关键字 来声明变量，以获得严格的类型检查)。我们可以这样编写我们的代码，在函数的入口，即定义函数的参数时使用 类型注解；而在函数内部，当类型并不重要时使用 动态类型。

<!-- more -->

### 基本类型相关
1. `double` 是 64 位
2. `String` 是 UTF16

### StringBuffer
``` dart
main() {
  StringBuffer sb = new StringBuffer();
  sb.write("Hello");
  sb.writeAll(['space', 'and', 'more']);
 
  print(sb);
  print(sb.toString());
  
  sb.clear();
}
```

### List
常用方法使用 `js` 作为比较。
1. `foreach` 类似 `js` 的 `foreach`
如果想遍历时获取 `index` , 转为 `{'index': item}` 的对象遍历， 完成之后再转为 list :
``` dart
list.asMap().forEach((index, item) {
    // do something...
}).toList()
```
2. `map` 类似 `js` 的 `map`
3. `where` 类似 `js` 的 `filter`： 删选符合要求的元素
4. `any` 类似 `js` 的 `every`： 检测列表中是否所有元素都满足要求

### Set
两个特点：没有顺序，唯一元素
``` dart
Set english  = new Set();
english.add('door');
english.add('car');
english.add('door');
english.add('lunar');
english.add('era');
print(english); // {door, car, lunar, era}

Set spanish = new Set();
spanish.addAll(['era', 'lunar', 'hola']);
print(spanish); //  {era, lunar, hola}

print(english.intersection(spanish)); //  {lunar, era}
print(english.difference(spanish));   //  {door, car}
print(english.union(spanish)); // {door, car, lunar, era, hola}
```

### Map
``` dart
Map joe = {
    "name"  : "Joe",
    "email" : "joe@somewhere.com" 
};
print(joe); // {name: Joe, email: joe@somewhere.com} 

joe.putIfAbsent('email', () => 'a@b.com');
print(joe); // {name: Joe, email: joe@somewhere.com}
joe.putIfAbsent('birthdate', () => new DateTime.now());
print(joe);
// {name: Joe, email: joe@somewhere.com, birthdate: 2014-02-25 20:53:04.548}

print(joe.containsKey('email')); // true
```

### setTimeout
``` dart
import 'dart:async';

main() {
  new Timer(new Duration(seconds: 1), () => print("timeout"));
  print("end main");
}
```

### iterator 与 Iterable
`iterator`：
``` dart
var names = ['Foo', 'Bar', 'Qux'];
var it = names.iterator;
  while (it.moveNext()) {
    var n = it.current;
    print(n); // Foo Bar Qux
  }
```
`Iterable`:
``` dart
var numbers = new Iterable.generate(5, (i) => i);
for (var n in numbers) {
   print(n); // 0 1 2 3 4
 }
```