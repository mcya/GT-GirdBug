<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.CalleeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="ui" uri="http://www.open.com/eac/core/tag" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<%
	pageContext.setAttribute("contextpath", request.getContextPath());
	CalleeDao selector = new CalleeDao();
	selector.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	
	List<Map<String,Object>> list = selector.getGroup();
	pageContext.setAttribute("lists", list);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>消息管理</title>
<ui:Include tags="Grid,DateTimePicker,artDialog"></ui:Include>
<link href="${contextpath }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript">
var path = '${contextpath}';
$(function(){
	var height = $(window).height()-$("#quickSearch").height()-$("#head").height()-$("#operButton").height()-12;
	$("#grid").height(height);
	$("#grid").width($(window).width()-2);
	$(window).resize(function(){
		var height = $(window).height()-$("#quickSearch").height()-$("#head").height()-$("#operButton").height()-12;
		$("#grid").height(height);
		$("#grid").width($(window).width()-2);
	});
});

function query(){
	var map = Form.formToMap('queryForm');
	var params = {CALL_RESULT:0};
	for(var key in map){
		params[key] = map[key];
	}
	reloadGrid('grid',params);
}

function quickSearch(obj){
	var val = $(obj).attr("val");
	$("#CALL_RESULT").val(val);
	$(obj).siblings(".selected").removeClass("selected");
	$(obj).addClass("selected");
	query();
}
function importCallee(){
	dialogUtil.open("calleeImport","call客导入",path+"/pages/call/importAdd.jsp",450,590);
}
function resultRender(val,record){
	if(val==null){
		return '未呼叫';
	}else if(val==3){
		return "<font color='#B5E61D'>下次拨</font>";
	}else if(val==1){
		return "<font color='#22B14C'>有意向</font>"
	}else if(val==2){
		return "<font color='#ED1C24'>放弃</font>";
	}else if(val==4){
		return "<font color='#DBDEEE'>空号</font>";
	}
}
function deleteCallee(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var ids = new Array();
		for(var i = 0;i<records.length;i++){
			ids.push(records[i].CALLEE_ID);
		}
		doDelete(ids.join(","));
	},function(){});
}
function doDelete(ids){
	ajax.remoteCall("${contextpath}/com.pytech.timesgp.web.dao.CalleeDao:deleteEntryDao",[ids],function(reply){
		var data = reply.getResult();
		dialogUtil.tips(data.msg);
		reloadGrid('grid');
	});
}
function doReset(){
	document.getElementById("queryForm").reset();
	query();
}


/* 加载销售人员
*/
function selectPerson(target){
	var groupId = target.val();
	$("#SELECT_SALE_NAME").html("");
	var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
	ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
		var data = reply.getResult();
		$("#SELECT_SALE_NAME").append('<option value="">--请选择--</option>');
		for(var i=0;i<data.length;i++){
			$("#SELECT_SALE_NAME").append('<option value="'+data[i].USER_NAME+'">'+data[i].USER_NAME+'</option>');
		}
	});
}
//导出Callee
function exportCallee(){
	var paramMap = Form.formToMap('queryForm');
	var params = '';
	for(var i in paramMap) {
		params = params + '&' + i + '=' + paramMap[i];
	}
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href = path + "/servlet/exportCallee.action?fileName=Callee"+dt+params;
}
</script>
</head>
<body>
	<div id="quickSearch" class="queryview"  style="padding-left:10px;">
		<span style="font-weight: bold;padding-left:10px;">快速查询</span>&nbsp;
		<span class="normal selected" val="0" onclick="quickSearch(this)">全部</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="1" onclick="quickSearch(this)">有意向</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="2" onclick="quickSearch(this)">放弃</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="4" onclick="quickSearch(this)">空号</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="3" onclick="quickSearch(this)">下次拨</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="-1" onclick="quickSearch(this)">未呼叫</span>&nbsp;&nbsp;&nbsp;
	</div>
	<div id="head" style="padding-left:10px;">
		<form action="" id="queryForm">
			<input type="hidden" name="CALL_RESULT" id="CALL_RESULT">
			<table>
				<tr>
					<td >销售小组:</td>
							<td width="152px">
								<select id="SALE_GROUP" name="SALE_GROUP" class="textbox" onchange="selectPerson($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.GROUP_ID}">${list.GROUP_NAME}</option>
									</c:forEach>
								</select>
							</td>
							<td style="padding-left: 13px;">销售人员:</td>
							<td width="152px">
								<select id="SELECT_SALE_NAME" name="SELECT_SALE_NAME" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
					<td width="2px"></td>
					<td>导入时间：</td>
					<td>
						<ui:DateTimePicker id="SEND_TIME_FROM" format="YYYY-MM-DD" style="width:150px" defaultDate=""></ui:DateTimePicker> 至
						<ui:DateTimePicker id="SEND_TIME_TO" format="YYYY-MM-DD" style="width:150px" defaultDate=""></ui:DateTimePicker>
					</td>
					<td>
						<ui:Button btnType="query" onClick="query()">查询</ui:Button>
						<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div id="operButton"  style="padding-left:10px;padding-bottom:2px">
		<ui:Button onClick="importCallee();" btnType="import">导入</ui:Button>
		<ui:Button btnType="excel" onClick="exportCallee();" id="btn_excel" btnText="导出">导出</ui:Button>
		<ui:Button onClick="deleteCallee()" btnType="delete">删除</ui:Button>
	</div>
	<div id="gridbox">
		<ui:Grid style="background-color: #f3f3f3;" 
		id="grid" 
		dataProvider="${contextpath}/com.pytech.timesgp.web.query.CalleeQuery"
		parameters="{'CALL_RESULT':0}"
		>
			<ui:GridField id="CALLEE_ID" width="" header="" checkColumn="true" exportable="false"/>
			<ui:GridField id="CALLEE_NAME" width="100" header="call客名" align="center"/>
			<ui:GridField id="CALLEE_NUMBER" width="120" header="电话号码" align="center"/>
			<ui:GridField id="SALE_NAME" width="100" header="责任销售" align="left" toolTip="true"/>
			<ui:GridField id="BELONG_ORG_GROUP_NAME" width="150" header="所在组" align="left"/>
			<ui:GridField id="BELONG_ORG_NAME" width="200" header="所在项目" align="left"/>
			<ui:GridField id="CALL_RESULT" width="80" header="呼叫结果" align="center" renderer="resultRender"/>
			<ui:GridField id="LOSS_REASON" width="100" header="放弃原因" align="left"/>
			<ui:GridField id="CALL_DESC" width="240" header="备注" align="left"/>
			
		</ui:Grid>
	</div>
</body>
</html>