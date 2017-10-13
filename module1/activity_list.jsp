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
<title>活动列表查询</title>
<ui:Include tags="sigmagrid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">

</style>
<script type="text/javascript" src="activity_list.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var parameters = {};
	$(function() {
		var height = $(window).height() - $("#head").height()-7;
		var width = $(window).width()  - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', path + '/com.pytech.wego.web.query.ActivityQuery',
				columns, parameters,{
					autoLoad : true
				});
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()-7;
			$("#grid").height(height);
			width = $(window).width()  - 1;
			$("#grid").width(width);
		});
		
		//后端调用示例
		$.post("${path}/action/base/homeAction?method=getAppData")
	  	.done(function(retVal) {
	  		if(retVal.success) {
	  			console.log(retVal.message);
	  		} else 
				alert(retVal.message);
	  	}).fail(function() { alert("系统异常！"); });
	});
	
	/**
	 * 导出操作
	 */
	function exportProgram(){
		exportExcel("grid","活动排期列表");
	}
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
						    <td >活动名称:</td>
							<td><ui:TextBox id="CLASS_NAME"></ui:TextBox></td>
							<td style="padding-left:10px;">所在城市:</td>
							<td><ui:TextBox id="COURSE_NAME"></ui:TextBox></td>
							<td style="padding-left:10px;">
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div id="buttons">
						<ui:Button onClick="javascript:addOp();" btnType="add">新增</ui:Button>
						<ui:Button onClick="javascript:editOp();" btnType="edit">修改</ui:Button>
						<ui:Button onClick="javascript:deleteOp();" btnType="delete">删除</ui:Button>
						<ui:Button onClick="javascript:exportProgram();" btnType="excel">导出</ui:Button>
				</div>
			</div>
			<div id="box">
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>