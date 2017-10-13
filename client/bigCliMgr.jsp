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

<script type="text/javascript" src="bigCliMgr.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var parameters = {'PUBLIC_STATUS':0};
	
	$(function() {
		var height = $(window).height()-$("#head").height()-33;
		var width = $(window).width()-$("#treePanel").width()-4;
		$("#grid").height(height);
		$("#grid").width(width);
		
		/* loadGrid('grid', path + '/com.pytech.timesgp.web.query.CustomerQuery',
				columns, parameters, {
					autoLoad : true,
					singleSelect : false
				}); */
		
		$(window).resize(function(){
			height = $(window).height()-$("#head").height()-33;
			$("#grid").height(height);
			width = $(window).width()-$("#treePanel").width()-4;
			$("#grid").width(width);
		});
	});
	
	function quickSearch(obj){
		var val = $(obj).attr("val");
		$("#PUBLIC_STATUS").val(val);
		$(obj).siblings(".selected").removeClass("selected");
		$(obj).addClass("selected");
		gridQuery();
	}
	/* 
	/* 
		加载销售人员
	*/
	function selectUser4Now(target){
		var groupId = target.val();
		$("#NOW_SALE_ID").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
		ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
			var data = reply.getResult();
			$("#NOW_SALE_ID").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#NOW_SALE_ID").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
			}
		});
	}
	/* 
	加载销售人员
	*/
	function selectUser4Pre(target){
		var groupId = target.val();
		$("#PREV_SALE_ID").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
		ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
			var data = reply.getResult();
			$("#PREV_SALE_ID").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#PREV_SALE_ID").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
			}
		});
	}
	/* 加载销售组
	*/
	function selectGroup(target){
		var orgId = target.val();
		$("#NOW_GROUP_ID").html("");
		//$("#PREV_GROUP_ID").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getGroupByProjectId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#NOW_GROUP_ID").append('<option value="">--请选择--</option>');
			//$("#PREV_GROUP_ID").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#NOW_GROUP_ID").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
				//$("#PREV_GROUP_ID").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
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
	/*批量转销售公客池*/
	function batchPublic() {
		var records = getSelectedRecords('grid');
		if(records.length == 0){
			dialogUtil.alert('请至少选择一条记录导出！',true);
			return false;
		}
		var ids = new Array();
		for(var i = 0;i<records.length;i++)
			ids.push("'"+records[i].CUST_ID+"'");
		ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.PublicClientDao:turnToPublic",[ids.join(",")],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
				if(data.success)
					reloadGrid('grid');
			},function(){});
		});
	}
	/*批量调整销售员*/
	function batchAdjust() {
		dialogUtil.open("batchAdjustPg","批量指定公客销售人员",path+"/pages/client/batchAdjust4public.jsp",200,450);
	}
	/*导出已选中客户*/
	function exportSelected() {
		var records = getSelectedRecords('grid');
		if(records.length == 0){
			dialogUtil.alert('请至少选择一条记录导出！',true);
			return false;
		}
		var ids = new Array();
		for(var i = 0;i<records.length;i++)
			ids.push("'"+records[i].CUST_ID+"'");
		var date = new Date();
		var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
		location.href = path + "/servlet/excel4public_selected.action?fileName=selectedp"+dt+'&custIds=' + ids.join(",");
	}
</script>
</head>
<body style="padding: 0; margin: 0px;">
	<div id="quickSearch" class="queryview" style="padding-left:10px;">
		<span style="font-weight: bold;padding-left:10px;">快速查询</span>&nbsp;&nbsp;&nbsp;
		<span class="normal selected" val="0" onclick="quickSearch(this)">全部</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="1" onclick="quickSearch(this)">隐形公客池</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="2" onclick="quickSearch(this)">销售公客池</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="3" onclick="quickSearch(this)">已跟进公客</span>&nbsp;&nbsp;&nbsp;
		<!-- <span class="normal" val="4" onclick="quickSearch(this)">未匹配旧客数据</span>&nbsp;&nbsp;&nbsp; -->
		<!-- <span class="normal" val="5" onclick="quickSearch(this)">手机号匹配成交客户[9月1日前成交]</span>&nbsp;&nbsp;&nbsp; -->
	</div>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head" style="padding-left:10px;">
				<form action="" id="queryForm">
					<input type="hidden" name="PUBLIC_STATUS" id="PUBLIC_STATUS">
					<%-- <c:if test="${orgType!='PROJECT'}"> --%>
					<table>
						<tr>
							<td>地区分公司:</td>
							<td width="152px">
								<select id="AREA" name="AREA" class="textbox" onchange="selectProject($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.ORG_ID}">${list.ORG_NAME}</option>
									</c:forEach>
								</select>
							</td>
							<td style="padding-left: 21px;">项目名称:</td>
							<td width="152px">
								<select id="PROJECT" name="PROJECT" class="textbox" onchange="selectGroup($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left:8px">&nbsp;</td>
							<td width="152px;">&nbsp;</td>
							<td style="padding-left:8px">&nbsp;</td>
							<td width="152px;">&nbsp;</td>
						</tr>
					</table>
					<%-- </c:if> --%>
					<table>
						<tr>
							<td>现销售小组:</td>
							<td width="152px;">
								<%-- <ui:Select style="width:180px;" serviceId="com.pytech.timesgp.web.query.GroupSelect" defaultValue="-1" id="NOW_GROUP_ID"></ui:Select> --%>
								<select id="NOW_GROUP_ID" name="NOW_GROUP_ID" class="textbox" onchange="selectUser4Now($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left:8px">现销售人员:</td>
							<td width="152px;">
								<%-- <ui:Select style="width:300px;" serviceId="com.pytech.timesgp.web.query.SalerSelect" defaultValue="-1" id="NOW_SALE_ID"></ui:Select> --%>
								<select id="NOW_SALE_ID" name="NOW_SALE_ID" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<!-- 
							<td style="padding-left:8px">前销售小组:</td>
							<td width="152px;">
								<%-- <ui:Select style="width:180px;" serviceId="com.pytech.timesgp.web.query.GroupSelect" defaultValue="-1" id="PREV_GROUP_ID"></ui:Select> --%>
								<select id="PREV_GROUP_ID" name="PREV_GROUP_ID" class="textbox" onchange="selectUser4Pre($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left:8px">前销售人员:</td>
							<td width="152px;">
								<%-- <ui:Select style="width:300px;" serviceId="com.pytech.timesgp.web.query.SalerSelect" defaultValue="-1" id="PREV_SALE_ID"></ui:Select> --%>
								<select id="PREV_SALE_ID" name="PREV_SALE_ID" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							 -->
						</tr>
					</table>
					<table>
						<tr>
							<td>转公客起始:</td>
							<td width="150px;">
								<ui:DateTimePicker format="YYYY-MM-DD" id="startTime" style="width:150px"></ui:DateTimePicker>
							</td>
							<td style="padding-left:8px;">转公客截止:</td>
							<td width="150px;">
								<ui:DateTimePicker format="YYYY-MM-DD" id="endTime" style="width:150px"></ui:DateTimePicker>
							</td>
							<td style="padding-left:21px" >客户姓名:</td>
							<td><ui:TextBox id="CUST_NAME"  style="width:150px;"></ui:TextBox></td>
							<td style="padding-left:21px">联系号码:</td>
							<td><ui:TextBox id="CUST_MOBILE"  style="width:150px;"></ui:TextBox></td>
						</tr>
						<tr>
							<td colspan="8" style="">
								<ui:Button btnType="query" onClick="javascript:gridQuery();">查询</ui:Button>
								<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
								<ui:Button btnType="edit" onClick="javascript:batchPublic();">转销售公客池</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportSelected();">导出选中公客</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:batchAdjust();">批量指定销售员</ui:Button>
							</td>
						</tr>
						
					</table>
				</form>
			</div>
			
			<div class="box">
				<ui:Grid dataProvider="${path}/com.pytech.timesgp.web.query.CustomerQuery" singleSelect="false" autoLoad="false" parameters="{'PUBLIC_STATUS':0}" style="border:0px solid #cccccc;background-color:#f3f3f3;padding:0px 0px 0px 1px;" id="grid">
					<ui:GridField id="CUST_ID" width="" header="" align="center" checkColumn="true" exportable="false"></ui:GridField>
					<ui:GridField id="CUST_NAME" width="100" header="姓名" align="center" renderer="custNameRender"></ui:GridField>
					<ui:GridField id="CUST_SEX" width="70" header="性别" align="center" renderer="sexRender"></ui:GridField>
					<ui:GridField id="CUST_INTENTION" width="70" header="意向类型" align="center"></ui:GridField>
					<ui:GridField id="CUST_MOBILE" width="110" header="电话号码" align="center"></ui:GridField>
					<ui:GridField id="PUBLIC_STATUS" width="180" header="客户状态" align="center" renderer="publicStatusRender"></ui:GridField>
					<ui:GridField id="FAIL_REASON" width="250" header="流失原因" align="center"></ui:GridField>
					<ui:GridField id="CREATE_TIME" width="150" header="录入时间" align="center"></ui:GridField>
					<ui:GridField id="PLAN_VISIT_TIME" width="150" header="预约来访日期" align="center"></ui:GridField>
					<ui:GridField id="LAST_FOLLOW_TIME" width="150" header="最后修改时间" align="center"></ui:GridField>
					<%-- <ui:GridField id="OPRENDER" width="180" header="操作" align="left" renderer="oooopRder"></ui:GridField> --%>
					<ui:GridField id="SALE_NAME" width="150" header="所属销售" align="center"></ui:GridField>
					<ui:GridField id="GROUP_NAME" width="150" header="所属销售组" align="center"></ui:GridField>
					<ui:GridField id="PROJECT_NAME" width="150" header="所属项目" align="center"></ui:GridField>
				</ui:Grid>
			</div>
		</div>
	</div>
	
</body>
</html>