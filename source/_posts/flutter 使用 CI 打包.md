title: flutter 使用 CI 打包
date: 2019-06-03 10:01:06
tags:
- flutter
- CI
categories: CI
---

> `CI` (continuous integration) : 持续集成。用来做一些自动化工作，比如程序的打包，单元测试，部署等。
> - 我最常用的 `git` 仓库是 `Github` , `Travis CI` 对 `Github` 支持的特别好，使用非常方便。
> - 公司的仓库在 `Gitlab` 上， `Gitlab`自己内部集成了 `Gitlab CI`。
> 
> 本文主要介绍这两种 `CI` 自动化打包部署 `flutter apk`

## Travis CI

`Travis CI` 与 `Github` 结合比较紧密，对 `GitHub` 上的开源Repo是免费的，私有Repo收费。

`Travis CI` 有两个网址，一个是 [travis-ci.org](https://travis-ci.org) ， 另一个是 [travis-ci.com](https://travis-ci.com/) 。 官方推荐使用 `travis-ci.com` ， 告诉我们 `travis-ci.org` 后面会全部迁徙到 `travis-ci.com` 。 目前在两个网址都可以实现效果，没啥区别，但不能同时使用。

下面以 `travis-ci.org` 为例，反正我刚开始用的时候就选了这个，索性 "将错就错"
### 激活要运行 CI 的仓库
使用 `github` 账号登录 `travis-ci.org` ， 在个人设置中心可以看到自己在 `github` 上的仓库， 打开对应的开关即可激活。如图: ![travis_active](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/travis_active.png)

### `.travis.yml `
在项目根目录下添加 `.travis.yml `, `travis` 提供了多种语言要用的例子， 可以参考[这儿](https://docs.travis-ci.com/user/language-specific/)。这儿想实现一个 `flutter` 打包 `apk` 的 `CI` , 我们可以参照它提供的 `android` 例子。 但是 `flutter` 和 `android` 都更新的太快了，所以例子上用的都是老的 `android` 。

这是我的 `.travis.yml` ， 基于最新的 `flutter` 版本（目前稳定版是 `flutter 1.5.4` ）与 `android28` 进行打包。我这儿暂时没有加签名...
<!-- more -->

``` yml
os: linux
language: android
# android 相关的证书
licenses:
  - android-sdk-preview-license-.+
  - android-sdk-license-.+
  - google-gdk-license-.+
# android 相关环境
android:
  components:
    - tools
    - platform-tools
    - build-tools-28.0.3
    - android-28
    - sys-img-armeabi-v7a-google_apis-28
    - extra-android-m2repository
    - extra-google-m2repository
    - extra-google-android-support
jdk: oraclejdk8
sudo: false
# 运行 ci 的 docker 容器
addons:
  apt:
    sources:
      - ubuntu-toolchain-r-test
    packages:
      - libstdc++6
      - fonts-droid
# flutter doctor --android-licenses 要求先运行下面这条语句， yes | 表示后面的命令如果需要你输入 y/n 会自动帮你输入 y
before_install:
  - yes | sdkmanager --update
before_script:
  - git clone https://github.com/flutter/flutter.git -b stable --depth 1
  - export PATH="$PATH:`pwd`/flutter/bin"
script:
  - flutter packages get
  - flutter precache
  # 由于用的新的 android , 需要接受额外的一些证书
  - yes | flutter doctor --android-licenses
  - flutter doctor && flutter -v build apk
# 缓存
cache:
  directories:
  - "$HOME/.pub-cache"
```
每次提交代码后就会自动触发 `CI`, 可以在 `travis-ci.org` 下你的仓库中看到。比如我的这个 [demo](https://travis-ci.org/jintangWang/my_app) ,可以看到

### 部署
如果需要自动打包到 `github` ，我们还需要在 `.travis.yml` 中添加部署的代码。
#### 本地安装 travis
``` bash
gem install travis
```
#### 生成部署命令
``` bash
travis setup releases
```
会要求你输入你的 `github` 账号， `github` 密码，`apk` 相对于项目根目录的路径，后面的直接选择回车表示 yes 就行了。 结果如图： ![travis_release](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/travis_release.png)

``` yml
deploy:
  provider: releases
  api_key:
    secure: lASdvkCQ58SnGHwtaDk9s6ibWdQrnfxrnkNv3igt4fkLGMZknsDf821w1X+U+tcI7pP/vgJ4f4ijQAzmpAmt5WX6j2YBvMKWA8Wz7xQvs4iPL45uA3bD4FZcssQM9HHuKgBQnUyQ5nIcyEj8RRDFXiBGGVLmus2bEjocHThyH4B9BreWAaW0wudOwUoTmRmHCLNmoD1lgiraDT47piJFXGdlPNy3bUfHpKy9uetXVkDTVzYGm2mqYn/PAfhgnd67/xKUwXuCbBFTIdOYQ3VMfIl9vzZ3B1bMgYJNv2Qg9/9ueW6AwQbjVbakSw+cXIW+PjOD9TERE2PDxQ+5z6bWkHEdr5CzJ7RudMJ1pBdZFiA346XKhUZnMJdkMQy7NLu3g3yk655/iPAzWPOaqh0mps3KPxpWfFQd2UtPPig94Fg+EgzwttxdHZVRWIeXG/JLTFBfJl+ZLcwM90UAxk0iGgSnFmonvB/x6kGYFj0aNzsZR+BRvl7SkxW+gZfwu3c27l/Ib7fl6WiiVaZrTPJq1As5xc4eIbXJhHxLHouXiqQl096NK4Nm5NvISFhOL6MCxK8bDGoQhAKg+ewMOgBYDlPBqZ7jV3+wzx9iuIBXqSeN1WumUrGEkc3y7BIaoFSv2btnNgkWiSjWufoICkgf1aPRSSbK+nmO94uaYQ9265A=
  file: build/app/outputs/apk/release/app-release.apk
  on:
    repo: jintangWang/my_app
    # 上面的是生成的，我们再添加上下面的配置
    # 只有给 commit 打上 tag 才会触发 部署
    tags: true
  # 防止上传的 apk 被删除
  skip_cleanup: true
```
**最后**: 提交一个打了 `tag` 的 `commit` （不然不会触发部署），`build` 成功之后会自动部署到 `github` 仓库的 [release](https://github.com/jintangWang/my_app/releases) 下。完整的例子就在我的这个[仓库](https://github.com/jintangWang/my_app)

## Gitlab CI

### Gitlab Runner
`Gitlab Runner` 用于跑我们的 `CI` 脚本并将结果返回给 `Gitlab` 。

这里我们选择使用 `docker` 作为我们的 `runner` 。你也可以选择其他 `runner` , 比如： `macOS` 本地、 `windows` 本地、 `linux` 本地 ... 具体可以看 [这儿](https://docs.gitlab.com/runner/)

#### 安装
我是 `macOS` 系统，用下面的步骤安装 `runner` 。其他系统可以查看 [官方文档](https://docs.gitlab.com/runner/install/docker.html)

- 首先要确保你本地有 `docker` 并启动。这儿不再赘述，我已经安装了。
- 运行 `gitlab-runner` 镜像生成容器，本地找不到此镜像会从网上下载。
    ``` bash
    docker run -d --name gitlab-runner --restart always \
    -v /Users/Shared/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest
    ```
    大概解释一下： 

    - `--name` 表示为这个容器指定名称，后面的 `gitlab-runner` 是我们设定的容器名称。
    - `-v` 表示挂载卷。
    - 最后面的 `gitlab/gitlab-runner:latest` 是下载的镜像名。
    
    更多 [docker 命令](https://www.runoob.com/docker/docker-command-manual.html) 请自行查阅。完成后可以通过 `docker ps` 看到正在运行的 `docker` 容器，里面有一个名称为 `gitlab-runner` 。

#### 注册
其他系统注册查看 [这儿](https://docs.gitlab.com/runner/register/index.html#docker)

> 注册用的 `url` 和 `token` 在 仓库—— `Settings` —— `CI/CD`下的 `Runners` —— `Specific Runners` 下可以看到，如图： ![runner-regist](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/runner-regist.png)

- 注册命令
    ``` bash
    docker run --rm -t -i -v /Users/Shared/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register
    ```
- 输入 `gitlab` 实例的 `url`
    ``` bash
    Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com )
    http://gitlab.ziggurat.cn/
    ```
- 输入 `token`
    ``` bash
    lease enter the gitlab-ci token for this runner
    xxx(上面图片中得到的 token )
    ```
- 填写描述 
    ``` bash
    Please enter the gitlab-ci description for this runner
    flutter build apk
    ```
- 填写 tag
    ``` bash
    Please enter the gitlab-ci tags for this runner (comma separated):
    flutter, apk
    ```
- 填写执行器
    ``` bash
    Please enter the executor: docker-ssh+machine, kubernetes, docker-ssh, virtualbox, docker+machine, ssh, docker, parallels, shell:
    docker
    ```
- 填写执行 `CI` 使用的 `docker` 镜像
    ``` bash
    Please enter the Docker image (eg. ruby:2.1):
    alpine:latest
    ```
    `alpine:latest` 是一个非常小的 `docker` 镜像，`linux` 系统。由于我们一般会在 `.gitlab-ci.yml` 中声明 `docker` 镜像，而且那个优先级比这儿的高。所以一般填写 `alpine:latest` 就行了
 
 这些步骤完成后就可以在上面图片的下面看到你注册成功的 `runner`， 如图： ![registed_runner](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/registed_runner.png)

> 我这儿只能使用 `Specific Runners` 。 我使用的 `gitlab` 实例是公司注册的，管理员可以通过设置为某个仓库打开 `Shared Runners`。个人在 `gitlab.com` 里开源项目可以直接使用 `Shared Runners` 

### `.gitlab-ci.yml`

在注册完 `runner` 后，我们需要在项目的根目录下创建一个文件 `.gitlab-ci.yml` 。 在里面编写将要在 `runner` 里面执行的命令，完成之后每次提交都会触发我们的 `CI` 脚本，在仓库的 `Pipelines` 下就可以看到我们正在跑的 `CI`。

这儿我们使用 `fastlane` 给 `flutter` 项目进行打包。 [fastlane](https://docs.fastlane.tools/) 是一个自动构建 `Android` 和 `iOS` app 的工具。由于本地打包 `iOS` 特别麻烦， 而 `fastlane` 针对两个平台有基本统一的简单操作，`flutter` 官方也推荐 [fastlane 部署](https://flutter.dev/docs/deployment/fastlane-cd)。So ， 你懂得...

 我的 `.gitlab-ci.yml` 中对于 `apk` 的打包只有简单的两句， 因为关于 `fastlane` 的配置文件与脚本我都已经在本地生成并上传了 [demo仓库](https://gitlab.com/jintangWang/test_fastlane) 里面，这儿只实现 `Andriod` 的无签名打包，感兴趣的可以看 [fastlane 相关文件](https://gitlab.com/jintangWang/test_fastlane/tree/master/android/fastlane)。

`.gitlab-ci.yml` :
``` yml
# 使用此镜像运行打包
image: cirrusci/flutter

stages:
  - build

before_script:
- export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

build-apk:
  stage: build
  script:
  - cd android
  # 该镜像已经包含了fastlane
  - fastlane android release
  # 要上传的包
  artifacts:
    name: "app-release-$CI_COMMIT_SHORT_SHA.apk"
    paths:
    - build/app/outputs/apk/release/app-release.apk
    expire_in: 1 week # 过期时间
```

### 完成
只要你有新的 `push` ， 在 `gitlab` 上就会触发 `pipeline` ， 如果正常通过，就应该是这样的： ![gitlab_result](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/gitlab_result.png)
由于 `.gitlab-ci.yml` 有部署命令，所以还可以下载打包好的 `apk`。 点击右侧的云朵图标就可以看到我们上传的 `artifact` 了，点击就可以下载了

### 常见问题

1. 新的提交之后没有触发 `pipeline` 
  如图，![runner_set_btn](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/runner_set_btn.png) 
  打开 `runner` 的设置页面， 检查一下是否设置了 **Run untagged jobs** ，我的是这样的：
  ![runner_set](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/runner_set.png)
2. The Job is stuck because you don’t have any active runners
  检查下本地运行的 `docker` 容器，正常是有两个，如图： ![runner_docker](https://tang-blog-1257996120.cos.ap-chengdu.myqcloud.com/ci/runner_docker.png)
  如果有多余的，删除掉并重启 `gitlab-runner` （这是我们前面注册 `runner` 时的容器名称）： 
  ``` bash
  docker restart gitlab-runner
  ```
3. ERROR: Uploading artifacts to coordinator... error
  在最后上传包的时候总是报这个错。在经过多次实验以后发现是我司注册的 `gitlab` 实例的问题，需要管理员设置允许的 `artifact` 大小，可以参考 [这儿](https://docs.gitlab.com/ee/user/admin_area/settings/continuous_integration.html)，我司应该有限制这个。 而我之前创建的仓库就在我司的 `gitlab` 实例上，所以导致我的 `artifact` 一直上传失败... 真是醉了...

  最后将 `demo` 转到了 https://gitlab.com , 重新提交，打包和部署都成功。自己也没重新注册 `runner` ，直接使用了 `Shared Runners` 。当然这个有点限制，对开源项目限制了 2000分钟/月。



**总结：** `CI` 是个好东西，可以做好多方便的东西，可以自动化部署博客啊等等。更多精彩，值得探索...