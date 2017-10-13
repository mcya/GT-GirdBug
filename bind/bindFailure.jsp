<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.SelectorDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<c:set var="currMonthStart" value="<%=CommonUtil.getCurrMonthFirstDate() %>"></c:set>
<c:set var="currMonthEnd" value="<%=CommonUtil.getCurrMonthLastDate() %>"></c:set>
<%
	SelectorDao selector = new SelectorDao();
	selector.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	List<Map<String,Object>> list = selector.getAreadDatas();
	pageContext.setAttribute("lists", list);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>公客列表</title>
<ui:Include tags="artDialog,Grid,Select,DateTimePicker"></ui:Include>
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

<script type="text/javascript" src="bindFailure.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var parameters = {'PUBLIC_STATUS':0};
	
	$(function() {
		var height = $(window).height()-$("#head").height();
		var width = $(window).width()-$("#treePanel").width()-4;
		$("#grid").height(height);
		$("#grid").width(width);
		
		$(window).resize(function(){
			height = $(window).height()-$("#head").height();
			$("#grid").height(height);
			width = $(window).width()-$("#treePanel").width()-4;
			$("#grid").width(width);
		});
	});
	
	/* 加载销售组
	*/
	function selectGroup(target){
		var orgId = target.val();
		$("#NOW_GROUP_ID").html("");
		$("#PREV_GROUP_ID").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getGroupByProjectId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#NOW_GROUP_ID").append('<option value="">--请选择--</option>');
			$("#PREV_GROUP_ID").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#NOW_GROUP_ID").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
				$("#PREV_GROUP_ID").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
			}
		});
	}
	/* 加载项目
	*/
	function selectProject(target){
		var orgId = target.val();
		$("#PROJECT").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getProjectByAreaId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#PROJECT").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#PROJECT").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}
	/*导出已选中客户*/
	function exportTable() {
		var paramMap = Form.formToMap('queryForm');
		var params = '';
		for(var i in paramMap) {
			params = params + '&' + i + '=' + paramMap[i];
		}
		var date = new Date();
		var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
		location.href=path+"/servlet/excel_all4bind.action?fileName=bindinfo"+dt+params;
	}
	/*批量手动绑定客户*/
	function batchManualBind() {
		var records = getSelectedRecords('grid');
		if(records.length == 0){
			dialogUtil.alert('请至少选择一条记录导出！',true);
			return false;
		}
		var ids = new Array();
		for(var i = 0;i<records.length;i++)
			ids.push("'"+records[i].ID+"'");
			//ids.push(records[i].ID);
		//ids.join(",")
		Form.showWaiting();
		ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.ReBindCustDao:bind",[{"ids":ids.join(",")}],function(reply){
			var data = reply.getResult();
			Form.hideWaiting();
			dialogUtil.alert(data.msg,function(){
			},function(){});
		});
	}
	/*批量自动绑定客户*/
	function batchAutoBind() {
		if(!$('#PROJECT').val()) {
			dialogUtil.alert("请选择要自动绑定的项目！",function(){
			},function(){});
			return;
		}
		Form.showWaiting();
		ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.ReBindCustDao:autoBind",[$('#PROJECT').val()],function(reply){
			var data = reply.getResult();
			Form.hideWaiting();
			dialogUtil.alert(data.msg,function(){
			},function(){});
		});
	}
</script>
</head>
<body style="padding: 0; margin: 0px;">
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head" >
				<form action="" id="queryForm">
					<input type="hidden" name="PUBLIC_STATUS" id="PUBLIC_STATUS">
					<%-- <c:if test="${orgType!='PROJECT'}"> --%>
					<table>
						<tr>
							<td width="85px" style="text-align: right;padding-top: 3px">成交时间从:</td>
							<td style="padding-top: 3px">
								<ui:DateTimePicker format="YYYY-MM-DD" id="DEAL_DATE_FROM" style="width:150px" defaultDate="${currMonthStart }"></ui:DateTimePicker>
							</td>
							<td width="85px" style="text-align: right;padding-top: 3px">成交时间至:</td>
							<td style="padding-top: 3px">
								<ui:DateTimePicker format="YYYY-MM-DD" id="DEAL_DATE_TO" style="width:150px" defaultDate="${currMonthEnd }"></ui:DateTimePicker>
							</td>
							<td width="66px" style="text-align: right;padding-top: 3px">业主名称:</td>
							<td width="152px" style="padding-top: 3px">
								<ui:TextBox id="CUST_NAME" style="width:152px"></ui:TextBox>
							</td>
						</tr>
						<tr>
							<td width="85px" style="text-align: right;padding-top: 3px">地区分公司:</td>
							<td width="152px" style="padding-top: 3px">
								<select id="AREA" name="AREA" class="textbox" onchange="selectProject($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.ORG_ID}">${list.ORG_NAME}</option>
									</c:forEach>
								</select>
							</td>
							<td width="66px" style="text-align: right;padding-top: 3px">项目名称:</td>
							<td width="152px" style="padding-top: 3px">
								<select id="PROJECT" name="PROJECT" class="textbox" onchange="selectGroup($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td width="66px" style="text-align: right;padding-top: 3px">产品类型:</td>
							<td width="152px" style="padding-top: 3px">
								<select id="PRODUCT" name="PRODUCT" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
									<option value="1">车位/车库</option>
									<option value="2">住宅/商业</option>
								</select>
							</td>
							</tr>
							
					</table>
					<table style="padding-left: 10px">
						<tr>
							<td>
								<ui:Button btnType="query" onClick="javascript:gridQuery();">查询</ui:Button>
								<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
								<ui:Button btnType="import" onClick="javascript:batchAutoBind();">自动扫描绑定</ui:Button>
								<ui:Button btnType="import" onClick="javascript:batchManualBind();">手动选择绑定</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportTable();">导出</ui:Button>
							</td>
						</tr>
						
					</table>
				</form>
			</div>
			
			<div class="box">
				<ui:Grid dataProvider="${path}/com.pytech.timesgp.web.query.BindFailureQuery" singleSelect="false" autoLoad="false" parameters="{}" style="border:0px solid #cccccc;background-color:#f3f3f3;padding:0px 0px 0px 1px;" id="grid">
					<ui:GridField id="ID" width="" header="" align="center" checkColumn="true" exportable="false"></ui:GridField>
					<ui:GridField id="WK_NAME" width="100" header="微客项目名称" align="center"></ui:GridField>
					<ui:GridField id="ERP_NAME" width="200" header="ERP项目名称" align="center"></ui:GridField>
					<ui:GridField id="SALE_NAME" width="100" header="销售名称" align="center"></ui:GridField>
					<ui:GridField id="CLIENTS_NAME" width="150" header="业主人员名称" align="center"></ui:GridField>
					<ui:GridField id="CLIENTS_NO" width="200" header="业主人员号码" align="center"></ui:GridField>
					<ui:GridField id="UNIT" width="180" header="楼栋号" align="center"></ui:GridField>
					<ui:GridField id="ROOM" width="180" header="房间号" align="center"></ui:GridField>
					<ui:GridField id="BUY_TYPE" width="180" header="产品类型" align="center"></ui:GridField>
					<ui:GridField id="DEAL_DATE" width="180" header="成交时间" align="center"></ui:GridField>
				</ui:Grid>
			</div>
		</div>
	</div>
	
</body>
</html>