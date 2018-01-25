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
which node // 查看node命令所在地址

```
## 不同的命令
主要软件包管理器不同。虽然使用的是不同的软件包管理器，但大体的命令都差不多
- `Redhat`系列(`centos`就是其中使用最广泛的)的包管理方式采用的是基于`RPM`包的`YUM`包管理方式，包分发方式是编译好的二进制文件。
    ``` bash
    # yum -y install [package]              下载并安装一个rpm包
    # yum localinstall [package.rpm]    安装一个rpm包，使用你自己的软件仓库解决所有依赖关系
    # yum -y update                              更新当前系统中安装的所有rpm包
    # yum update [package]                 更新一个rpm包
    # yum remove [package]                删除一个rpm包
    # yum list                                        列出当前系统中安装的所有包
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
