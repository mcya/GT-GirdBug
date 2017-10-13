<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request)%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>选择销售人员</title>
<ui:Include tags="sigmagrid,artDialog,zTree"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer {
	position: relative;
}

#treePanel {
	white-space: nowrap;
	font-size: 12px;
	margin: 0;
	width: 200px;
	height: 100%;
	padding: 0px 0px;
	float: left;
	border: 1px solid #c6dcf1;
	position: relative;
	overflow: auto;
}

#searchContanter {
	position: absolute;
	top: 26px;
	z-index: 10;
	left: 2px;
	background-color: #eee
}

.sbtn {
	background-color: #FFF;
	border: 1px solid #CCC;
	height: 24px;
	width: 40px;
	cursor: pointer;
}
</style>
<script type="text/javascript" src="selectSaler.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var rootId = '${user.orgCode}';
	var orgId = '${param.orgId}';
	var parameters = {'ORG_ID':orgId};
	var flg = '${param.flg}';
	var groupId = '${param.groupId}';
	var saler = '${param.saler}';
	var gridglobal = null;
	var rowNum = new Array();
	$(function() {
		var height = 460;
		var width = $(window).width();

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', path + '/com.pytech.timesgp.web.query.ChooseSalerQuery',
				columns, parameters, {
					autoLoad : true,
					updateCheckState : function() { // 根据原有销售人员，列表设置默认选中
						var rows = gridglobal.getRows();
						for (i = 0; i < rowNum.length; i++) {
							gridglobal.selectRow(rows[rowNum[i]], true);
						}
						rowNum = new Array(); 
					}
				});

		initTree();
		$(window).resize(function() {
			height = 460;
			$("#grid").height(height);
			width = $(window).width();
			$("#grid").width(width);
		});
	});
	

	// button methods.......
	function query() {
		var map = Form.formToMap('queryForm');
		var params = parameters;
		for ( var key in map) {
			params[key] = map[key];
		}
		var orgId = '${param.orgId}';
		reloadGrid('grid', params);
	}
</script>

</head>
<body style="padding: 0; margin: 0px;">

	<div id="baseContainer" style="overflow: hidden;">

		<div id="treePanel" style="overflow: hidden; display: none">
			<div id="mgrbtn" style="padding-left: 3px;"></div>
			<div id="searchContanter"
				style="height: 30px; width: 100%; margin-top: 0px; padding-top: 2px; margin-left: 0px; display: none">
				<span><input id="search_str" name="search_str" type="text"
					class="textbox" style="width: 150px" /></span> <input type="button"
					value="搜索" onclick="doSearch();" class="sbtn" />
			</div>
			<div id="tree" class="ztree"
				style="padding: 5px 0px 0px 0px; margin: 0px; width: 200px; overflow: auto; background-color: #fff; border-top: 0px solid #c6dcf1;"></div>
		</div>


		<div id="content" style="float: left;">
			<div id="head" style="padding-left: 10px;">
				<form action="" id="queryForm">
					<div style="display: none;">
						<input id="ORG_ID" name="ORG_ID" value="${param.orgId}" /> 
						<input id="orgName" /> 
						<input id="orgCode" />
						<input id="busiCode" />
					</div>
					<table style="height: auto;">
						<tr style="">
							<td style="padding-left: 10px;">姓名:</td>
							<td style="padding-left: 10px;"><ui:TextBox id="USER_NAME"></ui:TextBox></td>
							<td style="padding-left: 10px;"><ui:Button btnType="save"
									onClick="javascript:relateGroup();">选中</ui:Button> <ui:Button
									btnType="query" onClick="javascript:query();">查询</ui:Button> <ui:Button
									btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="box">
				<div id="grid"></div>
			</div>

		</div>
	</div>




</body>
</html>