title: node常用
date: 2018-07-16 09:53:51
tags:
- node
categories: node
---

## node常用命令

### 进入、退出命令行
``` bash
# 进入命令行
node
# 正常退出退出命令行
.exit
# 强制退出
ctrl + c # 两次
```

### 调试模式
谷歌浏览器内置了 `node` 的调试器，可以很方便的打断点，看 log , 我们需要以调试模式运行 `node` 程序
``` bash
node --inspect index
# 也是以node --inspect的方式启动，只不过加了supervisor的保存即时生效
supervisor --inspect index  
```

### 软连接全局 node 包
我们可以通过 `npm install -g 包名` 的方式全局安装第远程包，但对于没有在 `node` 仓库的包无能为力。这儿有另一种方法全局添加自己写的包
``` bash
cd 文件夹
npm link
```
在全局的包仓库下引用了此仓库，原理类似于快捷方式。然后就可以全局使用自己的包命令了，不想用了的话删除软连接
``` bash
npm unlink
```
<!-- more -->