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

<script type="text/javascript" src="dirtyData.js"></script>
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
	
	function deleteDt(){
		var records = getSelectedRecords('grid');
		if(records.length == 0){
			dialogUtil.alert('请选择需要操作的记录！',true);
			return false;
		}
		dialogUtil.confirm('确认将选择的'+records.length+'条记录删除吗？',function(){
			var custIds = new Array();
			for(var i = 0;i<records.length;i++)
				custIds.push(records[i].CUST_ID);
			doDeleteCust(custIds.join("','"));
		},function(){});
		
	}
	function doDeleteCust(custIds){
		
		custIds = "'"+custIds+"'";
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.CustomerDao:deleteCust",[custIds],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
				reloadGrid('grid');
			});
		});
		
	}
</script>
</head>
<body style="padding: 0; margin: 0px;">
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head" >
				<form action="" id="queryForm">
					<%-- <c:if test="${orgType!='PROJECT'}"> --%>
					<table>
						<tr>
							<td width="85px" style="text-align: right;padding-top: 3px">录入时间从:</td>
							<td style="padding-top: 3px">
								<ui:DateTimePicker format="YYYY-MM-DD" id="INPUT_TIME" style="width:150px" defaultDate="${currMonthStart }"></ui:DateTimePicker>
							</td>
							<td width="85px" style="text-align: right;padding-top: 3px">录入时间至:</td>
							<td style="padding-top: 3px">
								<ui:DateTimePicker format="YYYY-MM-DD" id="INPUT_TIME_END" style="width:150px" defaultDate="${currMonthEnd }"></ui:DateTimePicker>
							</td>
							<td></td>
							<td></td>
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
							<td width="66px" style="text-align: right;padding-top: 3px">客户名称:</td>
							<td width="152px" style="padding-top: 3px">
								<ui:TextBox id="CUST_NAME" style="width:152px"></ui:TextBox>
							</td>
							<td width="66px" style="text-align: right;padding-top: 3px">客户电话:</td>
							<td width="152px" style="padding-top: 3px">
								<ui:TextBox id="CUST_PHONE" style="width:152px"></ui:TextBox>
							</td>
							</tr>
							
					</table>
					<table style="padding-left: 10px">
						<tr>
							<td>
								<ui:Button btnType="query" onClick="javascript:query();">查询</ui:Button>
								<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
								<ui:Button btnType="delete" onClick="javascript:deleteDt();">删除</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportSimpleList();">导出</ui:Button>
							</td>
						</tr>
						
					</table>
				</form>
			</div>
			
			<div class="box">
				<ui:Grid dataProvider="${path}/com.pytech.timesgp.web.query.DirtyDataQuery" singleSelect="false" autoLoad="false" parameters="{}" style="border:0px solid #cccccc;background-color:#f3f3f3;padding:0px 0px 0px 1px;" id="grid">
					<ui:GridField id="CUST_ID" width="" header="客户编码" align="center" checkColumn="true" exportable="false"></ui:GridField>
					<ui:GridField id="CUST_NAME" width="100" header="姓名" align="center" renderer="custRender"></ui:GridField>
					<ui:GridField id="CUST_SEX" width="200" header="性别" align="center" renderer="issex"></ui:GridField>
					<ui:GridField id="CUST_INTENTION" width="100" header="意向" align="center"></ui:GridField>
					<ui:GridField id="CUST_MOBILE" width="150" header="手机号码" align="center"></ui:GridField>
					<ui:GridField id="CUST_SOURCE" width="200" header="客户来源" align="center"></ui:GridField>
					<ui:GridField id="CUST_SALE_STATUS" width="180" header="销售状态" align="center"  renderer="ispublic"></ui:GridField>
					<ui:GridField id="USER_NAME" width="180" header="所属销售" align="center"></ui:GridField>
					<ui:GridField id="GROUP_NAME" width="180" header="所属销售组" align="center"></ui:GridField>
					<ui:GridField id="PROJECT_NAME" width="180" header="所属项目" align="center"></ui:GridField>
					<ui:GridField id="PUBLIC_FLAG" width="180" header="公客属性" align="center"  renderer="opRender"></ui:GridField>
					<ui:GridField id="CREATE_TIME" width="180" header="录入时间" align="center"></ui:GridField>
				</ui:Grid>
			</div>
		</div>
	</div>
	
</body>
</html>