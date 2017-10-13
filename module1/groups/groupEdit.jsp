<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<c:set var="orgId" value="orgId"></c:set>
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
<ui:Include tags="artDialog,Select,DatePicker"></ui:Include>
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">

		var path = '${path}';
		var oper = '${param.oper}';
		$(function(){
			if(oper=="edit"){
				getGroup();
			}
		});
		
		function closeDialog(){
			parent.art.dialog.get("group").close();
		}
		
		function getGroup(){
			var serviceUrl = path+"/com.pytech.timesgp.web.dao.GroupDao:getGroupById";
			ajax.remoteCall(serviceUrl,[{"GROUP_ID":"${param.GROUP_ID}"}],function(reply){
				var data = reply.getResult();
				Form.mapToForm('dataForm',data);
			});
		} 

		
		
		/* 保存用户 */
		var isClick = false;
		function saveOrUpdate(){
			if(!Form.checkForm('dataForm')){
				return;
			}
			var postData = Form.formToMap('dataForm');
			
			var serviceUrl = null;
			if(oper == 'edit'){
				serviceUrl = "${path}/com.pytech.timesgp.web.dao.GroupDao:updateGroupDao";
			}else{
				serviceUrl = "${path}/com.pytech.timesgp.web.dao.GroupDao:addGroupDao";
			}
			if(isClick == false){
				isClick = true;
			}else{
				dialogUtil.tips("正在处理，请勿重复提交！");
				return;
			}
		
			ajax.remoteCall(serviceUrl,[postData],function(reply){
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					isClick = false;
					if(data.success == true){
						artDialog.opener.reloadGrid('grid');
						parent.art.dialog.get("group").close();
					}
				},function(){});
			});
		}
		
	</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="dataForm" style="">
		<input type="hidden" name="GROUP_ID" id="GROUP_ID">
		<input type="hidden" name="orgId" id=""orgId"" value="<%=request.getParameter("orgId")%>">
		<table width="100%" cellspacing="2" cellpadding="2" style="margin-top: 10px;margin-left: -20px">
			<tr>
				<td width="100px" class="label"><span class="require">*</span>分组名称：</td>
				<td><ui:TextBox id="GROUP_NAME" caption="isnull:false;cname:分组名称" style="width:100%"></ui:TextBox></td>
			</tr>
			
			
			<tr>
				<td width="100px" class="label">分组描述：</td>
				<td>
					<textarea style="height: 100px;padding: 3px;width: 99%" class="textbox" id="GROUP_DESC" name="GROUP_DESC"></textarea>
				</td>
			</tr>
			
		</table>
	</form>
	<c:if test="${'view' != param.oper}">
		<div style="width: 100%; text-align: center;margin-top: 0px;">
			<br>
			<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
			<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
		</div>
	</c:if>
</body>
</html>