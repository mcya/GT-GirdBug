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
<title>草稿管理</title>
<style type="text/css">
#baseContainer{position: relative;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<ui:Include tags="sigmagrid,artDialog,dhtmlxtoolbar"></ui:Include>
<script type="text/javascript" src="../js/noticesen.js"></script>
<script type="text/javascript">
var mypath = '${path}';
var rootId = '${user.orgCode}';
var userCode = '${user.userCode}';
var userName='${user.userName}';
var userOrgId='${user.orgId}';

</script>
<script type="text/javascript">
var parameters = {issen:0};
$(function(){
	var height = $(window).height()-$("#head").height();
	var width = $(window).width()-$("#treePanel").width()-40;
	$("#grid").height(height);
	$("#grid").width(width);
	});
	
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
						<td>接收对象:</td>
						<td>
							<ui:TextBox id="TO_USERS"></ui:TextBox>
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
				<div id="buttons">
					
					 <ui:Button onClick="javascript:editNotice();" btnType="edit">修改</ui:Button>
					 <ui:Button onClick="javascript:deleteNotice();" btnType="delete">删除</ui:Button>
				</div>
			</div>
			<div id="box">			
<ui:Grid 
id="grid"
dataProvider="${path}/com.pytech.timesgp.web.query.NoticeQuery"
parameters="{issen:0}"
singleSelect="true"
style="">
<ui:GridField id="NOTICE_ID" width="50"  header="公告id" checkColumn="true"></ui:GridField>
<ui:GridField id="NOTICE_TITLE" width="100" header="主题" toolTip="true" align="center"/>
<ui:GridField id="EMERGENCY" width="100" header="类型" renderer="notitype" align="center"/>
<ui:GridField id="CREATE_USER_NAME" width="100" header="创建人" align="center" toolTip="true"></ui:GridField>
<ui:GridField id="TO_USERS" width="150" header="接收对象" toolTip="true" align="center"/>
<ui:GridField id="SEND_TIME" width="150" header="保存时间" align="center"></ui:GridField>
<ui:GridField id="INVALID_TIME" width="150" header="失效时间" align="center"></ui:GridField>
</ui:Grid>		
			</div>
		</div>
	</div>
</body>
</html>