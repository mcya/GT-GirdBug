<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.open.eac.core.config.ServerConfig"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
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
</style>
<title>频道增改</title>
<ui:Include tags="artDialog,zTree"></ui:Include>
<script type="text/javascript">
var path = '${path}';
var oper = '${param.oper}';
var selector = null;
var text=document.getElementById("ORG_NAME");
var save = 2;
var before;

/* $(function(){
	if ('edit' == oper) {
		selector=createTreeSelector({inputId:"ORG_NAME",defaultOpen:'ORG_NAME',includeTypes:"CORP",width:160,height:150});
	}else{
		selector=createTreeSelector({inputId:"ORG_NAME",defaultOpen:"1",includeTypes:"CORP",width:160,height:150});
	}
}); */
$(function() {
	if ('edit' == oper) {
		getChannel();
	}
	if ('view' == oper) {
		getChannel();
		Form.formDisable('dataForm')
	}
});

/*
$(function(){
	var topicCode = document.getElementById("TOPIC_CODE").value;
	 
	ajax.remoteCall(path + "/com.open.eac.news.dao.TopicDao:getTopicCode",[topicCode],function(reply){
		if(!reply.getResult()){
			codeState = true;
		}
	});
});
*/


$(function() {
	var channelCode;
	var postData = Form.formToMap('dataForm');
	var data = null;
	
	/*
	if('edit' == oper){
		ajax.remoteCall(path + "/com.open.eac.news.dao.ChannelDao:getChannel",[ '${param.CHANNEL_ID}' ], function(reply) {
			var data = reply.getResult();
			channelCode = data.CHANNEL_CODE;
			save = 2;
		});
	}
	*/
	
	$("#CHANNEL_CODE").blur(function(){
		channelCode = document.getElementById("CHANNEL_CODE").value;
		if(channelCode.length>20){
			alert('频道编码不能超过20个字符');
			return false;
		}
		//postData["TEST_CODE"]=channelCode;
		ajax.remoteCall(path + "/com.pytech.timesgp.web.dao.ChannelDao:getChannelCode",[ channelCode ],function(reply){
			data = reply.getResult();
			if(0 != data.CODE_NUM && channelCode != before){
				alert("编码已存在,请重新输入");
				save = 1;
			}else{
				save = 2;
			}
		});
	});
	
});

function closeDialog(){
	//history.go(-1);
	//parent.art.dialog.get("channel").close();
	if ('add' == oper) {
		parent.art.dialog.get("addChannel").close();
	}
	if ('edit' == oper) {
		parent.art.dialog.get("editChannel").close();
	}
}
function getChannel() {
	ajax.remoteCall(path + "/com.pytech.timesgp.web.dao.ChannelDao:getChannel",[ '${param.CHANNEL_ID}' ], function(reply) {
				var data = reply.getResult();
				Form.mapToForm('dataForm', data);
				before = data.CHANNEL_CODE;
			});
}
function saveOrUpdate() {
	if (!Form.checkForm('dataForm')) {
		return;
	}
	var postData = Form.formToMap('dataForm');
	var serviceUrl = null;
	if(1 == save){
		alert("编码已存在或超出范围,请重新输入");
		return false;
	}
	
	if (postData["oper"] == 'edit') {
		serviceUrl = "${path}/com.pytech.timesgp.web.dao.ChannelDao:updateChannel";
	} else {
		serviceUrl = "${path}/com.pytech.timesgp.web.dao.ChannelDao:addChannel";
	}
	//postData["ORG_ID"]=selector.selectedNode?selector.selectedNode.id:"";
	ajax.remoteCall(serviceUrl, [ postData ], function(reply) {
		var data = reply.getResult();
		dialogUtil.alert(data.msg, function() {
			if (data.success == true) {
				//history.go(-1);
				//parent.art.dialog.get("channel").close();
				//parent.location.reload(false);
				//alert(parent.reloadabc)
				//artDialog.opener.reloadGrid('grid');
				closeDialog();
			}
		});
	});
}
</script>
</head>
<body style="overflow: auto;">
<form action="" id=dataForm>
<input type="hidden" name="CHANNEL_ID" value="${param.CHANNEL_ID}"/>
<input type="hidden" name="oper" value="${param.oper}">
	<table width="90%" cellspacing="15" cellpadding="2">
	<!-- 
	<input type="hidden" id="ORG_ID" "/>
	 -->
		<tr>
			<td width="200px" class="label"><span class="require">*</span>频道名称:</td>
			<td width="300px">
				<ui:TextBox id="CHANNEL_NAME" caption="isnull:false;cname:名称"></ui:TextBox>
			</td>
			
			<%-- <td width="100px" class="label"><span class="require">*</span>编码:</td>
			<td width="300px">
				<ui:TextBox id="CHANNEL_CODE" caption="isnull:false;cname:编码"></ui:TextBox>
			</td> --%>
		</tr>
		<tr>
			<!-- <td width="100px" class="label">责任部门:</td>
			<td width="300px">
				<input class="textbox" id="ORG_NAME" name="ORG_NAME">
			</td> -->
			<td width="200px" class="label">序号:</td>
			<td width="300px">
				<ui:TextBox id="ORDER_SEQ"></ui:TextBox>
			</td>
		</tr>
	</table>
</form>
<div style="width: 100%;text-align: center">
	<br>
	<c:if test="${'view' != param.oper}">
	<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
	</c:if>
	<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
</div>
</body>

</html>