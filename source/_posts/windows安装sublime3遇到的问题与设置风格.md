title: windows安装sublime3遇到的问题与设置风格
date: 2015-12-16 22:58:21
tags:
---
> 工欲善其事必先利其器，家里的电脑太烂，网速太垃圾，游戏都玩不了，所以安安静静的配个环境吧。

### 一、开启debug模式
如果你在安装sublime的过程中出现了错误，建议要开启sublime3的debug模式，虽然我并没体会到什么区别，但是网上大神都这样说，应该是没有错的。开启方法如下：

将PackageControl.sublime-settings文件中的debug参数设为true，默认是false，表现为：**"debug": true,**  ，配置是个json文件，所以注意格式，特别是前后的"，"。网上都说在安装目录的什么下，比如说

`D:\Program Files\Sublime Text 2\Data\Packages\PackageControl\PackageControl.sublime-settings`

说实话，我完全找不到，没有隐藏文件夹！而我的在这儿：

`C:\Users\Administrator\AppData\Roaming\Sublime Text 3\Packages\User`
<!-- more -->
正如大家所看到的，这个AppData文件里面有你所有安装程序的配置，具体的作用还不明确。所以不论你的sublime3装在那儿，这个文件都要在这个文件夹下去找你程序对应的配置文件。这儿有稍微便捷点的方式：

打开`sublime——Preference——Browse Packages..`就可以直接到刚刚那个目录下面，然后在进入到user文件夹，你就可以看到PackageControl.sublime-settings文件了。修改即可！
这儿还有更简单的方法，不过前提是你装了Package Controller：

打开`sublime——Preference——Packages setting——Package Controller——选择Settings-User`，里面加上"debug": true,即可。细心的朋友相比注意到了旁边的Settings-Default，看英文单词你也可以明白意思，这个改不了，但是可以参考！哈哈，里面就可以找到"debug"这个属性，这个文件里设的false。

好的，debug模式已经打开了。

### 二、错误：There are no packages available for installation
 之前在电脑上安装过sublime3，但是最强大的Package Controller功能用不了，具体表现为：ctrl+shift+p可以打开，选择install package的时候打不开，并报此错误：

    There are no packages available for installation

 网上说是IPv6造成，要修改hosts文件，我也改了，但并没有起作用，不知道为什么。可能这个sublime3太久远了。这个给个链接吧，因为我觉得网上说的是有道理的，即使我的并没有起作用。
    国外：http://stackoverflow.com/questions/25105139/sublime-text-2-there-are-no-packages-available-for-installation
    国内：http://www.w3cfuns.com/blog-5439979-5405518.html
   
 这两个链接对此问题的解决方案是一样的，国内的看着明白，那为什么放国外的呢，多看看总是有好处的。
    
上回说到，我并没有因为上面的措施而解决掉问题，那我是怎么解决的呢。很傻的办法，我把sublime3卸载了...重新安装了一遍....

汗！重新之后还是不行，我看到我还没有装Package Controller，但是重新安装后却已经存在了，于是，我把C盘下那个AppData里Sublime3文件夹整个删除了， 重启后Package Controller才消失的。然后按照官方的指导安装了Package Controller，链接如下：
    https://packagecontrol.io/installation#st3
网上虽然可以搜到一大堆这个教程，但是有时候官方会更新的，所以有时候就用不了，所以，尽量选择官方文档。
    
这下果然成功了，装完之后，我开始用Package Controller装其他插件，第一个jsFormat,好吧，第一个又报错了！错误如下：

    ignored packages updated to: ["Vintage"]

这个很好解决，首先给个链接：
https://www.sublimetext.com/docs/3/vintage.html
恩，这个是官方的文档，然后按官方的改就可以！

懒得看的同学看这里：
打开`sublime——Preferences——选择Settings-User`，打开了这个文件，观察到，这也是个json文件，找到了这条语句：`"ignored_packages": ["Vintage"]`
将其改成：`"ignored_packages": []`  即可！
    
##### 未完待续
    
