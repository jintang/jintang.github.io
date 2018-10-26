title: 开发部署以太坊DAPP
date: 2018-10-26 14:35:24
tags: 
- DAPP
categories: 区块链
---
> 参考链接： [Web3与智能合约交互实战](https://learnblockchain.cn/2018/04/15/web3-html/)

**DApp** 是 **Decentralized Application** 的简称，及去中心化应用。DAPP 由客户端和合约端配合实现。
我们使用 [Solidity](https://solidity-cn.readthedocs.io/zh/develop/solidity-in-depth.html) 语言编写完合约后，之前我们使用了 `geth` 与之交互， 而这种命令行的方式太过繁琐，所以我们这儿用到了 `Web3.js`。

**Web3.js** 是以太坊官方的Javascript API，可以帮助智能合约开发者使用HTTP或者IPC与本地的或者远程的以太坊节点交互。实际上就是一个库的集合，主要包括下面几个库：
- web3-eth 用来与以太坊区块链和智能合约交互
- web3-shh 用来控制whisper协议与p2p通信以及广播
- web3-bzz 用来与swarm协议交互
- web3-utils 包含了一些Dapp开发有用的功能

这儿我们主要用到了 `web3-eth`。下面开始

## 使用 ganache 生成一条私有链
ganache 是一个可以一键搭建以太坊区块链测试环境的工具。 启动之后默认会生成 10 个账号， 我们的私有链默认运行在 [http://127.0.0.1:7545](http://127.0.0.1:7545)上。
<!-- more -->
## 编写合约
我们使用在线的 [Remix IDE](http://remix.ethereum.org/#optimize=true&version=soljson-v0.4.25+commit.59dbf8f1.js) 来编写代码。

*InfoContract.sol*:
``` js
pragma solidity ^0.4.21;

contract InfoContract {
    
  string fName;
  uint age;
   
  function setInfo(string _fName, uint _age) public {
    fName = _fName;
    age = _age;
    emit Instructor(_fName, _age);
  }
   
  function getInfo() public constant returns (string, uint) {
    return (fName, age);
  }   
   
  event Instructor(
    string name,
    uint age
  );
}
```
代码很简单，就是简单的给name和age变量赋值与读取。 并在赋值的时候触发了一个 Instructor 事件。

[Solidity](https://solidity-cn.readthedocs.io/zh/develop/solidity-in-depth.html) 里有很多高级的用法，你还可以给事件添加过滤器...这儿只用了最简单的。
## 编译与部署合约
### 编译
选择 `Start to compile`， 编译成功会出现绿色的合约名称，失败则提示相应的错误信息。
### 部署
切换到 run 的 tab 下，将 Environment 切换成 `Web3 Provider`，并输入我们的测试链的地址 [http://127.0.0.1:7545](http://127.0.0.1:7545), Environment 选项的含义为：

- **Javascript VM** ：简单的Javascript虚拟机环境，纯粹练习智能合约编写的时候可以选择
- **Injected Web3** ：连接到嵌入到页面的Web3，比如连接到MetaMask
- **Web3 Provider** ：连接到自定义的节点，如私有的测试网络。

然后选择 `Deploy` ,成功后会在 `Deployed Contracts` 下显示部署成功的合约。并且在 **Remix IDE** 终端下显示合约创建的交易信息。同时，在 ganache 中也生成了对应的区块和交易信息。

## 编写客户端
为了与合约交互，我们使用 `web3.js` 。

### 新建项目并安装 web3.js
``` bash
mkdir simple-DAPP && cd simple-DAPP
npm init
npm install web3 -D
```
### 构建页面与交互逻辑
页面、样式省略，下面说下 js 中需要注意的部分。

1. 创建 web3 :
``` js
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));
}
```
上面是 web3 官方的创建方法，本例中的 web3 是通过 [http://localhost:7545](http://localhost:7545) 创建的。而如果你使用类似 `MetaMask` （一个 Chrome 上的插件，迷你型以太坊钱包）这样的软件，provider 就会被自动植入。

2. 绑定账号：
``` js
web3.eth.defaultAccount = web3.eth.accounts[0]; // ganache生成的10个账号中随便取一个作为默认账号
```
3. 通过 ABI 创建一个Solidity的合约对象，用来在某个地址上初始化合约
`Application Binary Interface(ABI)` 是从区块链外部与合约进行交互以及合约与合约间进行交互的一种标准方式。事实上， `Solidity` 里的合约的含义就是它的 函数 和 数据（它的 状态 ），它们位于以太坊区块链的一个特定地址上。
``` js
// abi 通过 Remix IDE 的 compile 面板下 ABI 按钮复制
let infoContract = web3.eth.contract(abi);
```
这是此合约生成的 ABI :
``` json
[
	{
		"constant": false,
		"inputs": [
			{
				"name": "_fName",
				"type": "string"
			},
			{
				"name": "_age",
				"type": "uint256"
			}
		],
		"name": "setInfo",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "name",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "age",
				"type": "uint256"
			}
		],
		"name": "Instructor",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getInfo",
		"outputs": [
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
```
可以看到这是对合约里函数的描述。此合约里没有状态，

4. 通过合约地址获取合约实例
``` js
// 合约地址 在 Remix IDE 的 run 面板 —— Deployed Contracts 下
let info = infoContract.at('合约地址');
```
然后就可以使用合约里的函数和事件了，详细查看 [demo](https://github.com/jintangWang/simple-DAPP/blob/master/main.js) 

**至此：** `DAPP` 的 客户端 编写完成。

## 使用
我通过 webpack 启动了客户端，每次点击 `Update Info` 按钮都会生成一条交易。
![dapp_transcation](https://www.tu260.com/upload/477427dae0d2cbf39a8db5aef0bfd0db.png)
交易可以看作是从一个帐户发送到另一个帐户的消息。它能包含一个二进制数据（合约负载）和以太币。如果目标账户含有代码，此代码会被执行，并以 payload 作为入参。如果目标账户是零账户（账户地址为 0 )，此交易将创建一个 新合约 。 如前文所述，合约的地址不是零地址，而是通过合约创建者的地址和从该地址发出过的交易数量计算得到的（所谓的“nonce”）

*说明：* 一经创建，每笔交易都收取一定数量的 gas 。无论执行到什么位置，一旦 gas 被耗尽（比如降为负值），将会触发一个 `out-of-gas` 异常。当前调用帧（call frame）所做的所有状态修改都将被回滚。

## 总结
可以用下图来描述 `DAPP` 的原理。
![DAPP_theory](https://www.tu260.com/upload/22e196def75b0414ccc5ab620f640d7b.png)
我们的 demo 完成了 客户端 和 合约端。