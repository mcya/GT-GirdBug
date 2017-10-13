<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ include file="/pages/common/common.jsp" %>

<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>

<c:set var="path" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>客户参数设置</title>
<ui:Include tags="sigmagrid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/customer.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {"CHANNEL_ID":CHANNEL_ID};
	$(function(){
		var height = $(window).height()-$("#head").height()-32;
		var width = $(window).width();
		$("#grid").height(height);
		$("#grid").width(width);
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height();
			var width = $(window).width();
			$("#grid").height(height);
			$("#grid").width(width);
		});

		$('#grid').on('dblclick', 'tr', function(e){
	    	openNewTab()
		})
	});


</script>
<script type="text/javascript">

</script>
</head>
<body>
	<div id="quickSearch" class="queryview" style="padding-left:10px;">
		<span style="font-weight: bold;padding:0px 10px;">快速查询</span>&nbsp;&nbsp;&nbsp;
		<span class="normal selected" val="org" onclick="quickSearch(this)">集团级</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="proj" onclick="quickSearch(this)">项目级</span>&nbsp;&nbsp;&nbsp;
	</div>
	<form action="" id="" style="display: none">
	</form>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head">
				<div style="height: 25px"></div>
				<form action="" id="queryForm">
					<table>
						<tr>
							<td>参数名称:</td>
							<td><ui:TextBox id="GROUPNAME"></ui:TextBox></td>
							<td>
							    <ui:Button btnType="query" onClick="queryy()">查询</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div style="height: 18px"></div>
			</div>
			<div id="box">
				<ui:Grid
id="grid"
dataProvider="${path}/com.pytech.timesgp.web.query.ParameterMenuQuery"
parameters="{issen:1,TYPE:'org'}"
singleSelect="true"
style="">
<ui:GridField id="GROUPID" width="50"  header="id" checkColumn="true" align="center"></ui:GridField>
<ui:GridField id="GROUPNAME" width="450" header="参数名称" toolTip="true" align="center"/>
<ui:GridField id="GROUPBELONG" width="450" header="参数范围" toolTip="true" align="center"/>
<%--
<ui:GridField id="GROUPBELONG" width="500" header="参数范围" align="center" toolTip="true" align="center"></ui:GridField>

<ui:GridField id="ORG_NAME" width="200" header="归属部门" toolTip="true" align="center"/>
<ui:GridField id="CREATE_TIME" width="200" header="创建时间" align="center"></ui:GridField>
<ui:GridField id="ORDER_SEQ" width="100" header="序号"  align="center"/>
<ui:GridField id="CHANNEL_CODE" width="100" header="频道编码"  align="center"/>
--%>
</ui:Grid>
</div>
		</div>
	</div>
</body>
</html>
