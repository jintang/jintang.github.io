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

### 本地仓库 关联 远程仓库
``` shell
git remote add origin 远程git仓库地址
```
如果是 `git clone` 下来的仓库，本地仓库与远程仓库是自动关联的。有时候我们本地做了`demo`，做完之后想上传到`github`去，就在`github`上新建了一个仓库，但加上了`init README`，当我用上面的命令将本地仓库与远程仓库关联之后，由于远程仓库有 `README.md` 文件，所以需要先 `pull` ， 但报了下面的错误:
``` shell
fatal: refusing to merge unrelated histories
Error redoing merge 1234deadbeef1234deadbeef
```
解决方案:
``` shell
git pull origin master --allow-unrelated-histories # git 2.9后可用
```

### 本地分支 关联 远程分支
``` shell
git branch --set-upstream-to=origin/master master
```
创建新分支并关联到远程分支
``` shell
git checkout -b 本地分支名x origin/远程分支名x
```
查看本地分支与远程分支的关联关系
``` shell
git branch -vv
```
如果关联错了先取消与远程仓库的关联，再重新关联分支
``` shell
git remote remove origin # 注意是取消了仓库的关联，还需要重新关联仓库
```
<!-- more -->
### 一般流程
经过上面的步骤我们关联了远程仓库和远程分支，然后就可以用下面的步骤工作了。  
每次操作完可以通过 `git status` 查看文件状态

1. add
    ``` shell
    git add . # .表示所有
    ```
    如果文件提交错了，想撤销：
    ``` shell
    git reset HEAD <file> # 不指定文件表示所有文件
    ```
    如果想要放弃文件修改:
    ``` shell
    git checkout -- <file> #
    ```
2. commit
    ``` shell
    git commit -m "本次提交的备注，一般填写内容"
    ```
    如果 `commit` 错了，想撤销：
    ``` shell
    # 查看 commit 历史，找到想撤销的commit_id
    git log
    # 如果不加--hard只会撤销commit信息，而commit的代码不会撤销
    git reset --hard commit_id
    ```
3. push
    ``` shell
    # 若当前分支有关联的远程分支,下面命令会自动提交到对应的远程分支
    git push
    # 指定其他分支提交
    git push origin 远程分支名
    ```
    如果 `push` 错了，想撤销：  
    先用上面撤销 `commit` 的办法回退本地代码，然后强制提交覆盖远程代码：
    ``` shell
    git push origin <分支名> --force
    ```
### 分支切换流程
当你正在进行项目中某一部分的工作，里面的东西处于一个比较杂乱的状态，而你想转到其他分支上进行一些工作。问题是，你不想提交进行了一半的工作，否则以后你无法回到这个工作点。

1. 储藏当前没做完的工作
    ``` shell
    git stash
    # 或
    git stash save "stash说明"
    ```
    查看储藏列表，可能会有多个储藏
    ``` shell
    git stash list
    ```

2. 转到新分支

    我们可以用 `git checkout 分支名` 切换到该分支 或者 上面提到的 `git checkout -b 分支名` 创建新分支并转到该分支

3. 做完工作重新回到原来分支并恢复储藏
    ``` shell
    git stash apply # 默认是最近的储藏
    ```
    若要应用更早的储藏
    ``` shell
    git stash apply stash@{2} # stash@{2}是 git stash list 下列出的一条储藏id
    ```
4. 清除储藏
    随着 `git stash list` 下的储藏越来越多，我们需要清理一下
    ``` shell
    git stash drop stashId
    ```
    可以通过`git stash pop` 同时完成 `apply` 和 `drop` 的工作。

    清除所有储藏：
    ``` shell
    git stash clear
    ```
    更多请参考 [这儿](http://iissnan.com/progit/html/zh/ch6_3.html)

### 杂项

1.  `git branch -a` 看不到所有的远程分支：

    我之前克隆了项目的管理端仓库，今天开始写代码。发现同事和我不在一个分支上，他们在 `dev` 分支，而我在默认的分支。
    于是我使用 `git branch -a`
    来查看所有分支，却只能看到 `master` 分支，远程的 `dev` 分支我并看不到，飞哥告诉我这个命令： `git fetch <远程主机名：默认是origin>`

    这条语句的作用是：取回远程仓库所有分支的更新。这样就可以看到 `origin/dev`分支了，然后就可以创建本地对应的分支并 `pull` 。
