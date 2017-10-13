<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<c:set var="pwd" value="<%=AppHandle.getCurrentUser(request).getUserPwd() %>"></c:set>
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
<ui:Include tags="artDialog,Select,DateTimePicker"></ui:Include>
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">
		var path = '${path}';
		function closeDialog(){
			parent.art.dialog.get("modifyPwd").close();
		}

		/* 保存用户 */
		var isClick = false;
		function saveOrUpdate(){
			if(!Form.checkForm('dataForm')){
				return;
			}
			if('${pwd}'!=$('#OLD_PWD').val()) {
				alert('旧密码输入不正确，请重新输入！');
				$('#OLD_PWD').val('');
				$('#NEW_PWD').val('');
				$('#CONFIRM_PWD').val('');
				return;
			}
			if($('#NEW_PWD').val()!=$('#CONFIRM_PWD').val()) {
				alert('两次密码输入不一致，请重新输入！');
				$('#NEW_PWD').val('');
				$('#CONFIRM_PWD').val('');
				return;
			}
			var postData = Form.formToMap('dataForm');
			var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:modifyPwd";
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
					if(data.success == true) {
						parent.location.href='/eac-appcenter?logout=true';
						parent.art.dialog.get("modifyPwd").close();
					}
				},function(){});
			});
		}
		
	</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="dataForm" style="">
		<input type="hidden" name="OLD_MOBILE" id="oldMobile">
		<input type="hidden" name="orgId" id="orgId" value="<%=request.getParameter("orgId")%>">
		<table width="100%" cellspacing="2" cellpadding="2" style="margin-top: 10px;margin-left: -30px">
			<tr>
				<td width="100px" class="label" style="padding-left:10px;"><span class="require">*</span>旧密码：</td>
				<td>
					<ui:TextBox id="OLD_PWD" type="password" caption="isnull:false;cname:旧密码"></ui:TextBox>
				</td>
			</tr>
			<tr>
				<td width="100px" class="label" style="padding-left:10px;"><span class="require">*</span>新密码：</td>
				<td>
					<ui:TextBox id="NEW_PWD" type="password" caption="isnull:false;cname:新密码"></ui:TextBox>
				</td>
			</tr>
			
			<tr>
				<td width="100px" class="label" style="padding-left:10px;"><span class="require">*</span>确认密码：</td>
				<td>
					<ui:TextBox id="CONFIRM_PWD" type="password" caption="isnull:false;cname:确认密码"></ui:TextBox>
				</td>
				
			</tr>
			
		</table>
	</form>
	<c:if test="${'view' != param.oper}">
		<div style="width: 100%; text-align: center;margin-top: 10px;">
			<br>
			<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
			<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
		</div>
	</c:if>
</body>
</html>