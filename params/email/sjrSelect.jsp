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
<title>选择收件人</title>
<ui:Include tags="sigmagrid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/email.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var usernames = getUrlParam('username')
	var orgids = getUrlParam('orgid')
	var isAdd = getUrlParam('isAdd')
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {"ORGID":orgids, 'USERNAME': ''};
	if (isAdd==1) {
		parameters = {"ORGID":orgids}
	}
	function qq() {
		window.history.back(-1)
	}
	$(function(){
		var columns = [{
			id: 'DEPTID',
			header: 'id',
			width: 50,
			align: 'center',
			isCheckColumn: true
		}, {
			id: "USERNAME",
			header: "姓名",
			width: 100,
			align: 'center',
			type: 'string',
			toolTip:true
		}, {
			id: "USER_SEX",
			header: "性别",
			width: 100,
			align: 'center',
			type: 'string',
			toolTip:true,
			renderer:xingbie,
		}, {
			id: "MOBILEPHONE",
			header: "电话",
			width: 200,
			align: 'center',
			type:'string',
			toolTip:true,
		}, {
			id: "ADACCOUNT",
			header: "账号",
			width: 100,
			align: 'center',
			type: 'string',
			toolTip:true
		}, {
			id: "JOBNUMBER",
			header: "工号",
			width: 100,
			align: 'center',
			type: 'string',
			toolTip:true
		}, {
			id: "EMAIL",
			header: "电子邮箱",
			width: 100,
			align: 'center',
			type: 'string',
			toolTip:true
		}];
		var height = $(window).height()-$("#head").height();
		var width = $(window).width();
		$("#gridEe").height(height);
		$("#gridEe").width(width);
		// 收件人查询方法---后台尚未ok
		loadGrid('gridEe',
				path + '/com.pytech.timesgp.web.query.UserListByParamQuery',
				columns,
				parameters,
				{
					singleSelect: false
				});
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height();
			var width = $(window).width();
			$("#gridEe").height(height);
			$("#gridEe").width(width);
		});

		// $('#gridEe').on('dblclick', 'tr', function(e){
	 // 	   openTabLiTwo()
		// })
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
							<td>姓名:</td>
							<td><ui:TextBox id="GROUPNAME"></ui:TextBox></td>
							<td>
							    <ui:Button btnType="query" onClick="javascript:query()">查询</ui:Button>
							</td>
							<td>
							    <ui:Button btnType="save" onClick="javascript:saveShoujian()">保存选中数据</ui:Button>
							</td>
							<td>
								<ui:Button btnType="reset" onClick="javascript:qq()">返回</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div style="height: 18px"></div>
			</div>
			<div id="box">
				<div id="gridEe"></div>
			</div>
		</div>
	</div>
</body>
</html>
