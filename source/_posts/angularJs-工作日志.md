title: angularJs 工作日志
date: 2015-12-17 21:53:24
tags:
---
## 2015-12-17工作错误（AngularJs）

**1.** ng-show和ng-hide作用相反了，即：ng-show="true"时隐藏，ng-hide="true"时显示。

原因：指令前带ng的都是AngularJs的内置指令，对应的值不应该带"花括号"，以ng-show为例，而我是这样写的:
    
    <div ng-show="{% raw -%}{{myArg}}{%- endraw %}"></div>

应该这样写：

    <div ng-show="myArg"></div>

当时百思不得其解，ng-show与ng-hide的规则竟然会相反，原来是因为这样。

  结论：
**AngularJs自带的指令不能使用"{% raw -%}{{}}{%- endraw %}"**

**2.** Unknown Provider：某某1 <—— 某某2 <—— 某某3：
  原因：js文件中有不能识别的"依赖"，从属关系为：某某1出现在某某2中，某某2出现在某某3中，所以直接找某某3中依赖的东西，将不能识别的删除即可。以前老看不明白这是什么意思，今天明白了。

**3.** git的问题：

我之前克隆了项目的管理端仓库，今天开始写代码。发现同事和我不在一个分支上，他们在dev分支，而我在默认的分支。
于是我使用
    `git branch -a`
来查看所有分支，却只能看到master分支，远程的dev分支我并看不到，飞哥告诉我这个命令：
    `git fetch <远程主机名：默认是origin>`
这条语句的作用是：取回远程仓库所有分支的更新。这样就可以看到`origin/dev`分支了，然后就可以创建本地对应的分支并pull。