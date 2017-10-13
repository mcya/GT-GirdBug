<%@page import="com.pytech.timesgp.web.dao.UserMgrDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>

<%
	UserMgrDao userMgrDao = new UserMgrDao();
	String id = request.getParameter("USER_CODE");
	pageContext.setAttribute("user", userMgrDao.getUserById(id));
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
<ui:Include tags="artDialog,Select,DatePicker"></ui:Include>

<script type="text/javascript">
		var path = '${path}';
		var oper = '${param.oper}';
		$(function(){
			$("input").attr("readonly","readonly");
		});
		
		function closeDialog(){
			parent.art.dialog.get("user").close();
		}
	</script>
</head>
<body style="overflow: hidden;">
	
		<table width="100%" cellspacing="2" cellpadding="2" style="margin-top: 10px;margin-left: -30px">
			<tr>
				<td width="100px" class="label"><span class="require">*</span>姓名：</td>
				<td>
					<input class="textbox" value="${user.USER_NAME }">
				</td>
				<td width="100px" class="label"><span class="require">*</span>电话：</td>
				<td>
					<input class="textbox" value="${user.USER_MOBILE }">
				</td>
			</tr>
			<tr>
				<td width="100px" class="label">微信：</td>
				<td>
					<input class="textbox" value="${user.WECHAT_NO }">
				</td>
				
				<td width="100px" class="label">年龄：</td>
				<td>
					<input class="textbox" value="${user.USER_BORN}">
				</td>
			</tr>
			
			<tr>
				<td width="100px" class="label">性别：</td>
				<td>
					<c:if test="${user.USER_SEX eq 1 }">
						<input class="textbox" value="男">
					</c:if>
					<c:if test="${user.USER_SEX eq 0 }">
						<input class="textbox" value="女">
					</c:if>
				</td>
				
				<td width="100px" class="label">状态：</td>
				<td>
					<c:if test="${user.USER_STATUS eq 0 }">
						<input class="textbox" value="有效">
					</c:if>
					<c:if test="${user.USER_STATUS eq 1 }">
						<input class="textbox" value="无效">
					</c:if>
				</td>
			</tr>
			
		</table>
</body>
</html>