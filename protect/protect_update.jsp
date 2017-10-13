<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.alibaba.druid.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<%
	String oper = request.getParameter("oper");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
.label {
	text-align: right
}

.require {
	color: red;
	padding-right: 1px;
}

.form-table {
	margin-top: 10px;
}

.form-table tr {
	height: 30px;
}
</style>
<title>修改保护期</title>
<ui:Include tags="artDialog,Select,DatePicker"></ui:Include>
<script type="text/javascript">
	var path = '${path}';
	var oper = '${param.oper}';
	$(function() {
		if ('edit' == oper) {
			getOrgan();
		}
		if ('view' == oper) {
			getOrgan();
			Form.formDisable('organForm')
		}
		$('.default').dropkick();
	});
	function getOrgan() {
		ajax.remoteCall(
			path+ "/com.pytech.timesgp.web.dao.ProjectProtectDao:getProjProtect",
			[ '${param.PK_ID}' ],
			function(reply) {
				var data = reply.getResult();
				Form.mapToForm('organForm', data);
				$("#PROJECT option").each(
								function() {
									if ($(this).val() == data.PROJECT_ID) {
										///$("#PROJECT option[text="+ $(this).text()+ "]").attr("selected", "selected");
									}
								});
				$("#A_CUSTOMER_CYCLE").val(data.A_DAYS);
				$("#B_CUSTOMER_CYCLE").val(data.B_DAYS);
				$("#C_CUSTOMER_CYCLE").val(data.C_DAYS);
				$("#O_CUSTOMER_CYCLE").val(data.PROJECT_DAYS);
				if ('edit' == oper) {
					$("#PROJECT_NAME").val(data.PROJECT_NAME);
				}
		});
	}
	function saveOrUpdate() {
		if (!Form.checkForm('organForm')) {
			return;
		}
		var numberCheck = "";
		if (isNaN($("#A_CUSTOMER_CYCLE").val())) {
			numberCheck += "A客保护期格式不正确;";
		}
		if (isNaN($("#B_CUSTOMER_CYCLE").val())) {
			numberCheck += "B客保护期格式不正确;";
		}
		if (isNaN($("#C_CUSTOMER_CYCLE").val())) {
			numberCheck += "C客保护期格式不正确;";
		}
		if (numberCheck != "") {
			alert(numberCheck);
			return;
		}
		var postData = Form.formToMap('organForm');
		var serviceUrl = "";
		if (oper == "edit") {
			serviceUrl = "${path}/com.pytech.timesgp.web.dao.ProjectProtectDao:updateProtect";
		} else {
			serviceUrl = "${path}/com.pytech.timesgp.web.dao.ProjectProtectDao:addProtect";
		}
		postData.PK_ID = $("#PK_ID").val();
		ajax.remoteCall(serviceUrl, [ postData ], function(reply) {
			var data = reply.getResult();
			dialogUtil.alert(data.msg, function() {
				if (data.success == true) {
					artDialog.opener.reloadGrid('grid');
					parent.art.dialog.get("protect").close();
				}
			});
		});
	}
	function closeDialog(){
		parent.art.dialog.get("protect").close();
	}
</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="organForm">
		<input type="hidden" id="PK_ID" name="PK_ID" value="${param.PK_ID}">
		<table width="90%" cellspacing="2" cellpadding="2" class="form-table">
			<c:if test="${'edit' != param.oper}">
				<tr>
					<td width="100px" class="label"><span class="require">*</span>项目名称：</td>
					<td><ui:Select
							serviceId="com.pytech.timesgp.web.query.ProjectSelect"
							parameter="{'orgType':'${orgType}'}" id="PROJECT"
							caption="isnull:false;cname:项目">
						</ui:Select></td>
				</tr>
			</c:if>
			<c:if test="${'edit' == param.oper}">
				<tr style="disable: true;">
					<td width="100px" class="label"><span></span>项目名称：</td>
					<td><ui:TextBox id="PROJECT_NAME"></ui:TextBox></td>
				</tr>
			</c:if>
			<tr>
				<td width="100px" class="label"><span class="require">*</span>A客天数：</td>
				<td><ui:TextBox id="A_CUSTOMER_CYCLE"
						caption="isnull:false;cname:A客保护期"></ui:TextBox></td>
			</tr>
			<tr>
				<td width="100px" class="label"><span class="require">*</span>B客天数：</td>
				<td><ui:TextBox id="B_CUSTOMER_CYCLE"
						caption="isnull:false;cname:B客保护期"></ui:TextBox></td>
			</tr>
			<tr>
				<td width="100px" class="label"><span class="require">*</span>C客天数：</td>
				<td><ui:TextBox id="C_CUSTOMER_CYCLE"
						caption="isnull:false;cname:C客保护期"></ui:TextBox></td>
			</tr>
			<tr>
				<td width="100px" class="label"><span class="require">*</span>其他客户天数：</td>
				<td><ui:TextBox id="O_CUSTOMER_CYCLE"
						caption="isnull:false;cname:其他客户"></ui:TextBox></td>
			</tr>
		</table>
	</form>
	<c:if test="${'view' != param.oper}">
		<div style="width: 100%; text-align: center">
			<br>
			<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
			<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
		</div>
	</c:if>
</body>
</html>