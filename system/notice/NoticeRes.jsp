<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag" %>
<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>接收公告</title>
<style type="text/css">
#baseContainer{position: relative;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<ui:Include tags="sigmagrid,artDialog,dhtmlxtoolbar"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/noticesen.js"></script>
<script type="text/javascript">
var mypath = '${path}';
var rootId = '${user.orgCode}';
var userCode = '${user.userCode}';
var userName='${user.userName}';
var userOrgId='${user.orgId}';

</script>
<script type="text/javascript">
var parameters = {issen:2};
$(function(){
	var height = $(window).height()-$("#head").height();
	var width = $(window).width()-$("#treePanel").width()-40;
	$("#grid").height(height);
	$("#grid").width(width);
	});
 /* function notitype(value ,record,colObj,grid,colNo,rowNo){
	 if(record.EMERGENCY==1){
		 return "紧急";
	 }else{
		 return "普通";
	 }
 } */
	 
 
	
</script>
</head>
<body style="padding: 0;margin: 0px;overflow: auto;">
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head">
				<form action="" id="queryForm">
				<table style="text-align: right;line-height: 2.5;border-bottom: 1px dashed;width: 100%">
				<tr>
					<td>主题:</td>
						<td>
							<ui:TextBox id="NOTICE_TITLE"></ui:TextBox>
						</td>
						<td>发件人:</td>
						<td>
							<ui:TextBox id="CREATE_USER_NAME"></ui:TextBox>
						</td>
						<td>
							<ui:Button btnType="query" onClick="query()">查询</ui:Button>
							<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					</tr>
				</table>
				</form>
				<div id="buttons" style="float: left;">
					 <ui:Button onClick="javascript:SeeNotice();" btnType="view">查看</ui:Button>
					 <ui:Button onClick="javascript:deleteNotice();" btnType="delete">删除</ui:Button>
				</div>
				<div style="margin-top: 5px;font-size:14px;text-align: right;"><a href="NoticeSen.jsp" >发送公告</a></div>
			</div>
			<div id="box">			
<ui:Grid 
id="grid"
dataProvider="${path}/com.pytech.timesgp.web.query.NoticeQuery"
parameters="{issen:2}"
singleSelect="true"
style="">
<ui:GridField id="NOTICE_ID" width="50"  header="公告id" checkColumn="true"></ui:GridField>
<ui:GridField id="caozuo" width="100" header="操作" renderer="caozuo" align="center"/>
<ui:GridField id="NOTICE_TITLE" width="300" header="主题" toolTip="true" align="center"/>
<ui:GridField id="CREATE_USER_NAME" width="150" header="发件人" align="center" toolTip="true"></ui:GridField>
<ui:GridField id="ORG_NAME" width="150" header="所属机构" align="center" toolTip="true"></ui:GridField>
<ui:GridField id="TO_USERS" width="150" header="接收对象" align="center"/>
<ui:GridField id="READ_FLAG" width="100" header="已读/未读" renderer="isreading" align="center"/>
<ui:GridField id="READ_TIME" width="150" header="阅读时间"  align="center"/>
<ui:GridField id="SEND_TIME" width="150" header="发送时间" align="center"></ui:GridField>
</ui:Grid>			
			</div>
		</div>
	</div>
</body>
</html>