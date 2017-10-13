<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.open.eac.core.config.ServerConfig"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
  <meta http-equiv="X-UA-Compatible" content="chrome=1">
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
  <link rel="stylesheet" href="https://cache.amap.com/lbs/static/main.css"/>
  <script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=这是密钥，对于一个细心的人来说，是不会留下这些的，哈哈"></script>
  <style type="text/css">
    body {
        font-size: 12px;
    }
    #tip {
        background-color: #ddf;
        color: #333;
        border: 1px solid silver;
        box-shadow: 3px 4px 3px 0px silver;
        position: absolute;
        top: 10px;
        right: 10px;
        border-radius: 5px;
        overflow: hidden;
        line-height: 20px;
    }
    #tip input[type="text"] {
        height: 25px;
        border: 0;
        padding-left: 5px;
        width: 280px;
        border-radius: 3px;
        outline: none;
    }
  </style>
  <title>选择地图</title>
  <ui:Include tags="artDialog,zTree"></ui:Include>
  <script type="text/javascript" src="js/shangban.js"></script>
</head>
<body>
  <div id="mapContainer" style="
    border: 1px solid #ccc;
    height: 90%;
  "></div>
  <div id="tip">
    <input type="text" id="keyword" name="keyword" value="请输入关键字：(选定后搜索)" onfocus='this.value=""'/>
    <!-- <input type="button" class="button" value="删除多个点标记" id="clearMarker"/> -->
  </div>
  <script type="text/javascript">
    var windowsArr = [];
    var marker = [];
    var isAddValue = getUrlParam('isAddFlag');
    var centerValue = [113.23, 23.16]
    if (isAddValue==1) {
        centerValue = [113.23, 23.16]
    } else if(isAddValue==0){
        // 修改，更具修改的经纬度来传
        centerValue = []
        var mapLocalData = JSON.parse(localStorage.getItem("lnlaAddr"))
        var a = Number(mapLocalData[0])
        var b = Number(mapLocalData[1])
        centerValue.push(a)
        centerValue.push(b)
    }
    var map = new AMap.Map("mapContainer", {
            resizeEnable: true,
            center: centerValue,//地图中心点
            zoom: 13,//地图显示的缩放级别
            keyboardEnable: false
    });
    
    AMap.plugin(['AMap.Autocomplete','AMap.PlaceSearch', 'AMap.Geocoder'],function(){
        var markrr = new AMap.Marker({
          map:map,
          bubble:true
        })
        var autoOptions = {
            city: "广州", //城市，默认全国
            input: "keyword"//使用联想输入的input的id
          };
        autocomplete= new AMap.Autocomplete(autoOptions);
        var placeSearch = new AMap.PlaceSearch({
            city:'广州',
            map:map
        })
        var markerArr = new Array()
        AMap.event.addListener(autocomplete, "select", function(e){
        placeSearch.setCity(e.poi.adcode);
        placeSearch.search(e.poi.name, function(status,result){
         })
      });
                    // 点击覆盖物，选择数据
                    placeSearch.on('markerClick', function(e){
                        var clickMarkerData = []
                        clickMarkerData.push(e.event.lnglat.lng)
                        clickMarkerData.push(e.event.lnglat.lat)
                        saveInfo = clickMarkerData
                        saveName = e.data.name
                        console.log('点击覆盖物', e, clickMarkerData, saveInfo)
                    })


        var geocoder = new AMap.Geocoder({
            city: "广州"//城市，默认：“全国”
        });
                    // 点击地图的时候
                    map.on('click',function(e){
                        var dataLng = e.lnglat.getLng();
                        var dataLat = e.lnglat.getLat()
                        console.log('jingdu, weidu', dataLng, dataLat)
                        markrr.setPosition(e.lnglat);
                        var _this = this
                        geocoder.getAddress(e.lnglat,function(status,result){
                          if(status=='complete'){
                            // placeSearch.clear()
                            var clickMapData = []
                            clickMapData.push(dataLng);
                            clickMapData.push(dataLat)
                            saveInfo = clickMapData
                            saveName = result.regeocode.formattedAddress;
                            console.log("查询到的结果", result, dataLng, dataLat, saveInfo, saveName)
                          }
                        })
                    })
    });
                    // 取消
                    function closeDialogFun(){
                        var mapCloseLocalData = JSON.parse(localStorage.getItem("lnlaAddr"))
                        if (isAddValue==0) {
                            xianshiName = mapCloseLocalData[2]
                        }
                        parent.art.dialog.get("addChannel").close();
                    }
                    // 保存
                    function saveFunction(){
                        if (saveName=='' || saveName==null) {
                            dialogUtil.alert('请点击地图，选择地址<br />或点击[取消]关闭此弹窗')
                            return;
                        }
                        console.log('保存数据', saveInfo, saveName)
                        saveData = saveInfo
                        xianshiName = saveName
                        var newArr = []
                        newArr.push(saveData[0])
                        newArr.push(saveData[1])
                        newArr.push(saveName)
                        newArr = JSON.stringify(newArr)
                        window.localStorage.setItem("lnlaAddr", newArr)
                        // dialogUtil.alert(saveName + "<br/>选择成功！")
                        parent.art.dialog.get("addChannel").close();
                    }
  </script>
 <!-- <script type="text/javascript" src="https://webapi.amap.com/demos/js/liteToolbar.js"></script> -->
  <div style="
    width: 100%;
    text-align: center;
    position: absolute;
    bottom: 6px;
  ">
    <br>
    <ui:Button btnType="save" onClick="saveFunction();">保存</ui:Button>
    <ui:Button btnType="cancel" onClick="closeDialogFun();">取消</ui:Button>
  </div>
</body>
</html>