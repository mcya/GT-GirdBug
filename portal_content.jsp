<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.pytech.timesgp.web.service.HomeService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/pages/common/common.jsp" %>
<%
	pageContext.setAttribute("htmls", new HomeService().getMenuDesc(AppHandle.getCurrentUser(request)));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="Mosaddek">
    <meta name="keyword" content="FlatLab, Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">
    <link rel="shortcut icon" href="${path }/assets/img/favicon.png">
    <title>移动跟客系统</title>
  </head>

  <body style="overflow: hidden;">
  	　<div style="position:absolute; width:100%; height:100%; z-index:-1;align:center">
           	<p align="center" style="font-weight:bold;font-size:200">欢迎您使用后台管理系统！</p>
      </div>
  </body>
</html>
