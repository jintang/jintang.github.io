title: git常见问题
date: 2016-06-24 09:14:44
tags: 
- git常见错误
categories: git
---
#### git branch -a看不到所有的远程分支：
我之前克隆了项目的管理端仓库，今天开始写代码。发现同事和我不在一个分支上，他们在dev分支，而我在默认的分支。
于是我使用
    `git branch -a`
来查看所有分支，却只能看到master分支，远程的dev分支我并看不到，飞哥告诉我这个命令：
    `git fetch <远程主机名：默认是origin>`
这条语句的作用是：取回远程仓库所有分支的更新。这样就可以看到`origin/dev`分支了，然后就可以创建本地对应的分支并pull。
<!-- more -->
