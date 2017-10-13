<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.SelectorDao"%>
<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="year" value="<%=CommonUtil.getCurrentYear() %>"></c:set>
<c:set var="month" value="<%=CommonUtil.getCurrentMonth() %>"></c:set>
<c:set var="week" value="<%=CommonUtil.getCurrentWeek() %>"></c:set>
<c:set var="orgType" value="<%=AppHandle.getCurrentUser(request).getOrgType() %>"></c:set>
<%
	SelectorDao selector = new SelectorDao();
	selector.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	List<Map<String,Object>> list = selector.getAreadDatas();
	pageContext.setAttribute("lists", list);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>上班地点设置</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="js/waiqin.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var orgType = '${orgType}';
var parameters = {'YEAR':'${year}','MONTH':'${month}','WEEK':'${week}'-1,'ORG_TYPE':orgType};
	$(function() {
		$("ORG_TYPE").val(orgType);
		var columns = [
		{
			id: 'R_R',
			header: 'id',
			width: 50,
			align : 'center',
			isCheckColumn: true
		}, {
			id : "ORGNAME",
			header : "公司",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "PROJNAME",
			header : "项目",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "GROUPNAME",
			header: "小组",
			width:100,
			align : 'center',
			type :'string',
			toolTip:true,
		}, {
			id : "USERNAME",
			header : "人员",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		},{
			id : "ADDR",
			header : "上班地点",
			width :300,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "ATTENDTIME",
			header : "打卡时间",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "RANGE",
			header : "活动范围",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}];
		
		$("#tree").height($(window).height());
		
		var height = $(window).height() - $("#head").height();
		var width = $(window).width() - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', 
			path + '/com.pytech.timesgp.web.query.WqWorkplaceQuery',
			columns,
			parameters,
			{
				singleSelect: true,
				autoLoad : true,
		});
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+22;
			$("#grid").height(height);
			width = $(window).width() -1;
			$("#grid").width(width);
		});
	});
	
	


	/* 加载项目
	*/
	function selectProject(target){
		var orgId = target.val();
		$("#PROJNAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getProjectByAreaId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#PROJNAME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				if('${orgType}'=='PROJNAME')
					$("#PROJNAME").append('<option value="'+data[i].ORG_ID+'" selected="selected">'+data[i].ORG_NAME+'</option>');
				else
					$("#PROJNAME").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}

	/* 加载销售人员
	*/
	function selectPerson(target){
		var groupId = target.val();
		$("#USERNAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
		ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
			var data = reply.getResult();
			$("#USERNAME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#USERNAME").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
			}
		});
	}
	/* 加载销售组
	*/
	function selectGroup(target){
		var orgId = target.val();
		$("#GROUP_NAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getGroupByProjectId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#GROUP_NAME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#GROUP_NAME").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
			}
		});
	}
	




</script>
</head>
<body style="padding: 0; margin: 0px;">
	<form action="" id="" style="display: none">
	</form>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="treePanel" style="overflow: hidden;display:none">
			<div id="mgrbtn" style="padding-left: 3px;">
			</div>
			
			<div id="searchContanter" style="height: 30px; width: 100%; margin-top: 0px; padding-top: 2px; margin-left: 0px;display: none">
				<span>
					<ui:TextBox id="search_str" style="width:150px"></ui:TextBox>	
				</span>
				<input type="button" value="搜索" onclick="doSearch();" class="sbtn"/>
			</div>
			
			<div id="tree" class="ztree" style="padding: 5px 0px 0px 0px;margin: 0px; width: 200px; overflow: auto; background-color: #fff; border-top: 0px solid #c6dcf1;"></div>
		</div>
		<div id="content" style="float: left;">
			<div id="head"  style="padding-left:10px;padding-bottom:2px;padding-top:2px">
				<form action="" id="queryForm">
				<input type="hidden" id="ORG_TYPE" name="ORG_TYPE" value='${orgType}'>
					<table>
						<tr>
							<td style="padding-left:5px;">地区公司:</td>
							<td width="153px">
								<select id="ORG_NAME" name="ORG_NAME" class="textbox" onchange="selectProject($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.ORG_ID}" <c:if test="${orgType=='PROJNAME' }">selected="selected"</c:if>>${list.ORG_NAME}</option>
										<c:if test="${orgType=='PROJNAME' }">
											<script type="text/javascript">
											selectProject($('select#AREA'))
											</script>
										</c:if>
									</c:forEach>
								</select>
							</td>
							<td style="padding-left:5px;">项目名称:</td>
							<td width="153px">
								<select id="PROJNAME" name="PROJNAME" class="textbox" onchange="selectGroup($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left: 21px;">销售小组:</td>
							<td width="152px">
								<select id="GROUP_NAME" name="GROUP_NAME" class="textbox" onchange="selectPerson($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left: 13px;">销售人员:</td>
							<td width="152px">
								<select id="USERNAME" name="USERNAME" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>
					     		<ui:Button btnType="query" onClick="query()">查询</ui:Button>
							</td>
							<td>
							    <ui:Button btnType="add" onClick="javascript:addChannel()">新增</ui:Button>
							
								<ui:Button onClick="javascript:updateChannel();" btnType="edit">修改</ui:Button>
							</td>
							<td>
							    <ui:Button btnType="delete" onClick="javascript:deleteChannel()">删除</ui:Button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div id="box">
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>