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
<ui:Include tags="artDialog,Select,DateTimePicker"></ui:Include>
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">
		var path = '${path}';
		var oper = '${param.oper}';
		$(function(){
			if(oper == "edit"){
				getUser();	
			}
		});
		
		function closeDialog(){
			parent.art.dialog.get("user").close();
		}
		
		function getUser(){
			var serviceUrl = path+"/com.pytech.timesgp.web.dao.UserMgrDao:getUserById";
			
			ajax.remoteCall(serviceUrl,[{"USER_MOBILE":"${param.USER_MOBILE}"}],function(reply){
				var data = reply.getResult();
				Form.mapToForm('dataForm',data);
				$("#oldMobile").val(data.USER_MOBILE);
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
				serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:updateUser";
			}else{
				serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:addUser";
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
						parent.art.dialog.get("user").close();
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
		<table width="98%" cellspacing="2" cellpadding="2" style="margin-top: 10px;margin-left: 0px;margin-right:10px">
			<tr>
				<td width="100px" class="label"><span class="require">*</span>账&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
				<td>
					<c:if test="${param.oper=='edit'}">  
					<input id="USER_CODE" name="USER_CODE" readonly="readonly" class="textbox" style="width:160px" ></input>
					</c:if>
					<c:if test="${param.oper!='edit'}">  
					<input id="USER_CODE" name="USER_CODE" class="textbox" style="width:160px" ></input>
					</c:if>
				</td>
				<td width="100px" class="label"><span class="require">*</span>密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
				<td>
					<ui:TextBox id="USER_PWD" caption="isnull:false;cname:密码" style="width:160px" ></ui:TextBox>
				</td>
			</tr>
			<tr>
				<td width="100px" class="label"><span class="require">*</span>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
				<td>
					<ui:TextBox id="USER_NAME" caption="isnull:false;cname:姓名" style="width:160px" ></ui:TextBox>
				</td>
				<td width="100px" class="label"><span class="require">*</span>电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
				<td>
					<ui:TextBox id="USER_MOBILE" caption="isnull:false;cname:电话" style="width:160px" ></ui:TextBox>
				</td>
			</tr>
			
			<tr>
				<td width="100px" class="label">性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
				<td style="width:120px" >
				<select class="textbox" id="USER_SEX" name="USER_SEX" style="width:162px" >
					<option value="1">男</option>
					<option value="0">女</option>
				</select>
				</td>
				
				<td width="100px" class="label">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态：</td>
				<td style="width:120px" >
				<select class="textbox"  id="USER_STATUS" name="USER_STATUS" style="width:162px" >
					<option value="1" selected="selected">有效</option>
					<option value="0">无效</option>
				</select>
				</td>
			</tr>
			
			<tr>
				<td width="100px" class="label">微&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;信：</td>
				<td>
					<ui:TextBox id="WECHAT_NO" style="width:160px" ></ui:TextBox>
				</td>
				<td width="100px" class="label">出生年月：</td>
				<td>
					<ui:DateTimePicker id="USER_BORN" format="YYYY-MM-DD" style="width:160px" defaultDate=""></ui:DateTimePicker>
				</td>
			</tr>
			<tr>
				<td width="100px" class="label">工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
				<td>
					<ui:TextBox id="JOB_NO" style="width:160px" />
				</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
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