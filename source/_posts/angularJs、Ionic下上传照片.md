title: Ionic.AngularJs下上传照片
date: 2016-03-15 16:58:14
tags: angular
categories: angular
---
### 1.安装上传照片需要的插件
1.先新建一个ionic项目 
``` 
$ ionic start test tabs
```
2.安装插件 
```
$ cordova plugin add cordova-plugin-image-picker
$ cordova plugin add cordova-plugin-camera
```
> 我们的yongche项目之前使用的camera插件是org.apache.cordova.camera,此处更新为cordova-plugin-camera,目前老版本的还可以使用


3.添加android环境 
```
$ ionic platform add android

```
### 2.配置ng-cordova.js
``` html
//在index.html中cordova.js旁边引入ng-cordova.js
<script src="cordova.js"></script>
<script src="js/ng-cordova.js"></script>
```
``` javascript
//在app.js中注入ngCordova
angular.module('starter', ['ionic','ngCordova']).run(...)
```
### 3.代码实现
参考:[https://cordova.apache.org/docs/en/latest/cordova-plugin-camera/index.html](https://cordova.apache.org/docs/en/latest/cordova-plugin-camera/index.html)
<!-- more -->
1.controller代码:
- 照片被插件处理为base64编码
- 上传到处理照片的接口,返回照片的名称(这一步照片其实已经保存在了服务器)
- 将所有数据提交到接口,此时照片的字段为照片文件名
``` js
angular.module('starter.controllers', [])
.controller('TestCtrl', function($scope,$ionicActionSheet,$compile,$timeout,$ionicPopup,$window,uploadPictureService) {
    //此处有两个数组分别用来控制添加和删除照片的逻辑,这两个逻辑有冲突,所以要放两个数组
    var imageURIs= [];
    var finalImgUrls=[];

    //讲上传的照片动态编译到html上
    function showOnPage (imageURI) {
        imageURIs.push(imageURI);
        finalImgUrls.push(imageURI);//
        //所以还需要引入jquery
        jQuery(function() {
          var im = $('<div class="col col-33" style="position:relative" id="img_' + imageURIs.length + '"><span class="delected" ng-click="rmEleApp(' + imageURIs.length + ')" style="position:absolute;right:15px;top:-10px;font-size:18px;">x</span><img  ng-src="data:image/jpeg;base64,' + imageURI + '"  style="width:70px;height:70px;display:block;margin:0 auto;"  ng-click="scaleImg(' + finalImgUrls.length + ')" /></div>').prependTo('#img_up');
          $compile(im)($scope);
        });
    }

    // 点击弹出图片选择
  $scope.showImageUploadChoices = function(prop) {
    var hideSheet = $ionicActionSheet.show({
      buttons: [{
        text: '拍照上传'
      }, {
        text: '从相册中选'
      }],
      titleText: '图片上传',
      cancelText: '取 消',
      cancel: function() {},
      buttonClicked: function(index) {
        if (index == 0) { // 拍照上传
          uploadPictureService.taskPicture(prop).then(function(imageURI) {
              showOnPage(imageURI);
          }, function(err) {
            alert('wrong');
          });
        } else if (index == 1) { // 相册文件选择上传
          uploadPictureService.readalbum(prop).then(function(imageURI) {
            showOnPage(imageURI);
          }, function(err) {
            alert('wrong');
          });
        }
        return true;
      }
    });
  };
    
  //照片右上角的X号的触发事件
  $scope.rmEleApp = function(obj) {
    var myEl = angular.element(document.querySelector('#img_' + obj));
    myEl.remove();
    images.imageURIs[obj-1]='';
    if ($('#addPic').is(':hidden')) {//如果加号图片隐藏了,就显示
      $('#addPic').show();
    }
  }

  //点击图片放大
  $scope.scaleImg = function(index) {
    $ionicPopup.alert({
      template: '<img src=data:image/jpeg;base64,' + finalImgUrls[index - 1] + ' style=" display: block; margin: 0 auto;">',
      okText: '<span style="background:#fff;">x</span>'
    });
  }
/*上面的步骤将照片显示在了页面上,但并没有上传到接口-------------------*/

//上面的imageURL是用base64加密的很长很长的字串,所以需要另外一个接口单独处理下才可以上传到正式接口
})
```
2.公共配置上传照片的service与factory
``` js
angular.module('starter')
  .factory('Camera', function($q) {
    return {
        getPicture: function(options) {
            var q = $q.defer();
            navigator.camera.getPicture(function(result) {
                // Do any magic you need
                q.resolve(result);
            }, function(err) {
                q.reject(err);
            }, options);

            return q.promise;
        }
    }
})
.factory('uploadPictureService',function($http,$timeout,$compile,Camera,$cordovaImagePicker){
  return{
    // 读用户相册
    readalbum : function(prop) {
        var pictureSource;  //设定图片来源
          var destinationType; //选择返回数据的格式
          document.addEventListener("deviceready",onDeviceReady,false);
          // Cordova准备好了可以使用了
          function onDeviceReady() {
              pictureSource=navigator.camera.PictureSourceType;
              destinationType=navigator.camera.DestinationType;
              encodingType = navigator.camera.EncodingType.JPEG;
              sourceType=pictureSource.SAVEDPHOTOALBUM;
          }
        var options = {
          // maximumImagesCount: 9,
          quality: 80,
          targetWidth: 400,
          targetHeight: 400,
          saveToPhotoAlbum: false,
          destinationType: destinationType.DATA_URL,
          encodingType: encodingType,
          sourceType: sourceType
        };
        return Camera.getPicture(options);
         // return $cordovaImagePicker.getPictures(options);
         // $cordovaImagePicker.getPictures(options)
         //    .then(function (results) {
         //      for (var i = 0; i < results.length; i++) {
         //        console.log('Image URI: ' + results[i]);
         //      }
         //    }, function(error) {
         //      // error getting photos
         //    });

    },

    // 拍照
    taskPicture : function(prop) {
        if (!navigator.camera) {
          window.plugins.toast.show('请在真机环境中使用拍照上传。', 'short', 'center');
          return;
        }
        var pictureSource;  //设定图片来源
          var destinationType; //选择返回数据的格式
          document.addEventListener("deviceready",onDeviceReady,false);
          // Cordova准备好了可以使用了
          function onDeviceReady() {
              pictureSource=navigator.camera.PictureSourceType;
              destinationType=navigator.camera.DestinationType;
              encodingType = navigator.camera.EncodingType.JPEG;
              // sourceType=pictureSource.SAVEDPHOTOALBUM;
          }
        var options = {
          quality: 80,
          targetWidth: 400,
          targetHeight: 400,
          saveToPhotoAlbum: false,
          destinationType: destinationType.DATA_URL,
          encodingType: encodingType,
        };
        return Camera.getPicture(options);
    }
  }

})
```
大功告成!