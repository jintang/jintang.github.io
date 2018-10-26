title: 用truffle框架开发部署以太坊DAPP
date: 2018-10-11 21:33:11
tags:
- DAPP
categories: 区块链
---
> 参考链接：[ETHEREUM PET SHOP -- YOUR FIRST DAPP](https://truffleframework.com/tutorials/pet-shop)

## 开发环境
- [Truffle](https://truffleframework.com): 以太坊Solidity编程语言开发框架。安装： 
    ``` 
    $ npm install -g truffle
    ```
- [Ganache](https://truffleframework.com/ganache): 前身testRPC，可以启动一个个人的以太坊私有链用作测试、执行命令、检测区块执行状态。点击前面的连接下载客户端即可。

## 初始化项目
1. 建立项目目录
``` bash
mkdir pet-shop && cd pet-shop
```
2. 使用 `truffle unbox` 创建项目
``` bash
truffle unbox pet-shop
# Downloading...
# Unpacking...
# Setting up...
# Unbox successful. Sweet!
```
*注:* 我们可以使用 `truffle unbox <box-name>` 下载任意的 Truffle Boxes。 在 [truffle box 仓库](https://truffleframework.com/boxes) 可以看到很多 Box , 上面我们下载的是 [pet-shop box](https://truffleframework.com/boxes/pet-shop)

下载完成后,可以看到下面这些重要的目录和文件：

- contracts/ 智能合约的文件夹，所有的智能合约文件都放置在这里，里面包含一个重要的合约Migrations.sol
- migrations/ 用来处理部署（迁移）智能合约 ，迁移是一个额外特别的合约用来保存合约的变化。
- test/ 智能合约测试用例文件夹
- truffle.js 配置文件

<!-- more -->
## 编写智能合约

在contracts目录下，添加合约文件Adoption.sol

``` js
pragma solidity ^0.4.17;

contract Adoption {

  address[16] public adopters;  // 保存领养者的地址

    // 领养宠物
  function adopt(uint petId) public returns (uint) {
    require(petId >= 0 && petId <= 15);  // 确保id在数组长度内

    adopters[petId] = msg.sender;        // msg.sender 表示调用此方法的人或者智能合约
    return petId;
  }

  // 返回领养者
  function getAdopters() public view returns (address[16]) {
    return adopters;
  }

}
```

## 编译部署智能合约
在项目根目录下：

**编译：**
``` bash 
truffle compile
# Compiling ./contracts/Adoption.sol...
# Writing artifacts to ./build/contracts
```
**部署**:

在 migrations 文件夹下已经有一个 `1_initial_migration.js` 部署脚本，用来部署 `Migrations.sol` 合约。

`Migrations.sol` 用来确保不会部署相同的合约。

我们来创建一个自己的部署脚本 `2_deploy_contracts.js`
``` js 
var Adoption = artifacts.require("Adoption");

module.exports = function(deployer) {
  deployer.deploy(Adoption);
};
```
在执行部署之前，需要确保有一个区块链运行, 可以使用 Ganache 来开启一个私链。 Ganache 启动之后默认会在 7545 端口上运行一个开发链，然后执行下面的命令将合约部署到链上：

``` bash
truffle  migrate
# Using network 'development'.

# Running migration: 1_initial_migration.js
#  Deploying Migrations...
#  ... 0xcc1a5aea7c0a8257ba3ae366b83af2d257d73a5772e84393b0576065bf24aedf
#  Migrations: 0x8cdaf0cd259887258bc13a92c0a6da92698644c0
# Saving successful migration to network...
#  ... 0xd7bc86d31bee32fa3988f1c1eabce403a1b5d570340a3a9cdba53a472ee8c956
# Saving artifacts...
# Running migration: 2_deploy_contracts.js
#  Deploying Adoption...
#  ... 0x43b6a6888c90c38568d4f9ea494b9e2a22f55e506a8197938fb1bb6e5eaa5d34
#  Adoption: 0x345ca3e014aaf5dca488057592ee47305d9b3e10
# Saving successful migration to network...
#  ... 0xf36163615f41ef7ed8f4a8f192149a0bf633fe1a2398ce001bf44c43dc7bdda0
# Saving artifacts...
```

在打开的Ganache里可以看到区块链状态的变化，现在产生了4个区块。并且发现账号下刚开始的 100 个 `eth` 少了 零点几 个

这时说明已经智能合约已经部署好了。

## 创建用户接口和智能合约交互
我们已经编写和部署及测试好了我们的合约，接下我们为合约编写UI，让合约真正可以用起来。

在Truffle Box `pet-shop`里，已经包含了应用的前端代码，代码在 `src/` 文件夹下。

修改 `src/js/app.js` 部分代码：

### 初始化 [web3](https://github.com/ethereum/web3.js) 实例，修改 `initWeb3()` 为：
``` js
initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
    } else {
        // If no injected web3 instance is detected, fall back to Ganache
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
}
```
### 实例化合约，修改 `initContract()` 为：
``` js
initContract: function() {
    $.getJSON('Adoption.json', function(data) {
        // Get the necessary contract artifact file and instantiate it with truffle-contract
        var AdoptionArtifact = data;
        // 通过 truffle-contract.js 创建与我们交互的合约实例
        App.contracts.Adoption = TruffleContract(AdoptionArtifact);
        
        // Set the provider for our contract
        App.contracts.Adoption.setProvider(App.web3Provider);
        
        // Use our contract to retrieve and mark the adopted pets
        return App.markAdopted();
    });
    return App.bindEvents();
}
```
*说明：* Artifacts 是关于合约的信息。比如部署地址和 ABI(Application Binary Interface)。ABI 是一个 js 对象，定义了如何与智能合约交互
### 处理领养

修改 `markAdopted()` 为：
``` js
markAdopted: function(adopters, account) {
    var adoptionInstance;

    App.contracts.Adoption.deployed().then(function(instance) {
        adoptionInstance = instance;

        // 调用合约的getAdopters(), 用call读取链上的信息不用消耗gas
        return adoptionInstance.getAdopters.call();
    }).then(function(adopters) {
        for (i = 0; i < adopters.length; i++) {
            // 如果宠物已经被收养了，不允许重复收养
            if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
                $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
            }
        }
    }).catch(function(err) {
        console.log(err.message);
    });
}
```
修改 `handleAdopt()` 为：
``` js
handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    var adoptionInstance;

    // 获取用户账号
    web3.eth.getAccounts(function(error, accounts) {
        if (error) {
            console.log(error);
        }
    
        var account = accounts[0];
    
        App.contracts.Adoption.deployed().then(function(instance) {
            adoptionInstance = instance;
        
            // 调用 Adoption.sol 里的 adopt 方法发起领养宠物交易
            return adoptionInstance.adopt(petId, {from: account});
        }).then(function(result) {
            return App.markAdopted();
        }).catch(function(err) {
            console.log(err.message);
        });
    });
}
```
*注：* 收养宠物是一个交易而不是 call ,交易需要支付 `gas` 。 `gas` 是智能合约计算和存储数据需要付出的费用，和 `eth` 之间有一个换算方法。

## 在浏览器中运行

### 安装 MetaMask
MetaMask 是一款浏览器插件形式的以太坊轻客户端，允许你不下载整个以太坊节点而在浏览器中运行以太坊的 DAPP 
### 配置钱包
我们通过还原一个Ganache为我们创建好的钱包，作为我们的开发测试钱包。
打开 MetaMask ，选择 **Import using account seed phrase**, 输入Ganache显示的助记词。
我的是： 
```
heavy best inner hobby chef bread entry oyster dose float napkin media
```
配置密码之后即可看到账号，里面有 100 个初始 `eth`
### 连接开发区块链网络
在 MetaMask 的 Networks 里选择 **Custom RPC** , 添加一个网络：http://127.0.0.1:7545 即可。

### 启动服务
Truffle Box `pet-shop` 里人家提供了一个服务: lite-server。

`bs-config.json` 指示了lite-server的工作目录。
``` json
{
  "server": {
    "baseDir": ["./src", "./build/contracts"]
  }
}
```
./src 是网站文件目录

./build/contracts 是合约输出目录

在 `package.json` 中已配置了：
``` json
"scripts": {
  "dev": "lite-server",
  "test": "echo \"Error: no test specified\" && exit 1"
}
```

我们只需要运行：
``` bash
npm run dev
```

然后就可以在 [http://localhost:3000/](http://localhost:3000/) 访问到此 DAPP 了。如果你收养了宠物，也会在 MetaMask 与 Ganache 中显示你账号的交易信息

**Over**