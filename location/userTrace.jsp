<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.LocationDao"%>
<%@page import="com.pytech.timesgp.web.vo.CmVkLocationVo"%>
<%@page import="com.pytech.timesgp.web.vo.LocationTraceVo"%>

<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
try{
	String userCode = request.getParameter("userCode");
	String traceTime = request.getParameter("traceTime");
	LocationDao locationDao = new LocationDao();
	LocationTraceVo trace = locationDao.saleTraceInfo(userCode, traceTime);
	pageContext.setAttribute("trace", trace);
	pageContext.setAttribute("traceTime", traceTime);
}catch(Exception e){
e.printStackTrace();
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>structure</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
    body,#mapContainer{
        margin:0;
        height:100%;
        width:100%;
        font-size:12px;
    }
    .marker{
        width:38px;
        height:60px;
        background-image:url(<%=basePath%>/images/map/mark_b.png);
        background-size: 38px 60px;
        text-align: center;
        line-height: 30px;
        color: #fff
    }
    .div-left{
	    position: absolute;
		top: 5px;
		left: 10px;
		background: #fff none repeat scroll 0 0;
		border: 1px solid #ccc;
		margin: 10px auto;
		padding:6px;
		font-family: "Microsoft Yahei", "微软雅黑", "Pinghei";
		font-size: 14px;
		z-index:99999;
    }
</style>
<link rel="stylesheet" href="http://cache.amap.com/lbs/static/main.css?v=1.0?v=1.0" />
    <script src="http://cache.amap.com/lbs/static/es5.min.js"></script>
     <link rel="stylesheet" href="http://cache.amap.com/lbs/static/main1119.css"/>
      <script type="text/javascript" src="http://cache.amap.com/lbs/static/addToolbar.js"></script>
      <script type="text/javascript" src="/times-web/pages/js/wgs2mars.js"></script>
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=这是密钥，对于一个细心的人来说，是不会留下这些的，哈哈"></script>
	
	<style type="text/css">
		#left{width:120px; height:200px; background:#ff0000;float:left}
		#right{width:65%; height:200px; background:#00ff00;}
	</style>
	<script type="text/javascript">
	
          function init() {
             var map = new AMap.Map('mapContainer',{
            resizeEnable: true,
            zoom: 13
        });   
        
         var longitude,latitude,label;
         var lineArr = new Array();
         var i = 0;
           <c:forEach var="location" varStatus="var" items="${trace.locateList}" >
           //var lngLat = locationConvert('${location.longitude}','${location.latitude}');
           var trueLoc = transformFromWGSToGCJ(${location.longitude},${location.latitude})
           longitude = trueLoc.lng;//lngLat.getLng();
           latitude = trueLoc.lat;//lngLat.getLat();
           label = '${location.label}';
           var posArr = new Array();
           posArr.push(longitude);
           posArr.push(latitude);
           lineArr[i++]=posArr;
           if('1' == label){
           var statusName = '停';
           	if(0=='${var.index}'){
           		statusName = '起';
           	}else if('${fn:length(trace.locateList) }' == '${var.index+1}'){
           		statusName = '终';
           	}
           	 marker = new AMap.Marker({
            	content:'<div class="marker" >'+statusName+'</div>',
                position:[longitude, latitude],
                offset : new AMap.Pixel(-18,-60),
                map:map
            });
             marker.on('mouseover', function() {
        	//alert('${location.addr}');
        	openInfo(map,'${location.addr}','${location.locatetime}',transformFromWGSToGCJ(${location.longitude}
        	,${location.latitude}).lng,transformFromWGSToGCJ(${location.longitude},${location.latitude}).lat);
   		 });
            }
           </c:forEach>
          var center =  new AMap.LngLat(longitude,latitude);
           
			
        map.setCenter(center);
   /*     
        var lineArr = [
        [116.368904, 39.913423],
        [116.382122, 39.901176],
        [116.387271, 39.912501],
        [116.398258, 39.904600]
    ];
    */
          var polyline = new AMap.Polyline({
        path: lineArr,          //设置线覆盖物路径
        strokeColor: "#3366FF", //线颜色
        strokeOpacity: 1,       //线透明度
        strokeWeight: 5,        //线宽
        strokeStyle: "solid",   //线样式
        strokeDasharray: [10, 5],//补充线样式
      	showDir:true//显示箭头
    }); 
    
    polyline.setMap(map);
         }  
         
   function openInfo(map,addr,time,longitude,latitude) {
   //构建信息窗体中显示的内容
   var info = [];
   info.push(time);
   info.push("<div style='padding:0px' ><b>"+addr+"</b>");

   infoWindow = new AMap.InfoWindow({
       content: info.join("<br>")  //使用默认信息窗体框样式，显示信息内容
   });
   infoWindow.open(map, [longitude, latitude]);
}     

	
	</script>
</head>
<body onload="init();">
	<div id="aa" class="div-left"><table><tr><td>${trace.userName } ${traceTime } 轨迹</td></tr></table></div>
			<div id="mapContainer"></div>
		<div id="myPageTop">
		    <table>
		        <tr>
		            <td>
		                <label>${trace.userName } ${traceTime } 详情：</label>
		            </td>
		            
		        </tr>
		        <c:forEach var="timeInfo" items="${trace.timeList}" >
			        <tr>
			            <td>
			            	<c:choose>
			               <c:when test="${timeInfo.type == 0 }">
			               
			                ${timeInfo.startTime}停留(${timeInfo.duration})
			               <br> (${timeInfo.startAddr })
			               </c:when>
			               <c:otherwise>
			               	移动( ${timeInfo.duration})
			               </c:otherwise>
			               </c:choose>
			            </td>
			        </tr>
		        </c:forEach>
		    </table>
		</div>
    
  </body>
</html>