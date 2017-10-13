<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>Call客分配</title>
<ui:Include tags="Grid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">

</style>
<script type="text/javascript" src="import.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var parameters = {};
	$(function() {
		
		$("#grid").height($(window).height() - $("#head").height()-7);
		
	});
	
</script>
</head>
<body style="padding: 0; margin: 0px;">
	<form action="" id="" style="display: none">
	</form>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head"  style="padding-left:10px;padding-bottom:6px">
				<form action="" id="queryForm">
					<table>
						<tr>
						    <td>姓名:</td>
							<td><ui:TextBox id="CALLEE_NAME"></ui:TextBox></td>
							<td style="padding-left:10px;">电话号码:</td>
							<td><ui:TextBox id="CALLEE_NUMBER"></ui:TextBox></td>
							<td style="padding-left:10px;">
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<%-- <div id="buttons">
						<ui:Button onClick="javascript:addOp();" btnType="add">新增</ui:Button>
						<ui:Button onClick="javascript:editOp();" btnType="edit">修改</ui:Button>
						<ui:Button onClick="javascript:deleteOp();" btnType="delete">删除</ui:Button>
						<ui:Button onClick="javascript:importCall();" btnType="excel">Call客导入</ui:Button>
				</div> --%>
			</div>
			
			
			<ui:Grid dataProvider="${path}/com.pytech.timesgp.web.query.CalleeQuery" singleSelect="false" autoLoad="true" parameters="" style="width: 100%;padding: 0px;margin: 0px;overflow: hidden" id="grid">
				<ui:GridField id="CALLEE_ID" width="" header="" align="center" checkColumn="true" exportable="false"></ui:GridField>
				<ui:GridField id="CALLEE_NAME" width="100" header="置业组" align="center" ></ui:GridField>
				<ui:GridField id="CALLEE_NAME" width="100" header="销售人员" align="center" ></ui:GridField>
				<ui:GridField id="CALLEE_NUMBER" width="150" header="已分配Call客数" toolTip="true" align="center"></ui:GridField>
				<ui:GridField id="IMPORT_TIME" width="200" header="未分配Call客数" toolTip="true" align="center"></ui:GridField>
			</ui:Grid>
		</div>
	</div>
</body>
</html>