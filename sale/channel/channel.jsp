<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ include file="/pages/common/common.jsp" %>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>栏目管理</title>
<ui:Include tags="sigmagrid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/channel.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {"CHANNEL_ID":CHANNEL_ID};
	$(function(){
		var height = $(window).height()-$("#head").height();
		var width = $(window).width();
		$("#grid").height(height);
		$("#grid").width(width);
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height();
			var width = $(window).width();
			$("#grid").height(height);
			$("#grid").width(width);
		});
	});
	
	function addChannel(){	
		dialogUtil.open("addChannel","添加栏目",path+"/pages/sale/channel/channelEdit.jsp?oper=add",260,380,function(){
			reloadGrid('grid');
		});
	}


	function editChannel(){
		var records = getSelectedRecords('grid');
		if(records.length!=1){
			dialogUtil.alert('请选择一条记录进行修改！',true);
			return false;
		}
		//window.location.href="channelEdit.jsp?oper=edit&CHANNEL_ID="+records[0].CHANNEL_ID;
		dialogUtil.open("editChannel","修改频道",path+"/pages/sale/channel/channelEdit.jsp?oper=edit&CHANNEL_ID="+records[0].CHANNEL_ID,260,380,function(){
		});
	}
</script>
<script type="text/javascript">

</script>
</head>
<body>
	<form action="" id="" style="display: none">
	</form>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head">
				<form action="" id="queryForm">
				<%-- <input type="hidden" name="CHANNEL_ID" value="${param.CHANNEL_ID}"/> --%>
					<table>
						<tr>
							<td>频道:</td>
							<td><ui:TextBox id="CHANNEL_NAME"></ui:TextBox></td>
							<td>
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div id="buttons">
						<ui:Button onClick="javascript:addChannel();" functionId="channel_user" btnType="add">新增</ui:Button>
						<ui:Button onClick="javascript:editChannel();" functionId="channel_user" btnType="edit">修改</ui:Button>
						<ui:Button onClick="javascript:deleteChannel();" functionId="channel_user" btnType="delete">删除</ui:Button>
						<!--<ui:Button onClick="javascript:editDept();" functionId="channel_user" btnType="tree">调整责任部门</ui:Button>-->
				</div>
			</div>
			<div id="box">
				<ui:Grid 
id="grid"
dataProvider="${path}/com.pytech.timesgp.web.query.ChannelQuery"
parameters="{issen:1}"
singleSelect="true"
style="">
<ui:GridField id="CHANNEL_ID" width="50"  header="频道id" checkColumn="true"></ui:GridField>
<ui:GridField id="CHANNEL_NAME" width="300" header="频道名称" toolTip="true" align="center"/>
<ui:GridField id="CREATE_USER_CODE" width="150" header="创建人" align="center" toolTip="true"></ui:GridField>
<ui:GridField id="ORG_NAME" width="200" header="归属部门" toolTip="true" align="center"/>
<ui:GridField id="CREATE_TIME" width="200" header="创建时间" align="center"></ui:GridField>
<ui:GridField id="ORDER_SEQ" width="100" header="序号"  align="center"/>
<%-- <ui:GridField id="CHANNEL_CODE" width="100" header="频道编码"  align="center"/>--%>	
</ui:Grid> 	
</div>
		</div>
	</div>
</body>
</html>