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
<title>项目保护期管理</title>
<ui:Include tags="sigmagrid,artDialog,dhtmlxtoolbar,zTree,Select"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
.dk_toggle {
	line-height: 24px;
	display: -moz-inline-stack;
	display: inline-block;
	position: relative;
	zoom: 1;
	height: 24px;
	padding-top: 0px;
	padding-bottom: 0px;
	vertical-align: center;
}
.dk_options a {
    background-color: rgb(255, 255, 255);
    border-bottom: 1px solid rgb(153, 153, 153);
    padding: 0px 10px;
}
</style>
<script type="text/javascript" src="js/projprotect.js"></script>
<script type="text/javascript" src="js/initTree.js"></script>
<script type="text/javascript" src="js/jquery.tagsinput.js"></script>
<script type="text/javascript">
var mypath = '${path}';
var rootId = '${user.orgCode}';
var userCode = '${user.userCode}';
var userName='${user.userName}';
var userOrgId='${user.orgId}';

</script>
<script type="text/javascript">
var path = '${path}';
var parameters = {};
var columns = [{
	id : "ORG_ID",
	header : "项目编码",
	headAlign : 'center',
	align : 'center',
	isCheckColumn : false,
	exportable : false
}, {
	id : "ORG_NAME",
	header : "项目名称",
	width :250,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "PROJECT_DAYS",
	header : "客户保护期天数",
	width :200,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true,
	editor: { type:"text",validRule:['R','I'] }
},{
	id : "FOLLOW_REMIND_DAYS",
	header : "跟进提醒周期",
	width :200,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true,
	editor: { type:"text",validRule:['R','I'] }
}];
$(function() {
	var height = $(window).height() - $("#head").height()-8;
	var width = $(window).width()-$('#treePanel').width() - 1;

	$("#grid").height(height);
	$("#grid").width(width);
	loadGrid('grid', path + '/com.pytech.timesgp.web.query.ProjectProtectQuery',
		columns, parameters,
		{ autoLoad : true,
		  afterEdit:function(value,  oldValue,  record,  col,  grid) {//编辑表格后回调函数
			  if(oldValue==value)
				  return;
		  	  if(!isNum(value)) {
		  		  dialogUtil.alert("请输入正确的数字！",function(){
				  });
		  		  return;
		  	  }
			  ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.ProjectProtectDao:updateProjectProtection",[record.ORG_ID,value,col.id],function(reply){
			  		reloadGrid('grid');
					var data = reply.getResult();
					dialogUtil.alert(data.msg,function(){
					});
				}); 
		  },
		  toolbarContent:false
		});
	$(window).resize(function() {
		height = $(window).height() - $("#head").height()-8;
		$("#grid").height(height);
		width = $(window).width()-$('#treePanel').width() - 1;
		$("#grid").width(width);
	});
});
 function isNum(num){
    var reNum =/^[0-9]+$/;
    return (reNum.test(num));
 }
</script>
</head>
<body style="padding: 0;margin: 0px;overflow: auto;">
	<div id="baseContainer" style="overflow: hidden;">
		<div id="content" style="float: left;">
			<div id="head"  style="padding-left:10px;padding-bottom:6px;">
				<form action="" id="queryForm">
				<table style="text-align: right;line-height: 2.5;">
					<tr>
						<%-- <td>项目名称:</td>
						<td style="width:150px;">
							<ui:Select
								serviceId="com.pytech.timesgp.web.query.ProjectSelect"
								parameter="{'orgType':'${orgType}'}" id="PROJECT" style="width:150px;"
								caption="isnull:false;cname:项目">
							</ui:Select>
						</td>
						<td style="padding-left:10px;">
							<ui:Button btnType="query" onClick="query()">查询</ui:Button>
							<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button></td>
						<td>	
						</td>
						<td>
						</td> --%>
					</tr>
				</table>
				</form>
				<div id="buttons">
					<font color="red">点击列的‘客户保护期天数’、'跟进提醒周期'单元格可修改对应项目的客户保护期天数和跟进提醒周期</font>
					 <%-- <ui:Button onClick="javascript:addOp();" btnType="add">新增</ui:Button> --%>
					 <%-- <ui:Button onClick="javascript:deleteOp();" btnType="delete">删除</ui:Button> --%>
					 <%-- <ui:Button onClick="javascript:editOp();" btnType="edit">修改</ui:Button> --%>
				</div>
			</div>
			<div id="box">			
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>