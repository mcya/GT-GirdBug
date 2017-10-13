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
<title>子集客户参数详情</title>
<ui:Include tags="sigmagrid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/customer.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var dictids = getUrlParam('dictids')
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {
		pdictid: dictids,
	};
	$(function(){
		var height = $(window).height()-$("#head").height();
		var width = $(window).width();
		$("#gridTwo").height(height);
		$("#gridTwo").width(width);
		loadGrid('gridTwo',
			path+
			'/com.pytech.timesgp.web.query.ParametersQuery',
			columnsss,
			parameters, {
				singleSelect: true
			});
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height();
			var width = $(window).width();
			$("#gridTwo").height(height);
			$("#gridTwo").width(width);
		});

	});



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
				<div style="height: 25px"></div>
				<form action="" id="queryForm">
					<table>
						<tr>
							<td>
								<ui:Button btnType="reset" onClick="javascript:window.history.back(-1)">返回</ui:Button>
							</td>
							<td>
							    <ui:Button btnType="add" onClick="javascript:addChanneel()">新增</ui:Button>
							</td>
							<td>
								<ui:Button onClick="javascript:editChanneel();" btnType="edit">修改</ui:Button>
							</td>
							<td>
							    <ui:Button btnType="delete" onClick="javascript:deleteChanneel()">删除</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div style="height: 18px"></div>
			</div>
			<div id="box">
				<div id="gridTwo"></div>
			</div>
		</div>
	</div>
</body>
</html>
