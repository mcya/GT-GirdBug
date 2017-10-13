<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ include file="/pages/common/common.jsp" %>

<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>

<c:set var="path" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>通知邮箱设置</title>
<ui:Include tags="sigmagrid,artDialog"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/email.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {"CHANNEL_ID":CHANNEL_ID};
	$(function(){
		var columns = [{
			id: 'R_R',
			header: 'id',
			width: 50,
			align : 'center',
			isCheckColumn: true
		}, {
			id : "ORG_ID",
			header : "项目编码",
			width :300,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "ORG_NAME",
			header : "项目名称",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "USERNAME",
			header: "收件人",
			width:200,
			align : 'center',
			type :'string',
			toolTip:true,
			renderer:shoujianren,
		}, {
			id : "EMAIL",
			header : "邮箱",
			width :300,
			editor: { type:"text",validRule:['R','email'] },
			align : 'center',
			type :'string',
			toolTip:true
		}];
		var height = $(window).height()-$("#head").height();
		var width = $(window).width();
		$("#grid").height(height);
		$("#grid").width(width);


		function aa(){
		    var b = bb('1111xxxxx这是传参')
		    console.log('执行出来的', b)
		}
		aa();

		function bb(a){
			console.log('后面函数接收到的参数', a)
			return a
		}
		


		loadGrid('grid',
				path + '/com.pytech.timesgp.web.query.EmailQuery',
				columns,
				parameters,
				{
					singleSelect: true,
					autoLoad:true,
					afterEdit: function(value, oldValue, record, col, grid) {
						console.log('~~', 'value', value, 'oldValue', oldValue, 'record', record, 'col', col, 'grid', grid)
						var paramsData = {
							projid: record.ORG_ID,
							userids: record.USERID,
							emails: record.EMAIL
						}
						ajax.remoteCall(path+
							"/com.pytech.timesgp.web.dao.AttendanceDao:updateEmail",
							[paramsData],
							function(reply){
								reloadGrid('grid');
								var data = reply.getResult();
								dialogUtil.alert(data.msg,function(){
							});
						}); 
					}
				});
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height()+22;
			var width = $(window).width();
			$("#grid").height(height);
			$("#grid").width(width);
		});
		$('#grid').on('click', '#sjrButtonId', function(e){
			
			var value = $(this).attr('name')
			e.stopPropagation()
	 	   	openSjrTable(value)
		})
		$('#grid').on('click', '#sjrButtonIdAdd', function(e){
			
			var value = $(this).attr('name')
			e.stopPropagation()
	 	   	openSjrTableAdd(value)
		})

		// var abc = $('#sjrButtonId').attr('name')

		function openSjrTable(e, value) {
			window.event ? window.event.cancelBubble = true : e.stopPropagation();
			window.event ? window.event.returnValue = false : e.preventDefault();
			var records = getSelectedRecords('grid');
			console.log('records', records)
			window.location.href=path+'/pages/params/email/sjrSelect.jsp?orgid='+records[0].ORG_ID+'&username='+encodeURI(encodeURI(records[0].USERNAME))+'&projids='+records[0].ORG_ID+'&isAdd=0'+'&userids='+records[0].USERID;
		}
		function openSjrTableAdd(e, value) {
			window.event ? window.event.cancelBubble = true : e.stopPropagation();
			window.event ? window.event.returnValue = false : e.preventDefault();
			var records = getSelectedRecords('grid');
			console.log('records', records)
			window.location.href=path+'/pages/params/email/sjrSelect.jsp?orgid='+records[0].ORG_ID+'&username='+encodeURI(encodeURI(records[0].USERNAME))+'&projids='+records[0].ORG_ID+'&isAdd=1';
		}
		
	});




</script>
<script type="text/javascript">

</script>
</head>
<body>
	<form action="" id="" style="display: none">
	</form>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="box">
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>