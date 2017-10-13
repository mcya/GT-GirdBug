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
<title>公告管理</title>
<ui:Include tags="sigmagrid,artDialog,dhtmlxtoolbar"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
.dk_toggle {
	line-height: 24px;
	display: -moz-inline-stack;
	display: inline-block;
	position: relative;
	zoom: 1;
	height: 24px;
	padding-top: 0px;
	padding-bottom: 0px;
	vertical-align: center;
}
.dk_options a {
    background-color: rgb(255, 255, 255);
    border-bottom: 1px solid rgb(153, 153, 153);
    padding: 0px 10px;
}
</style>
<script type="text/javascript" src="js/noticesen.js"></script>
<script type="text/javascript" src="js/initTree.js"></script>
<script type="text/javascript">
var mypath = '${path}';
var rootId = '${user.orgCode}';
var userCode = '${user.userCode}';
var userName='${user.userName}';
var userOrgId='${user.orgId}';

</script>
<script type="text/javascript">
var parameters = {};
$(function(){
	var height = $(window).height()  - $("#head").height()+50;
	var width = $(window).width()-$("#treePanel").width()-1;
	$("#grid").height(height);
	$("#grid").width(width);
	$(window).resize(function() {
		height = $(window).height() - $("#head").height()+50;
		$("#grid").height(height);
		width = $(window).width()-$('#treePanel').width() - 1;
		$("#grid").width(width);
	});
});


/* 
	查看阅读情况
*/
function chakan(value ,record,colObj,grid,colNo,rowNo){
	var noticeid=record.NOTICE_ID;
	var status = record.NOTICE_STATUS;
	
	if(status=="1"){
		return '<a href="javascript:;" onclick="readStatus(\''+noticeid+'\')">查看</a>';
	}else{
		return "无";
	}
	
	
}


function readStatus(noticeid){
 	dialogUtil.open("readstatus","阅读状态","ReadStatus.jsp?NOTICE_ID="+noticeid+"&oper=view",400,510,function(){
	});
}

function seenotice(value ,record,colObj,grid,colNo,rowNo){
	var noticeid=record.NOTICE_ID;
	return '<a href="javascript:;" onclick="seeNotice(\''+noticeid+'\')">详情</a>';
}	
function seeNotice(noticeid){
 	window.open("NoticeSee.jsp?NOTICE_ID="+noticeid+"&oper=view","noticeSee", "height=600, width=900, top=30, left=330,resizable=no,location=no,scrollbars=yes ");
}

/* 公告状态 */
var nStatus = {
		"1":"<span style=\'color:green\'>已发送</span>",
		"0":"<span style=\'color:red\'>未发送</span>"
}
function noticeStatus(value,record){
	
	return nStatus[value];
	
}

/* 消息来源 */
var nFrom = {
		'null':"<span>时代集团</span>"
}
function noticeFrom(value,record){
	return nFrom[value];
	
}

</script>
</head>
<body style="padding: 0;margin: 0px;overflow: auto;">

	<div id="quickSearch" class="queryview">
	<span>
		<span style="font-weight: bold">快速查询</span>&nbsp;
		<!--<span class="normal selected" val="2" onclick="quickSearch(this)">全部</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="0" onclick="quickSearch(this)">草稿</span>&nbsp;&nbsp;&nbsp;
		<span class="normal"  val="1" onclick="quickSearch(this)">已发送</span>&nbsp;&nbsp;&nbsp;
		-->
		<span class="normal selected" id="STATUS" for="issen" onclick="changeScope(this, '2')">全部</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" for="issen" onclick="changeScope(this, '0')">草稿</span>&nbsp;&nbsp;&nbsp;
		<span class="normal"  for="issen" onclick="changeScope(this, '1')">已发送</span>&nbsp;&nbsp;&nbsp;
		</span>
		<span>
		<span style="font-weight: bold">公告类型:</span>&nbsp;
		<span class="normal selected" id="TYPE" for="notice_type" onclick="changeScope(this, '0')">全部</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" for="notice_type" onclick="changeScope(this, '1')">集团公告</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" for="notice_type" onclick="changeScope(this, '2')">项目公告</span>&nbsp;&nbsp;&nbsp;
		</span>
	</div>


	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head"  style="padding-left:10px;padding-bottom:6px">
				<form action="" id="queryForm">
				
				<input type="hidden" name="issen" id="issen">
				<input type="hidden" name="notice_type" id="notice_type">
				<table style="line-height: 2.5;width: 100%">
					<tr>
						<td style="text-align: right;">主题:</td>
						<td style="width:180px">
							<ui:TextBox id="NOTICE_TITLE" style="width:180px"></ui:TextBox>
						</td>
						<td style="text-align: right;">接收对象:</td>
						<td style="width:180px">
							<ui:TextBox id="TO_USERS" style="width:180px"></ui:TextBox>
						</td>
						<td  style="width:180px;text-align: right;">
							<ui:Button btnType="query" onClick="queryGrid()">查询</ui:Button>
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
					 <ui:Button onClick="javascript:toAddNotice();" btnType="add">新增</ui:Button>
					 <ui:Button onClick="javascript:deleteNotice();" btnType="delete">删除</ui:Button>
					 <ui:Button onClick="javascript:editNotice();" btnType="edit">修改</ui:Button>
					 <ui:Button onClick="javascript:sendToNotice();" btnType="view">发送</ui:Button>
				</div>
			</div>
			<div id="box">			
				<ui:Grid  id="grid" dataProvider="${path}/com.pytech.timesgp.web.query.NoticeQuery" parameters="" singleSelect="true" style="">
					<ui:GridField id="NOTICE_ID" width="50"  header="公告id" checkColumn="true"></ui:GridField>
					<ui:GridField id="NOTICE_TITLE" width="300" header="主题" toolTip="true" align="center"/>
					<ui:GridField id="CREATE_USER_NAME" width="80" header="创建人" align="center" toolTip="true"></ui:GridField>
					<ui:GridField id="ORG_NAME" width="150" header="公告来源" renderer="noticeFrom" toolTip="true" align="center"/>
					<ui:GridField id="CC_USERS" width="200" header="接收对象" toolTip="true" align="center"/>
					<ui:GridField id="SEND_TIME" width="150" header="发送时间" align="center"></ui:GridField>
					<ui:GridField id="NOTICE_STATUS" width="80" header="发送状态" renderer="noticeStatus" align="center"/>
					<%-- <ui:GridField id="caozuo" width="80" header="阅读情况" renderer="chakan" align="center"/> --%>
					<ui:GridField id="caozuo" width="80" header="公告详情" renderer="seenotice" align="center"/>
				</ui:Grid>			
			</div>
		</div>
	</div>
</body>
</html>