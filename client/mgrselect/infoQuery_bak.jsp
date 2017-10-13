<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag" %>
<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>客户信息查询</title>
<ui:Include tags="sigmagrid,artDialog,dhtmlxtoolbar,Select"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#head{
   border: 1px solid #e1e7f5;
}
.head_fen{
   margin-left: 20px;
   line-height: 32px;
   font-weight: 400;
   border-top: 1px dotted #e1e7f5;
}
.head_fen h4{
     width: 120px;
     float: left;   
}
.head_fen ul{
     list-style-type:none;
}
a{
    text-decoration: none;
    color: #2953a6;
}
a:HOVER {
 	text-decoration: underline;
	color: #F7421C;
}
.queryview{
   background:none !important;
   line-height: 12px;
   font-weight: 400;
   border-top: 1px dotted #e1e7f5;
   padding-left: 10px;
} 
.normal{
     margin-right: 35px;
     text-decoration: none !important;
}
.queryview span.normal:HOVER {
	color: #F7421C;
}
.queryview span {
    cursor: default;
}
.queryview span.normal {
    cursor: pointer;
}
</style>
<script type="text/javascript" src="js/infoquery.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var userCode = '${user.userCode}';
var parameters = {};
var path = '${path}';
$(function(){
	var height = $(window).height()-$("#head").height()-3;
	var width = $(window).width();
	$("#grid").height(height);
	$("#grid").width(width);
});
</script>
</head>
<body style="padding: 0;margin: 0px;overflow: auto;">
	
	<div id="head">
		<form action="" id="queryForm">
			<input type="hidden" id="CUTO_TYPE" name="CUTO_TYPE">
			<input type="hidden" id="CUTO_FROM" name="CUTO_FROM">
			<input type="hidden" id="CUTO_INTE" name="CUTO_INTE">
			<input type="hidden" id="CUTO_COM" name="CUTO_COM">
			<input type="hidden" id="CUTO_TAG" name="CUTO_TAG">
			<div class="queryview">
				<span style="font-weight: bold;margin-right: 50px;">客户类型:</span>
				<span class="normal selected" for="CUTO_TYPE" onclick="changeScope(this, '')">不限</span>
				<span class="normal" for="CUTO_TYPE" onclick="changeScope(this, '0')">未来访</span>
				<span class="normal" for="CUTO_TYPE" onclick="changeScope(this, '1')">已来访</span>
				<span class="normal" for="CUTO_TYPE" onclick="changeScope(this, '2')">已成交</span>
			</div>
			<div class="queryview">
				<span style="font-weight: bold;margin-right: 50px;">客户来源:</span>
				<span class="normal selected" for="CUTO_FROM" onclick="changeScope(this, '')">不限</span>
			    <span class="normal" for="CUTO_FROM" onclick="changeScope(this, '自来客')">自来客</span>
			   	<span class="normal" for="CUTO_FROM" onclick="changeScope(this, '业主介绍')">业主介绍</span>
			   	<span class="normal" for="CUTO_FROM" onclick="changeScope(this, '拓展')">拓展</span>
		    </div>	
		    <div class="queryview">
			    <span style="font-weight: bold;margin-right: 50px;">沟通阶段:</span>
				<span class="normal selected" for="CUTO_COM" onclick="changeScope(this, '')">不限</span>
	            <span class="normal" for="CUTO_COM" onclick="changeScope(this, '了解项目')">了解项目</span>
	            <span class="normal" for="CUTO_COM" onclick="changeScope(this, '看板房')">看板房</span>
	            <span class="normal" for="CUTO_COM" onclick="changeScope(this, '议价')">议价</span>
	            <span class="normal" for="CUTO_COM" onclick="changeScope(this, '下筹')">下筹</span>
	            <span class="normal" for="CUTO_COM" onclick="changeScope(this, '成交')">成交</span>
			</div>
			<div class="queryview">
			   	<span style="font-weight: bold;margin-right: 50px;">成交意向:</span>
			   	<span class="normal selected" for="CUTO_INTE" onclick="changeScope(this, '')">不限</span>
				<span class="normal" for="CUTO_INTE" onclick="changeScope(this, 'A')">A级</span>
				<span class="normal" for="CUTO_INTE" onclick="changeScope(this, 'B')">B级</span>
				<span class="normal" for="CUTO_INTE" onclick="changeScope(this, 'C')">C级</span>
			</div>
			<div class="queryview">
			   	<span style="font-weight: bold;margin-right: 50px;">公客标记:</span>
			   	<span class="normal selected" for="CUTO_TAG" onclick="changeScope(this, '')">不限</span>
				<span class="normal" for="CUTO_TAG" onclick="changeScope(this, '1')">公客</span>
				<span class="normal" for="CUTO_TAG" onclick="changeScope(this, '0')">非公客</span>
			</div>
			<div style="padding-left:10px;padding-bottom:2px;padding-top:2px">
				<table>
					<tr>
						<td>姓名:</td>
						<td><ui:TextBox id="CUST_NAME"></ui:TextBox></td>
						<td style="padding-left:10px">销售组:</td>
						<td style="width:180px"><ui:Select serviceId="com.pytech.timesgp.web.query.FollowGroupSelect"  id="groupName"></ui:Select></td>
						<td>&nbsp;</td>
						<td>
							<ui:Button btnType="query" onClick="javascript:gridQuery();">查询</ui:Button>
							<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
							<ui:Button btnType="excel" onClick="javascript:exportClientList();">导出客户列表</ui:Button>
							<ui:Button btnType="excel" onClick="javascript:exportClientList();">导出客户全信息</ui:Button>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</div>
	<div id="box">
		<ui:Grid id="grid" dataProvider="${path}/com.pytech.timesgp.web.query.ClientQuery" parameters="{issen:1}" style="" singleSelect="true">
			<ui:GridField id="CUST_ID" width="0"  header="客户id" checkColumn="true"></ui:GridField>
			<ui:GridField id="CUST_NAME" width="100" header="姓名" toolTip="true" align="center"/>
			<ui:GridField id="CUST_SEX" width="150" header="性别" renderer="issex" align="center" toolTip="true"></ui:GridField>
			<ui:GridField id="CUST_MOBILE" width="200" header="手机号码" toolTip="true" align="center"/>
			<ui:GridField id="CUST_SOURCE" width="200" header="客户来源" align="center"></ui:GridField>
			<ui:GridField id="CUST_CHANNEL" width="100" header="拓展渠道"  align="center"/>
			<ui:GridField id="CUST_KNOW" width="100" header="获知途径" align="center"/>
			<ui:GridField id="CUST_NATION" width="80"  header="沟通阶段"></ui:GridField>
			<ui:GridField id="CUST_INTENTION" width="80" header="成交意向" toolTip="true" align="center"/>
			<ui:GridField id="INTENT_PRICE" width="150" header="意向总价" align="center" toolTip="true"></ui:GridField>
			<ui:GridField id="INTENT_AREA" width="200" header="意向面积" toolTip="true" align="center"/>
			<ui:GridField id="INTENT" width="200" header="购房目的" align="center"></ui:GridField>
			<ui:GridField id="PAY_WAY" width="100" header="付款方式"  align="center"/>
			<ui:GridField id="WORK_AREA" width="100" header="工作区域" align="center"/>
			<ui:GridField id="LIVE_AREA" width="100" header="居住区域" align="center"/>
			<ui:GridField id="CUST_INDUST" width="100" header="工作行业" align="center"/>
			<ui:GridField id="CRED_NO" width="100" header="证件号码" align="center"/>
			<ui:GridField id="CUST_SALE_STATUS" width="100" header="销售状态" renderer="ispublic" align="center"/>
			<ui:GridField id="CUST_ORG_ID" width="100" header="归属项目" align="center"/>
			<ui:GridField id="PUBLIC_FLAG" width="100" header="公客标记" renderer="ispublic" align="center"/>
			<ui:GridField id="FAIL_REASON" width="100" header="未成交原因" align="center"/>
			<ui:GridField id="VISIT_FLAG" width="100" header="来访标记" renderer="ispublic" align="center"/>
			<ui:GridField id="JOB_POSITION" width="100" header="工作职务" align="center"/>
		</ui:Grid>		
	</div>
</body>
</html>