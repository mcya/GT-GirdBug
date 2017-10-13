
<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.pytech.timesgp.web.dao.SenNoticeDao"%>
<%@page import="java.util.Map"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core_1_1" %>
<%
	String noticeId = CommonUtil.toEmpty(request.getParameter("NOTICE_ID"));
	SenNoticeDao activityDao = new SenNoticeDao();
    Map<String,Object> map = activityDao.getNotice(noticeId);
    if(map == null){
    	out.print("<span>信息已经删除</span>");
    	return;
    }
    pageContext.setAttribute("map", map);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>活动详情</title>
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
			
		<meta content="telephone=no" name="format-detection">
		<link href="css/public.css" rel="stylesheet">
		<link href="css/activity.css" rel="stylesheet">
		<link href="css/button.css" rel="stylesheet" /> -->
		
		<style>
			.form p {
				margin: 8px auto;
			}
			
			.form {
				padding: 12px;
			}
			
			.text_style {
				width: 96%;
				padding: 12px 2%;
				border: 1px solid #ccc;
				font-size: 12px;
				-webkit-border-radius: 4px;
				-moz-border-radius: 4px;
				border-radius: 4px;
			}
			
			.textarea_style {
				line-height: 20px;
				-webkit-border-radius: 4px;
				-moz-border-radius: 4px;
				border-radius: 4px;
			}
			
			.button_style2 {
				background: #CC2B31;
				padding: 4px 24px;
				color: #fff;
				border: none;
				cursor: pointer;
				-webkit-border-radius: 4px;
				-moz-border-radius: 4px;
				border-radius: 4px;
				font-size: 12px;
				margin: 6px auto;
				z-index: 111111111;
			}
			
			.case_bg {
				background: url(images/activity_bg.png) center;
				background-size: auto 100%;
				height: 200px;
			}
			.textareaid{
				border:1px solid red;
				/* overflow: scroll; */
				height:100px;height:auto;min-height:100px;width:800px; background:#bbeeeb;margin:0 auto;
			}
			#textareaid>span{
			padding-left:25px}
			#textareaid {width:100%}
			#textareaid img{width:98%;margin:0 auto}
			#textareaid ,#textareaid span,#textareaid img{border:0}
			.case_msg h1{background-color: #ffffff}
			
		</style>
	</head>
	
	<body style="background:#efefef;">
			
		<div id="wrapper">
			<div id="main">
				<!-- start -->
				<div class="case_box" style="padding-bottom:64px;">
					
					<div class="case_msg  color2">
						
					</div>
					<div class="case_msg case_msg2 color2">
					<h1 style="font-size:20px;padding:10px 20px"> ${map.NOTICE_TITLE }</h1>
						<div class="note" style="margin:0px 0px; padding:0px; padding-top:12px;">
							<div class="noclict" style="position: absolute; width: 100%; height: 100px;"></div>
							<div  id="textareaid"> 
							${map.NOTICE_CONTENT }
							</div>
						</div>
					</div>
				
				</div>
				<!-- end -->
			</div>
		</div>
	
	</body>
</html>