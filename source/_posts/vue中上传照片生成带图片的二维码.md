title: vue中上传照片生成带图片的二维码
date: 2017-04-13 13:33:01
tags: 
- vue
categories: 前端
---
本例使用了：

- [qart.js](https://github.com/kciter/qart.js)：Generate artistic QR code
- [canvas](http://javascript.ruanyifeng.com/htmlapi/canvas.html#toc5)

### 上传照片
利用`<input type="file">`的`change`事件  
html部分:
``` html
<input type="file" @change="fileChange">
<img :src="originImg" alt="origin" >
```
js部分:
``` js
import QArt from 'qartjs';
export default {
    methods:{
        fileChange(event){
            let files = event.target.files;
            let file = files[0];
            if(!file.type.match('image.*')){
                alert('请选择照片');
                return;
            }
            let reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => {
                this.generateQRcode(reader.result);
            }
        },
        generateQRcode(base64Img){
            this.originImg = base64Img;
            new QArt({
              value: 'www.baidu.com',
              imagePath: base64Img,
              filter: 'color',
              size: 195
            }).make(this.$refs.result);
        }
    }
}
```
<!-- more -->
### 下载二维码
利用`canvas`生成图片，让现代浏览器直接输出`image/octet-stream`实现图片自动弹出下载功能  
html部分：  
``` html
<div class="resultImg" ref="result"></div>
<div>
    <el-button type="primary" @click="download">下载二维码</el-button>
</div>
```
js部分：  
``` js
export default {
    methods:{
        download(){
            let resultCanvas = this.$refs.result.children[0];
            let type = "image/png";
            let image = resultCanvas.toDataURL(type).replace(type, "image/octet-stream");
            window.location.href = image;
        }
    }
}
```

##### 最后附上demo和源代码：  
**[demo](https://jintangwang.github.io/hello-vue/#/comment)**  
**[源代码](https://github.com/jintangWang/hello-vue/blob/master/src/components/comment/comment.vue)**