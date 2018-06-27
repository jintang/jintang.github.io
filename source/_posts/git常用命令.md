title: git常用命令
date: 2016-06-24 09:14:44
tags: 
- git
categories: git
---
>仅以此记录自己常忘记的命令

### 基本配置
安装完之后需要一些基本配置：
1. 生成公钥私钥： `ssh-keygen`
2. 在配置用户名和邮箱：
    ``` bash
    $ git config --global user.name "用户名"
    $ git config --global user.email "邮箱"
    ```
3. 可以用 `git config --list` 查看配置，所有的自定义配置存放在 `~/.gitconfig` 里

### 本地仓库与远程仓库关联
``` shell
git remote add origin 远程git仓库地址
```

### 强制pull来合并
我新建了个本地项目来做`demo`，做完之后想上传到`github`去，就在`github`上新建了一个仓库，但手快加上了`init README`，当我用上面的命令将本地仓库与远程仓库关联之后，`pull`时报下面的错:
``` shell
fatal: refusing to merge unrelated histories
Error redoing merge 1234deadbeef1234deadbeef
```
这个是`git 2.9`之后出现的  
**解决方案:**
``` shell
git pull origin master --allow-unrelated-histories
```

### 本地分支关联远程分支
``` shell
git branch --sep-upstream master origin/master
```

### git branch -a看不到所有的远程分支：
我之前克隆了项目的管理端仓库，今天开始写代码。发现同事和我不在一个分支上，他们在dev分支，而我在默认的分支。
于是我使用
    `git branch -a`
来查看所有分支，却只能看到master分支，远程的dev分支我并看不到，飞哥告诉我这个命令：
    `git fetch <远程主机名：默认是origin>`
这条语句的作用是：取回远程仓库所有分支的更新。这样就可以看到`origin/dev`分支了，然后就可以创建本地对应的分支并pull。
<!-- more -->
