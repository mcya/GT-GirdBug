<%@page import="com.pytech.timesgp.web.query.NoSyncInfoQuery"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="info" value='<%=new NoSyncInfoQuery().getDealInfo(request.getParameter("tipId")) %>'></c:set>
<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<c:set var="pwd" value="<%=AppHandle.getCurrentUser(request).getUserPwd() %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>structure</title>
<ui:Include tags="sigmagrid,artDialog,Select,DateTimePicker"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
.label {
	text-align: center
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
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">
		var path = '${path}';
		function closeDialog(){
			parent.art.dialog.get("dealInfo").close();
		}
		
		function isCloseTip() {
			
			if(idx==0) {
				ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.BindDealCustDao:removeTip",[{'tipId':'${param.tipId}'}],function(reply){
				},function(){});
			}
		}
		
		$(function(){
			var height = $(window).height()+50;
			var width = $(window).width()-$("#treePanel").width()-1;
			$("#grid").height(615);
			$("#grid").width(width);
			$(window).resize(function() {
				height = $(window).height()+50;
				$("#grid").height(615);
				width = $(window).width()-$('#treePanel').width() - 1;
				$("#grid").width(width);
			});
		});
		var idx = 0;
		function opRender(value, record, columnObj, grid, colNo, rowNo) {
			
			var custName = record.custName;
			var custCard = record.custCard;
			var custId = record.custId;
			var opFlag = record.DEAL_FLAG;
			if(opFlag==undefined)
				return;
			if(opFlag==0) {//完善资料并执行绑定操作
				idx++;
				return "<span onclick='bindInfo(\""+custId+"\",\""+custName+"\",\""+custCard+"\")' style='color:red;cursor:pointer'>未绑定</span>&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<span onclick='editInfo(\""+custId+"\",\""+custName+"\",\""+custCard+"\", 2)' style='color:blue;cursor:pointer'>编辑信息</span>";
			}
			return "<span style='color:blue;cursor:pointer' onclick='succTip()'>已绑定</span>&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<span onclick='editInfo(\""+custId+"\",\""+custName+"\",\""+custCard+"\", 1)' style='color:blue;cursor:pointer'>查看信息</span>";
		}
		
		function succTip() {
			dialogUtil.alert('已绑定成功！',function(){
			},function(){});
		}
		function bindInfo(custId, custName, custCard) {
			var params = Form.formToMap('dataForm');
			params.custId = custId;
			params.custName = custName;
			params.custCard = custCard;
			params.idx = idx;
			params.tipId = '${param.tipId}';
			//1,更新客户表 //2,插入客户成交表
			ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.BindDealCustDao:bindNewDeal",[params],function(reply){
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					if(data.success) 
						reloadGrid('grid');
				},function(){});
			});
		}
		function editInfo(custId, custName, custCard, flg) {
			var postData = Form.formToMap('dataForm');
			/* var params = "";
			for(var i in postData)
				params = params + "&" + i + "=" + postData[i]; */
			window.location.href=path+"/pages/client/clientDetail.jsp?id="+custId+"&custName="+custName+"&custCard="+custCard+"&op="+flg;
			//dialogUtil.open("clientDetail","查看人员信息",path+"/pages/client/clientDetail.jsp?id="+id+"&op="+flg,heit,1000,function(){});
		}
	</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="dataForm" style="">
		<input type="hidden" name="orgId" id="orgId" value="${info.orgId }">
		<input type="hidden" name="saleId" id="saleId" value="${info.saleId }">
		<input type="hidden" name="projGuid" id="projGuid" value="${info.projGuid }">
		<table width="100%" cellspacing="2" align="left" cellpadding="2" style="margin-top: 5px;padding-left:5px;margin-bottom:5px;padding-right:5px">
			<tr>
				<td width="150px" class="label" style="">销售员:</td>
				<td>
					<ui:TextBox id="SALER" readOnly="true" caption="isnull:false;cname:销售员" style="width:150px" value="${info.saleName }"></ui:TextBox>
				</td>
				<td width="150px" class="label" style="">成交日期:</td>
				<td>
					<ui:TextBox id="DEAL_DATE" readOnly="true" caption="isnull:false;cname:成交日期" style="width:150px" value="${info.dealTime }"></ui:TextBox>
				</td>
				<td width="150px" class="label" style="">成交总价:</td>
				<td>
					<ui:TextBox id="DEAL_PRICE" readOnly="true" caption="isnull:false;cname:成交总价" style="width:150px" value="${info.price }"></ui:TextBox>
				</td>
				<td width="150px" class="label" style="">付款方式:</td>
				<td>
					<ui:TextBox id="PAY_WAY" readOnly="true" caption="isnull:false;cname:付款方式" style="width:150px" value="${info.payForm }"></ui:TextBox>
				</td>
			</tr>
			<tr>
				<td width="150px" class="label" style="">楼栋号:</td>
				<td>
					<ui:TextBox id="BUILD_NO" readOnly="true" caption="isnull:false;cname:楼栋号" style="width:150px" value="${info.unit }"></ui:TextBox>
				</td>
				<td width="150px" class="label" style="">单元号:</td>
				<td>
					<ui:TextBox id="UNIT_NO" readOnly="true" caption="isnull:false;cname:单元号" style="width:150px" value="${info.floor }"></ui:TextBox>
				</td>
				<td width="150px" class="label" style="">房间号:</td>
				<td>
					<ui:TextBox id="HOUSE_NO" readOnly="true" caption="isnull:false;cname:房间号" style="width:150px" value="${info.room }"></ui:TextBox>
				</td>
			</tr>
		</table>
		<div id="box">			
			<ui:Grid  id="grid" autoLoad="true" dataProvider="${path}/com.pytech.timesgp.web.query.NoSyncInfoQuery" parameters="{tipId:'${param.tipId }'}" showToolbar="false"  showIndexColumn="true" singleSelect="true" style="">
				<ui:GridField id="custGuid" width="200"  header="客户编码" checkColumn="true"></ui:GridField>
				<ui:GridField id="custName" width="200" header="客户名称" toolTip="true" align="center"/>
				<ui:GridField id="custCard" width="200" header="证件号码" align="center" toolTip="true"></ui:GridField>
				<ui:GridField id="custId" width="200" renderer="opRender" header="操作" toolTip="true" align="center"/>
			</ui:Grid>			
		</div>
	</form>
</body>
</html>