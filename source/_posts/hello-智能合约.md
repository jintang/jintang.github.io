title: hello 智能合约
date: 2018-08-03 01:46:20
tags:
categories:
---

> 欢迎查看 跟着大佬一起动手系列，点击[这儿](https://learnblockchain.cn/2017/11/24/init-env/)查看大佬的博文

## 什么是智能合约
**以太坊上的程序称之为智能合约，它是代码和数据(状态)的集合。**

如果做比喻的话智能合约更像是JAVA程序，JAVA程序通过JAVA虚拟机（JVM）将代码解释字节进行执行，以太坊的智能合约通过以太坊虚拟机（EVM）解释成字节码进行执行。

智能合约可以理解为在区块链上可以自动执行的（由消息驱动的）、以代码形式编写的合同（特殊的交易）。

比特币的交易是可以编程的，但是比特币脚本有很多的限制，能够编写的程序也有限，而以太坊具有 [图灵完备](https://zh.wikipedia.org/wiki/%E5%9C%96%E9%9D%88%E5%AE%8C%E5%82%99%E6%80%A7)，通俗来说可以完全模拟一台计算机所能做的所有事情。比特币可以执行一些简单脚本，但是他就不是图灵完备，比如循环指令比特币就无法执行。

## 编程语言
用户不可能直接编写以太坊虚拟机（EVM）字节码，所以以太坊提供了几种编写智能合约的高级语言。

Solidity：类似JavaScript，这是以太坊推荐的旗舰语言，也是最流行的智能合约语言。具体用法参加Solidity文档，地址：https://solidity.readthedocs.io/en/latest/

> 还有Viper，Serpent，LLL及Bamboo，建议大家还是使用Solidity。Serpent官方已经不再推荐，建议Serpent的用户转换到Viper，他们都是类Python语言。

可以根据不同的习惯选择不同的高级语言，目前最流行的是Solidity。

我们下面使用 [Browser-Solidity](https://ethereum.github.io/browser-solidity/) IDE （也就是 Remix ）进行合约的编写和编译

<!-- more -->

## 环境搭建
### 以太坊客户端： geth 安装
在这儿我们使用 Geth ，全称是 go-ethereum，是以太坊的 go 语言命令行客户端，也是最流行的客户端 —— [geth官方安装指引](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum) 。

Geth提供了一个交互式命令控制台，通过命令控制台中包含了以太坊的各种功能（API）。拥有账户管理、挖矿、转账、智能合约的部署和执行等等功能。其中，EVM就是由以太坊客户端提供的。

> 相对于Geth，Mist则是图形化操作界面的以太坊客户端。

### 使用geth启动环境
> 智能合约的开发需要使用以太坊的资源，所以是需要付费的，这个费用表现为 以太币。下面我们用 geth 启动开发者网络（模式）,会自动分配一个有大量余额的开发者账户给我们使用。

``` bash
geth --datadir testNet --dev console 2>> test.log
```
参数解析，更多请查看[这儿](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options):

- `–dev` 启用开发者网络（模式），开发者网络会使用POA共识，默认预分配一个开发者账户并且会自动开启挖矿。
- `–datadir` 后面的参数是区块数据及秘钥存放目录。
第一次输入命令后，它会放在当前目录下新建一个testNet目录来存放数据。
- `console` 进入控制台
- `2>> test.log` 表示把控制台日志输出到test.log文件

为了更好的理解，建议新开一个命令行终端，实时显示日志：

``` bash
tail -f test.log
```

### 准备账户
智能合约的部署是指把合约字节码发布到区块链上，并使用一个特定的地址来标示这个合约，这个地址称为合约账户。

> 以太坊中有两类账户：
>   - 外部账户：该类账户被私钥控制（由人控制），没有关联任何代码。
>   - 合约账户: 该类账户被它们的合约代码控制且有代码与之关联。


> **外部账户与合约账户的区别和关系：** 
>
> 一个外部账户可以通过创建和用自己的私钥来对交易进行签名，来发送消息给另一个外部账户或合约账户。在两个外部账户之间传送消息是价值转移的过程。  
>
> 但从外部账户到合约账户的消息会激活合约账户的代码，允许它执行各种动作（比如转移代币，写入内部存储，挖出一个新代币，执行一些运算，创建一个新的合约等等）。
>
> 只有当外部账户发出指令时，合同账户才会执行相应的操作。

智能合约的部署是指把合约字节码发布到区块链上，并使用一个特定的地址来标示这个合约，这个地址称为合约账户。

部署智能合约需要一个外部账户，我们先来看看分配的开发者账户，这个开发者账户里有充足的以太币。

*查看账户:*
``` bash
> eth.accounts
# ["0x231b0a1ce4258e708cec69831f89d752822e25aa"] 返回了分配的开发者账户
```
*查看账户余额：*
``` bash
> eth.getBalance(eth.accounts[0])
# 1.15792089237316195423570985008687907853269984665640564039457584007913129639927e+77 数字非常大
```
开发者账户因余额太多，如果用这个账户来部署合约时会无法看到余额变化，为了更好的体验完整的过程，这里选择创建一个新的账户。

*创建账户:*
``` bash
> personal.newAccount("tang")
# 返回了新的账号 "0x44e805ccb02b8c14e41d1e166e46d7b615c911ca"， tang 是账号密码
> eth.accounts
# ["0x231b0a1ce4258e708cec69831f89d752822e25aa", "0x44e805ccb02b8c14e41d1e166e46d7b615c911ca"] 多了一个
> eth.getBalance(eth.accounts[1])
# 0 查看的是第二个账号的余额
```

*给新账号转账:*  转 1 ether 以太币, ether 是 以太币 的单位，以太币的最小单位是 wei ，详情查看 [这儿](https://github.com/ethereum/wiki/wiki/JavaScript-API#web3towei)
``` bash
> eth.sendTransaction({from: '0x231b0a1ce4258e708cec69831f89d752822e25aa', to: '0x44e805ccb02b8c14e41d1e166e46d7b615c911ca', value: web3.toWei(1, "ether")})
# "0xf7953104df919ca3d44f262ed291c1a19a82ad34469af6bd4e2a1b7357d93a4f"
> eth.getBalance(eth.accounts[1])
# 1000000000000000000
```
*解锁账户:* 在部署合约前需要先解锁账户（就像银行转账要输入密码一样）
``` bash
> personal.unlockAccount(eth.accounts[1],"tang", 0);
# true  第二个参数是对应账号的密码
```

## 编写、编译、部署 合约代码
*solidity代码如下:*
``` js
pragma solidity ^0.4.18;
contract hello {
    string greeting;
    
    function hello(string _greeting) public {
        greeting = _greeting;
    }

    function say() constant public returns (string) {
        return greeting;
    }
}
```
我们定义了一个名为hello的合约，在合约初始化时保存了一个字符串（我们会传入hello world），每次调用say返回字符串。

把这段代码写(拷贝)到 [Browser-Solidity](https://ethereum.github.io/browser-solidity/)，Browser-Solidity 要选中 `Auto Compile` 。如果没有错误，说明编译成功。点击Details获取部署代码（警告可以不理）。

在弹出的对话框中找到WEB3DEPLOY部分，点拷贝，粘贴到随便的一个编辑器后，修改初始化字符串为hello world。最后结果为：
``` js
var _greeting = "hello world" ;
// Creates a contract object
var helloContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"say","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);
// deploy new contract
var hello = helloContract.new(
   _greeting, // constructorParam, 可存在多个
   {
     from: web3.eth.accounts[1],  // 部署账号
     data: '0x608060405234801561001057600080fd5b5060405161027c38038061027c83398101604052805101805161003a906000906020840190610041565b50506100dc565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061008257805160ff19168380011785556100af565b828001600101855582156100af579182015b828111156100af578251825591602001919060010190610094565b506100bb9291506100bf565b5090565b6100d991905b808211156100bb57600081556001016100c5565b90565b610191806100eb6000396000f3006080604052600436106100405763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663954ab4b28114610045575b600080fd5b34801561005157600080fd5b5061005a6100cf565b6040805160208082528351818301528351919283929083019185019080838360005b8381101561009457818101518382015260200161007c565b50505050905090810190601f1680156100c15780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60008054604080516020601f600260001961010060018816150201909516949094049384018190048102820181019092528281526060939092909183018282801561015b5780601f106101305761010080835404028352916020019161015b565b820191906000526020600020905b81548152906001019060200180831161013e57829003601f168201915b50505050509050905600a165627a7a7230582095d42238dd45ab5b9cf241235d3dbba2dae94a09053bc96b0935ed98ac9a4ec10029',  // 合约编译后的字节码
     gas: '4700000' // 以太坊用 gas 计算要智能合约需要的以太币
   }, function (e, contract){ // 部署后的回调函数
    // NOTE: The callback will fire twice!
    // Once the contract has the transactionHash property set and once its deployed on an address.
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })
```
`eth.contract` ：[api说明](https://solidity.readthedocs.io/en/develop/abi-spec.html)

> 需要修改的地方：
> - 第1行：修改字符串为 hello world
> - 第6行：修改部署账户为新账户索引，即使用新账户来部署合约。

然后一行一行拷贝到 geth 中执行。出现以下类似 log 说明 **部署成功**。
``` bash
Contract mined! address: 0x8500c68000dbbebea6d5673d28927b28b9470854 transactionHash: 0x16c8aa6129693edaf22b43fd043748857d05511251f65b5e9f9faf8355b95656
> eth.getBalance(eth.accounts[1])
# 查看账号余额，发现变少了
```
同时也可以在日志中看到挖矿记录等
![mine-log](http://7xphbb.com1.z0.glb.clouddn.com/mine-log.png)
## 运行合约
``` bash
> hello.say()
# hello world
```
不知道为什么公司的电脑运行成功了，而家里的电脑却报错了 `TypeError: 'say' is not a function`，明明合约创建成功了。

跟上面截图的最底部的 error: `waiting for transactions` 没关系，公司的电脑上也有这行日志。