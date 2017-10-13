<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
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
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">
		var path = '${path}';
		var oper = '${param.oper}';
		var type = '${param.USER_TYPE}';
		var gpName = '${param.gpName}';
		
		function closeDialog(){
			parent.art.dialog.get("user").close();
			
		}
		
		/* 调整销售组 */
		var isClick = false;
		function save(){
			if(!Form.checkForm('dataForm')){
				return;
			}
			var postData = Form.formToMap('dataForm');
			
			var serviceUrl=serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:adjustUserGroup";
			if(isClick == false){
				isClick = true;
			}else{
				dialogUtil.tips("正在处理，请勿重复提交！");
				return;
			}
		
			if(type==1)
				dialogUtil.confirm('该销售人员是销售组'+gpName+'的组长,确定要更改所属销售组吗？',function(){
					ajax.remoteCall(serviceUrl,[postData],function(reply){
						var data = reply.getResult();
						dialogUtil.alert(data.msg,function(){
							isClick = false;
							if(data.success == true){
								artDialog.opener.reloadGrid('grid');
								parent.art.dialog.get("user").close();
							}
						},function(){});
					});
				},function(){});
			else
				ajax.remoteCall(serviceUrl,[postData],function(reply){
					var data = reply.getResult();
					dialogUtil.alert(data.msg,function(){
						isClick = false;
						if(data.success == true){
							artDialog.opener.reloadGrid('grid');
							parent.art.dialog.get("user").close();
						}
					},function(){});
				});
			
		}
		
	</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="dataForm" style="">
		<input type="hidden" name="USER_MOBILE" id="USER_MOBILE" value="${param.USER_MOBILE}">
		<input type="hidden" name="USER_CODE" id="USER_CODE" value="${param.USER_CODE}">
		<input type="hidden" name="GROUP_ID" id="GROUP_ID" value="${param.GROUP_ID}">
		<table width="100%" cellspacing="2" cellpadding="2" style="margin-top: 10px;margin-left: -30px">
			<tr>
				<td width="100px" class="label">姓&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
				<td>
					<input class="textbox" readonly="readonly" value="${param.name}">
				</td>
			</tr>
			<tr>
				<td width="100px" class="label">销售组：</td>
				<td>
					<ui:Select serviceId="com.pytech.timesgp.web.query.GroupSelect" id="USER_ORG_ID" defaultValue="1">
					</ui:Select>
				</td>
			</tr>
			
		</table>
	</form>
	
</body>
</html>