<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.LocationDao"%>
<%@page import="com.pytech.timesgp.web.vo.GroupLocationVo"%>
<%@page import="com.pytech.timesgp.web.vo.CmVkLocationVo"%>

<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
try{
	String groupId = request.getParameter("groupId");
	System.out.println("*****************"+groupId);
	LocationDao locationDao = new LocationDao();
	List<GroupLocationVo> userLocationList = locationDao.usersLocation(groupId,"1");
	GroupLocationVo groupVo = userLocationList.get(0);
	List<CmVkLocationVo> locationList = groupVo.getSaleList();
	pageContext.setAttribute("groupVo", groupVo);
	pageContext.setAttribute("locationList", locationList);
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
	<script type="text/javascript">
	
          function init() {
             var map = new AMap.Map('mapContainer',{
            resizeEnable: true,
            zoom: 13
        });   
        
         var longitude ,latitude;
           <c:forEach var="location" items="${locationList}" >
           var trueLoc = transformFromWGSToGCJ(${location.longitude},${location.latitude})
           longitude = trueLoc.lng;
           latitude = trueLoc.lat;
           	 marker = new AMap.Marker({
            	content:'<div class="marker" >${location.userName}</div>',
                position:[longitude, latitude],
                map:map
            });
           </c:forEach>
          var center =  new AMap.LngLat(longitude,latitude);
        map.setCenter(center);
        
         }  
        
	</script>
</head>
<body onload="init();")>
<div id="aa" class="div-left"><table><tr><td>${groupVo.groupName }</td></tr></table></div>
    <div id="mapContainer"></div>
    
  </body>
</html>