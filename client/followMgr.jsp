<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>公客列表</title>
<ui:Include tags="artDialog,Grid,Select,DatePicker,Select"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">

<style type="text/css">
#status a{
	text-decoration: none;
	display: inline-block;
    width: 70px;
    text-align: center;
    line-height: 20px;
}
#status  a:HOVER {
	color: red;
	background-color: rgba(144, 146, 151, 0.7);
}
.active{
	color:red;
	background-color: rgb(162, 186, 214);
}
a{
	text-decoration: none;
}
a:HOVER {
	color: red;
}

</style>

<script type="text/javascript" src="followMgr.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var parameters = {};
	
	$(function() {
		$("#grid").height($(window).height() - $("#head").height()-7);
		
		$("#status a").click(function(){
			$("#status a").each(function(){
				$(this).removeClass("active");
			});
			$(this).addClass("active");
			$("#PUBLIC_STATUS").val($(this).attr("id"));
			gridQuery();
		});
	});
	
	/**
	 * 导出操作
	 */
	function exportClientList(){
		exportExcel("grid","客户全信息列表");
	}
</script>
</head>
<body style="padding: 0; margin: 0px;">
	
	<div id="baseContainer" style="overflow: hidden;">
		
		<div id="content" style="float: left;">
			<div id="head" style="padding-left:10px;padding-bottom:6px">
				<form action="" id="queryForm">
					<input type="hidden" name="PUBLIC_STATUS" id="PUBLIC_STATUS">
					<table>
						<tr>
							<td>开始时间:</td>
							<td><ui:DatePicker id="CREATE_TIME1"></ui:DatePicker></td>
							<td style="padding-left:10px">结束时间:</td>
							<td ><ui:DatePicker id="CREATE_TIME2"></ui:DatePicker></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>姓名:</td>
							<td><ui:TextBox id="CUST_NAME"></ui:TextBox></td>
							<td style="padding-left:10px">销售组:</td>
							<td><ui:Select serviceId="com.pytech.timesgp.web.query.FollowGroupSelect"  id="groupName"></ui:Select></td>
							<td>&nbsp;</td>
							<td>
								<ui:Button btnType="query" onClick="javascript:gridQuery();">查询</ui:Button>
								<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportClientList();">导出</ui:Button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			
			<div class="box">
				<ui:Grid dataProvider="${path}/com.pytech.timesgp.web.query.FollowMgrQuery" singleSelect="true" autoLoad="true" parameters="" style="width: 100%;padding: 0px;margin: 0px;overflow: hidden" id="grid">
				<ui:GridField id="CUST_ID" width="" header="" align="center" checkColumn="true" exportable="false"></ui:GridField>
				<ui:GridField id="CUST_NAME" width="100" header="姓名" align="center" ></ui:GridField>
				<ui:GridField id="CUST_SEX" width="80" header="性别" align="center" renderer="sexRender"></ui:GridField>
				<ui:GridField id="CUST_INTENTION" width="100" header="意向类型" toolTip="true" align="center"></ui:GridField>
				<ui:GridField id="CUST_MOBILE" width="150" header="电话号码" toolTip="true" align="center"></ui:GridField>
				<ui:GridField id="succ" width="150" header="是否来访" toolTip="true" align="center" renderer="lfRender"></ui:GridField>
				<ui:GridField id="USER_NAME" width="300" header="所属销售" toolTip="true" align="center"></ui:GridField>
				<ui:GridField id="GROUP_NAME" width="140" header="所属销售组" toolTip="true" align="center"></ui:GridField>
				<ui:GridField id="HANDLE" width="90" header="操作" align="center" renderer="handleRender"></ui:GridField>
			</ui:Grid>
			</div>
			
		</div>
	</div>
	
</body>
</html>