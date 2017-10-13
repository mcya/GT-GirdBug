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
<title>电子认购书</title>
<ui:Include tags="sigmagrid,artDialog,DateTimePicker"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/index.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {"CHANNEL_ID":CHANNEL_ID};
	$(function(){
		var columns = [{
			id: 'ID',
			header: 'ID',
			width: 50,
			align : 'center',
			isCheckColumn: true
		}, {
			id : "ROOMNAME",
			header : "房间",
			width :150,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "ORDERID",
			header : "订单编号",
			width :250,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "CUST_NAME",
			header : "客户名称",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "CUST_MOBILE",
			header : "电话号码",
			width :150,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "ATTACH_NAME",
			header : "附件名称",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "CRATED",
			header : "创建时间",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "SDATE",
			header : "审核时间",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "STATUS",
			header : "状态",
			width :100,
			align : 'center',
			type :'string',
			renderer: statusFanyi,
			toolTip:true
		}, {
			id : "CREATE_USER",
			header : "销售人员名称",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}, 
		 {
			id : "caozuo",
			header : "预览",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true,
			renderer: yulan,
		},  
		
		{
			id : "xiazai",
			header : "下载",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true,
			renderer: xiazai,
		}];
		var height = $(window).height()-$("#head").height();
		var width = $(window).width();
		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', path + '/com.pytech.timesgp.web.query.PdfQuery',
				columns, parameters, {
					singleSelect: false
				});
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height();
			var width = $(window).width();
			$("#grid").height(height);
			$("#grid").width(width);
		});
		 $("#grid").on('click', '#yulanButton', function(e){
			qingchu(e)
			var value = $(this).attr('name')
			yulanFunction(value)
		}) 
		//下载
			$("#grid").on('click', '#xiazaiButton', function(e){
			qingchu(e)
			var value = $(this).attr('name')
			var yvalue = value.split(",")
			if (yvalue[2]==0) {
				dialogUtil.alert("未审核状态不能下载");
				return;
			}
			// console.log('value', value, yvalue)
			window.open(path+"\/pages\/params\/dianzirengoushu\/linkPdf.jsp?filepath="+yvalue[1]);
		})

		//预览
		function yulanFunction(value) {
			 console.log(value)
			 var paramss = {
				filepath: value
			}
			// 本地测试
			// var data = '1222'
			// yl(data)
			ajax.remoteCall(path+
						"/com.pytech.timesgp.web.dao.AttendanceDao:pdfzpng",
						[paramss],
						function(reply){
							// reloadGrid('grid'); 
							var data = reply.getResult();
							console.log('获取到的参数', data, reply)
							yl(data)
						}); 
			 return;
		 } 
		function yl(data){
	        var yulanUrl = JSON.stringify(data)
	        window.localStorage.setItem("yulanUrl", yulanUrl) 
	        // window.open('/times-web/pages/params/my.jsp')
	        dialogUtil.open("zaixianyulan","电子认购书在线预览","/times-web/pages/params/mypdf.jsp",600,1000,function(){
			    reloadGrid('grid');
			});
		 } 
		function qingchu(e) {
			window.event ? window.event.cancelBubble = true : e.stopPropagation();
			window.event ? window.event.returnValue = false : e.preventDefault();
		}
	/* 	function xiazaiFunction(value) {
			var dataArr = value.split(",")
			var paramsData = {
				ATTACH_NAME: dataArr[0],
				ATTACH_PATH: dataArr[1]
			}
			ajax.remoteCall(path+
				"/com.pytech.timesgp.web.dao.AttendanceDao:downloadRgs",
				[paramsData],
				function(reply){
					reloadGrid('grid');
					var data = reply.getResult();
					dialogUtil.alert(data.msg,function(){
				});
			});
		} */
		 
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
			<div id="head">
				<div style="height: 25px"></div>
				<form action="" id="queryForm">
				<input type="hidden" id="ORG_TYPE" name="ORG_TYPE" value='${orgType}'>
					<table>
						<tr>
							<td>客户名称:</td>
							<td><ui:TextBox id="CUST_NAME"></ui:TextBox></td>
							<td>房间:</td>
							<td><ui:TextBox id="ROOMNAME"></ui:TextBox></td>
							<td>订单编号:</td>
							<td><ui:TextBox id="ORDERID"></ui:TextBox></td>
							<td>创建时间:</td>
							<td width="150px">
								<ui:DateTimePicker format="YYYY-MM-DD"
									id="CRATED" style="width:150px">
								</ui:DateTimePicker>
							</td>
							<td>审核时间:</td>
							<td width="150px">
								<ui:DateTimePicker format="YYYY-MM-DD"
									id="SDATE" style="width:150px">
								</ui:DateTimePicker>
							</td>
						</tr>
						<tr>
							<td style="padding-left:10px;padding-top:2px" colspan="4">
						     	<ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="edit"
									onClick="javascript:shenhe();" id="btn_excel"
									btnText="审核">审核</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div style="height: 18px"></div>
			</div>
			<div id="box">
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>