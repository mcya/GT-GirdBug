<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.CalleeDao"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%
	CalleeDao selector = new CalleeDao();
	selector.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	String groupId=request.getParameter("groupId");
	String orgId=request.getParameter("orgId");
	List<Map<String,Object>> list = selector.getSaller(groupId,orgId);
	pageContext.setAttribute("lists", list);
%>
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
<link rel="stylesheet" href="${path }/pages/css/bootstrap.css" />
<link rel="stylesheet" href="${path }/pages/css/font-awesome.css" />
<link rel="stylesheet" href="${path }/pages/css/bootstrap-duallistbox.css" />
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
.btn-default {
    color:#FFFFFF;
    background-color: #269abc;
    border-color: #cccccc;
}
</style>
<script type="text/javascript" src="selectSaler.js"></script>
<script type="text/javascript" src="jquery.bootstrap-duallistbox.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script src="../../js/jquery.raty.js"></script>

<script type="text/javascript">
jQuery(function($){
    var demo1 = $('select[name="duallistbox_demo1[]"]').bootstrapDualListbox(
    		{
    			infoTextFiltered: '<span class="label label-purple label-lg">Filtered</span>',
    			nonSelectedListLabel: '所有销售人员',
    			selectedListLabel: '已选销售人员'
   			}
   		);
	var container1 = demo1.bootstrapDualListbox('getContainer');
	container1.find('.btn').addClass('btn-white btn-info btn-bold');
	$('.rating').raty({
		'cancel' : true,
		'half': true,
		'starType' : 'i'
	})
});


/*
//‘选中’操作，关联销售人员到销售组
function closeSelf() {

	var groupId = '${param.groupId}';
	var records=document.getElementById("duallist");
	var ids = new Array();
	for(var i = 0;i<records.length;i++){
		if(records[i].selected){
	//	alert("'"+records[i].value+"'");
		ids.push(records[i].value);
	}
	}
	var idstr = ids.join(",");
	ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.UserMgrDao:dealSallee",[idstr,groupId],function(reply){
		//alert('1111111111111111111');
		var data = reply.getResult();
		//alert('data'+data);
		dialogUtil.alert(data.msg,function(){
			artDialog.opener.reloadGrid('grid');
			parent.art.dialog.get("group").close();
		});
	});
}*/
/*
function relateGroup() {
	var groupId = '${param.groupId}';
	var flg = '${param.flg}';
	var records=document.getElementById("duallist");
//	if(records.length==0){
//		dialogUtil.alert('请至少选择一条记录！',true);
//		return false;
//	}
//	if(flg==1&&records.length>1) {
//		dialogUtil.alert('请选择一条记录！',true);
//		return false;
//	}
	var ids = new Array();
	for(var i = 0;i<records.length;i++){
		if(records[i].selected){
		ids.push("'"+records[i].value+"'");
		}
		}
	var idstr = ids.join(",");
	ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.UserMgrDao:relateGroup",[idstr,groupId,flg],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			artDialog.opener.reloadGrid('grid');
			parent.art.dialog.get("group").close();
		});
	});
}
*/

//通过serverlet调转返回结果

function loading(){
	var result = '${param.result}';
	if(result==2)
	{	msg='操作成功';
		dialogUtil.alert(msg,function(){
		artDialog.opener.reloadGrid('grid');
		parent.art.dialog.get("group").close();
		});
	}
	if(result==1)
	{	msg='操作失败';
		dialogUtil.alert(msg,function(){
		artDialog.opener.reloadGrid('grid');
		parent.art.dialog.get("group").close();
		});
	}
} 
</script>

</head>
<body style="padding: 0; margin: 0px;" onload="loading()">
	<form id="demoform" action="<%=request.getContextPath()%>/servlet/Sallee.action" method="post">
	<!-- 	<form id="demoform"  > -->
		<!-- #section:plugins/input.duallist -->
		<input type="hidden" name="groupId" value="<%=request.getParameter("groupId")%>">
		<input type="hidden" name="orgId" value="<%=request.getParameter("orgId")%>">
		<input type="hidden" name="path" value="<%=request.getContextPath()%>">
		<button type="submit" style="width:300px" style="background-color:#269abc;color:#FFFFFF" class="btn btn-default btn-block" >确认提交</button>
		<div style="display:block;width:100%;background-color:gray;height:1px;margin-top:5px"></div>
		<div class="col-md-8">
		<select multiple="multiple" size="10" name="duallistbox_demo1[]" id="duallist" style="height: 300px;width:300px" >
		<c:forEach var="list" items="${lists}">
				<option value="${list.USER_CODE}" ${list.selected}="${list.selected}">${list.USER_NAME}</option>
		</c:forEach>
		
		</select>
		</div>
          </form>
          
		<!-- /section:plugins/input.duallist -->
	
</body>
</html>