<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="java.util.Date" %>
<%@page import="com.open.eac.core.config.ServerConfig"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@page import="com.open.eac.core.structure.User"%>

<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="basePath" value='<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath() %>'></c:set>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>公告首页</title>

<style type="text/css">
.span_link{cursor:pointer;text-decoration: underline;color: #39c;}

</style>
<ui:Include tags="zTree,sigmagrid,artDialog,Tabbar"></ui:Include>
<script type="text/javascript">
	var path = '${path}';
	$(function(){
		$("#mytabbar").height($(window).height());
	});

</script>

</head>
<body style="padding: 0; margin: 0px;">
	
	<ui:Tabbar style="width:100%;" id="mytabbar">
		<ui:Tab url="NoticeSen.jsp?" name="已发送"  id="type"></ui:Tab>
		<ui:Tab url="NoticeSave.jsp?" name="草稿箱" id="dingyi"></ui:Tab>
	</ui:Tabbar>
	
</body>
</html>