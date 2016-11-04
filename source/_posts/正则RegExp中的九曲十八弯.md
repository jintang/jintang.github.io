title: 正则RegExp中的九曲十八弯
date: 2016-10-25 18:01:23
tags: 
- 正则
categories: js
---
>很多知识都是有许多不被注意的细节，一不小心就会拐错了弯，翻了车。今天说几个正则需要注意的地方。   

### 正则和string常用的方法
#### 正则表达式验证字符串的方法
1. `reg.exec(string)`:
    - 如果执行exec方法的正则表达式没有分组（没有括号括起来的内容），那么如果有匹配，他将返回一个只有一个元素的数组(不论正则是否有标志g)，这个数组唯一的元素就是该正则表达式匹配的第一个串;如果没有匹配则返回null
    - exec如果找到了匹配，而且包含分组的话，返回的数组将包含多个元素，第一个元素是找到的匹配，之后的元素依次为该匹配中的第一、第二...个分组
2. `reg.test(string)`: 返回的是true和false。  

#### 字符串验证正则的方法
1. `string.match(reg/str)`:
    - 参数为reg时返回符合正则的子串，但是被封装在数组里;不同于`reg.exec()`，如果正则带有标志g,且有多个匹配的子串，会返回有多个元素的数组。
    - 参数为str时若包含返回该str，不包含时返回null
2. `string.replace(reg/str,replacement)`:将字符串  满足reg的子串/指定的str  替换为replacement，返回值为替换后的结果，原变量不变
3. `string.search(reg)`:作用类似于`string.indexOf()`,返回符合正则的起始下标，如果没找到也为-1

### RegExp静态属性
`$1...$9`:每当产生一个带括号的成功匹配时，$1...$9 属性的值就被修改。可以在一个正则表达式模式中指定任意多个带括号的子匹配，但只能存储最新的九个。  
**Note:**  
* 这些属性是RegExp的静态属性，而非RegExp实例的属性。
* 这些属性是全局的，只要对正则有影响，就会改变这几个属性的值  

<!-- more -->

### RegExp 对象中需要注意的属性：`lastIndex`
这是一个例子：
``` javascript
var reg=/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g;
//$1...$9对应的是带括号的正则匹配的值中最近的第1-9个
var Arr=['192.168.1.1','192.168.1.2'];
for (var j=0;j<Arr.length;j++){
    //每次匹配时lastIndex会更新为匹配子串结束时的index+1，此处为11
    reg.lastIndex=0;
    if(!reg.test(Arr[j])){
        //若不将lastIndex重新设为0，明明符合正则的字串却会进入此步骤，就会出错
        result=false;
    }else{
        if( RegExp.$1 >=256 || RegExp.$2>=256 || RegExp.$3>=256 || RegExp.$4>=256){
            result = false;
        }
    }
}
```
这是`RegExp`对象`$1...$9`值的变化：  
![$1...$9的值](http://7xphbb.com1.z0.glb.clouddn.com/regExp1.png)![$1...$9的值](http://7xphbb.com1.z0.glb.clouddn.com/regExp2.png)  
可以看到，每次循环`$1...$4`是新匹配的4个  
附上[trigkit4](https://segmentfault.com/u/trigkit4)的正则表达式思维导图一张：  
![正则思维导图](http://7xphbb.com1.z0.glb.clouddn.com/repExp%E6%80%9D%E7%BB%B4%E5%AF%BC%E5%9B%BE.gif)
