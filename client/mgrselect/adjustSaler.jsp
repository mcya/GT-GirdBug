<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.GroupDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>

<%
	
	GroupDao groupDao = new GroupDao();
	groupDao.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	List<Map<String,Object>> list = groupDao.getGroupByOrgId(null);
	pageContext.setAttribute("lists", list);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
.label {
	text-align: right
}

.require {
	color: red;
	padding-right: 1px;
}


#dataForm tr {
	height: 30px;
	line-height: 30px;
}
</style>
<title>structure</title>
<ui:Include tags="artDialog,Select"></ui:Include>
<script type="text/javascript">
		var path = '${path}';
		$(function(){
			
			
		});
		
		function closeDialog(){
			parent.art.dialog.get("customer").close();
			
		}
		
		/* 调整销售组 */
		var isClick = false;
		function save(){
			//判断两个下拉框是否选值了
			var group = $("#group").val();
			var user = $("#user").val();
		    if($.trim(group)=="" || $.trim(user)==""){
				dialogUtil.alert("请选择需要分配的分组或人员!",function(){});
				return;
			} 
			
			var name = $("#user :checked").text();
			var postData = Form.formToMap('dataForm');
			postData.SALE_ID = user;
			postData.GROUP_ID = group;		
			var serviceUrl=serviceUrl = "${path}/com.pytech.timesgp.web.dao.CustomerDao:updateCustSalerGroup";
			if(isClick == false)
				isClick = true;
			else{
				dialogUtil.tips("正在处理，请勿重复提交！");
				return;
			}
			ajax.remoteCall(serviceUrl,[postData],function(reply){
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					isClick = false;
					if(data.success == true){
						artDialog.opener.reloadGrid('grid');
						parent.art.dialog.get("adjustCust").close();
					}
				},function(){});
			});
		}
		
		/* 
			获取销售人员
		*/
		function getUserMgr(groupId){
			$("#user").html("");
			var serviceUrl=serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
			ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
				var data = reply.getResult();
				$("#user").append('<option value="">--请选择--</option>');
				for(var i=0;i<data.length;i++){
					$("#user").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
				}
				
			});
		}
		
		/* 
			加载销售人员
		*/
		function selectUser(target){
			
			var groupId = target.val();			
			getUserMgr(groupId)			
		}
		
	</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="dataForm" style="">
	
		<input type="hidden" name="CUST_ID" id="CUST_ID" value="${param.id}">
		<table width="100%" cellspacing="2" cellpadding="2" style="margin-top: 10px;margin-left: -10px">
			<tr>
				<td width="100px" class="label">销售小组：</td>
				<td>
					<select id="group" name="group" style="width:150px" class="textbox" onchange="selectUser($(this))">
						<option value="">--请选择--</option>
						<c:forEach var="list" items="${lists}">
							<option value="${list.GROUP_ID}">${list.GROUP_NAME}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			
			<tr>
				<td width="100px" class="label">销售人员：</td>
				<td>
					<select id="user" name="user" class="textbox" style="width:150px">
						<option value="">--请选择--</option>
					</select>
				</td>
			</tr>
			
			
		</table>
	</form>
	
</body>
</html>