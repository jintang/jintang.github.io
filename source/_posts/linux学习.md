title: linux学习
date: 2018-01-23 14:38:48
tags: 
- linux
categories: linux
---
>谷歌云有一个免费1年的服务，那就申请一个学习学习啦。对于`linux`之前只用过`ubuntu`，装啥环境感觉非常方便。用这篇文章来记录下自己的理解。

`linux`有很多发行的版本，想要了解请看[这里](http://blog.sciencenet.cn/blog-3373182-1089895.html)。我这次使用了其中的`centos7`和`debian9`。之前我使用的`ubuntu`是基于`Debian`的`unstable`版本加强而来。

## 通用的命令
``` bash
$ which node # 查看node命令所在地址
$ man ps # 查看ps命令的用法
```
**systemctl**命令：系统管理与服务管理
``` bash
$ sudo systemctl start mysqld # 启动mysql服务
$ sudo systemctl status mysqld # 查看mysql服务的状态

$ sudo systemctl enable mysqld # mysql单元开机启动
# 查看开启启动项：
# 只显示sysV services，上面的mysqld是不展示的
$ chkconfig --list
# 查看系统服务，其中开机启动的服务状态是enabled，可以看到mysqld
$ systemctl list-unit-files
```
<!-- more -->
## 进程管理
进程状态：
- R： running or in run queue（在运行队列中等待）
- S： sleeping，可中断的睡眠状态
- D： uninterruptible sleep (usually IO)，不可中断的睡眠状态
- T： traced or stopped，此刻进程是不可中断的
- Z： zombie（僵尸），退出状态，进程成为僵尸进程

### ps
显示progress status的静态结果。详细参数请点击[这儿](http://man.linuxde.net/ps)。
**常见用法：**
``` bash
# 默认只显示运行在当前控制台下的属于当前用户的进程
$ ps
# -a表示所有，加上x会显示所有进程，包括没有控制终端的进程
$ ps -ax
# 查看tang用户下的进程，没有指定用户名时默认为当前用户
$ ps -u tang
# 查看系统中所有用户下所有进程，显示全面信息，常用！
$ ps -aux
```
**引申用法：**
``` bash
# 根据 CPU 使用来升序排序
$ ps -aux --sort -pcpu
# 根据 内存使用 来升序排序
$ ps -aux --sort -pmem
# 将上面两个合并到一个命令，并通过管道显示前10个结果
$ ps -aux --sort -pcpu,-pmem | head -n 10
# 根据进程名过滤，如下查找mongod进程
$ ps -C mongod
# 根据PID过滤
$ ps -L 1213
# 显示更多信息加-f
$ ps -C mongod -f
```
`ps -aux`显示的结果：
![ps_result](http://7xphbb.com1.z0.glb.clouddn.com/linux_ps_result.png)
**列的含义：**
- USER： 账号
- PID： progress id
- %CPU： 占用cpu百分比
- %MEM：占用物理内存百分比
- VSZ：占用虚拟内存(kb)
- RSS：占用固定内存(kb) 
- TTY：该 process 是在哪个终端机上面运作，若与终端机无关，则显示 ?，另外， tty1-tty6 是本机上面的登入者程序，若为 pts/0 等等的，则表示为由网络连接进主机的程序。
- STAT：进程状态，参照本节刚开始的说明
- START： 启动时间
- TIME： 运行时间
- COMMAND： 实际指令  

>**Tip：**不可中断，指的并不是CPU不响应外部硬件的中断，而是指进程不响应异步信号：进程收到SIGSTOP, SIGSTP, SIGTIN, SIGTOU信号后停止运行

### top
实时（动态的）显示系统中各个进程的资源占用状况，类似于Windows的任务管理器。
**使用：**
``` bash
$ top [参数]
```
**参数说明：**
- d 指定每两次屏幕信息刷新之间的时间间隔。当然用户可以使用s交互命令来改变之。
- p 通过指定监控进程ID来仅仅监控某个进程的状态。
- q 该选项将使top没有任何延迟的进行刷新。
- c 显示整个命令行而不只是显示命令名
- S 指定累计模式
- s 使top命令在安全模式中运行。这将去除交互命令所带来的潜在危险。
- i 使top不显示任何闲置或者僵死进程。

**结果：**
![top-result](http://7xphbb.com1.z0.glb.clouddn.com/linux-top-result.png)
**含义：**
1. top：
    - 08:01:27 当前时间
    - up 1 day, 23:14 系统运行时间，格式为时:分
    - 1 user 当前登录用户数
    - load average: 0.00, 0.02, 0.05 系统负载，即任务队列的平均长度。三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值。
2. Tasks：进程状态，状态说明参考`ps`指令，不再详述
3. %Cpu(s)：cpu 百分比
    - 2.0 us 用户空间占用CPU百分比
    - 4.0 sy 内核空间占用CPU百分比
    - 0.0 ni 用户进程空间内改变过优先级的进程占用CPU百分比
    - 94.0 id 空闲CPU百分比
    - 0.0 wa 等待输入输出的CPU时间百分比
    - 0.0 hi：硬件CPU中断占用百分比
    - 0.0 si：软中断占用百分比
    - 0.0 st：虚拟机占用百分比
4. KiB Mem：物理内存使用情况，只解释下面一个，其他看单词就可以明白
    - 157056 buff/cache 用作内核缓存的内存量
5. KiB Swap：交换区使用情况
6. 统计区列的含义：下面没列出来的请参考`ps`指令。
    - PR：priority。优先级
    - NI：nice。负值表示高优先级，正值表示低优先级
    - VIRT：进程使用的虚拟内存总量，单位kb。
    - RES：进程使用的、未被换出的物理内存大小，单位kb。
    - SHR：共享内存大小，单位kb
    - S：进程状态，参照本节刚开始的说明
    - TIME+：进程使用的CPU时间总计，单位1/100秒
    
## 包管理器
`centos`与`debian`虽然使用的是不同的软件包管理器，但大体的命令都差不多
- `Redhat`系列(`centos`就是其中使用最广泛的)的包管理方式采用的是基于`RPM`包的`YUM`包管理方式，包分发方式是编译好的二进制文件。
    ``` bash
    # yum -y install [package]              下载并安装一个rpm包
    # yum localinstall [package.rpm]    安装一个rpm包，使用你自己的软件仓库解决所有依赖关系
    # yum -y update                              更新当前系统中安装的所有rpm包
    # yum update [package]                 更新一个rpm包
    # yum remove [package]                删除一个rpm包
    # yum list                            列出当前系统中安装的所有包
    # yum search [package]                 在rpm仓库中搜寻软件包
    # yum clean [package]                   清除缓存目录（/var/cache/yum）下的软件包
    # yum clean headers                      删除所有头文件
    # yum clean all                                删除所有缓存的包和头文件
    ```
- `Debian`最具特色的是`apt-get / dpkg`包管理方式，包分发方式是编译好的二进制文件。其实`Redhat`的`YUM`也是在模仿`Debian`的`APT`方式，但是`YUM`可供选择的包比较少。
    ``` bash
    用法：
     apt-get [选项] 命令  
     apt-get [选项] install pkg1 [pkg2 ...]  
    命令：  
     update - 重新获取软件包列表  
     upgrade - 进行更新  
     install - 安装新的软件包  
     remove - 移除软件包  
     autoremove - 自动移除全部不使用的软件包  
     purge - 移除软件包和配置文件  
     source - 下载源码档案  
     build-dep - 为源码包配置编译依赖  
     dist-upgrade - 发行版升级, 参见 apt-get(8)  
     dselect-upgrade - 依照 dselect 的选择更新  
     clean - 清除下载的归档文件  
     autoclean - 清除旧的的已下载的归档文件  
     check - 检验是否有损坏的依赖  
      
    选项：  
     -h 本帮助文件。  
     -q 输出到日志 - 无进展指示  
     -qq 不输出信息，错误除外  
     -d 仅下载 - 不安装或解压归档文件  
     -s 不实际安装。模拟执行命令  
     -y 假定对所有的询问选是，不提示  
     -f 尝试修正系统依赖损坏处  
     -m 如果归档无法定位，尝试继续  
     -u 同时显示更新软件包的列表  
     -b 获取源码包后编译  
     -V 显示详细的版本号  
     -c=? 阅读此配置文件  
     -o=? 设置自定的配置选项，如 -o dir::cache=/tmp 
    ```
