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
<title>客户资料</title>
<ui:Include tags="sigmagrid,artDialog,DateTimePicker"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<script type="text/javascript" src="js/index.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var parameters = {"TYPE":'合照'};
	$(function(){
		var columns = [{
			id: 'GROUPID',
			header: 'ID',
			width: 50,
			align : 'center',
			isCheckColumn: true
		},  {
			id : "CUST_NAME",
			header : "客户名称",
			width :150,
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
			id : "ROOMNAME",
			header : "房间",
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
			id : "TYPE",
			header : "类型",
			width :100,
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
			header : "审核状态",
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
		},{
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
		loadGrid('grid', path + '/com.pytech.timesgp.web.query.CustQuery',
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

		$("#grid").on('click', '#xiazaiButton', function(e){
			qingchu(e)
			var value = $(this).attr('name')
			var yvalue = value.split(",")
			if (yvalue[2]==0) {
				dialogUtil.alert("未审核状态不能下载");
				return;
			}
			// console.log('value', value, yvalue)
			window.open(path+"\/pages\/params\/kehuziliao\/linkPdf.jsp?filepath=/home/asiainfo1/lww/Documents"+yvalue[1]);
			//window.open(path+"\/pages\/params\/kehuziliao\/linkPdf.jsp?filepath=E:\\workspace\\times-web\\WebContent\\pages\\params\\kehuziliao\\1.pdf");
			//xiazaiFunction(value);
		})

		function qingchu(e) {
			window.event ? window.event.cancelBubble = true : e.stopPropagation();
			window.event ? window.event.returnValue = false : e.preventDefault();
		}
		function xiazaiFunction(value) {
			console.log(value)
			// window.open(path+'/pages/params/kehuziliao/linkPdf.jsp?filepath=E:\\workspace\\times-web\\WebContent\\pages\\params\\kehuziliao\\1.pdf');
		// window.open('E:\\workspace\\times-web\\WebContent\\pages\\params\\kehuziliao\\1.pdf');
			// window.open(path+'/pages/params/dianzirengoushu/linkPdf.jsp?filepath='+value);
				
		}
		 function yulanFunction(value) {
				console.log(value)
				// debugger;
			 var yulanUrl = []
			yulanUrl.push("/home/asiainfo1/lww/Documents"+value)
			yulanUrl = JSON.stringify(yulanUrl)
			window.localStorage.setItem("yulanUrl", yulanUrl) 
			dialogUtil.open("zaixianyulan","在线预览","/times-web/pages/params/my.jsp",600,1000,function(){
			    reloadGrid('grid');
			}); 
		} 
	});

	function quickSearch(obj){
		var val = $(obj).attr("val");
		$(obj).siblings(".selected").removeClass("selected");
		$(obj).addClass("selected");
		queryy();
	}

</script>
<script type="text/javascript">

</script>
</head>
<body>
	<div id="quickSearch" class="queryview" style="padding-left:10px;">
		<span style="font-weight: bold;padding-left:10px;">快速查询</span>&nbsp;&nbsp;&nbsp;
		<span class="normal selected" val="合照" onclick="quickSearch(this)">合照</span>&nbsp;&nbsp;&nbsp;
		<span class="normal" val="身份证" onclick="quickSearch(this)">身份证</span>&nbsp;&nbsp;&nbsp;
	</div>
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
							<td>附件名称:</td>
							<td><ui:TextBox id="ATTACH_NAME"></ui:TextBox></td>
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
						     	<ui:Button btnType="query" onClick="queryy()">查询</ui:Button>
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