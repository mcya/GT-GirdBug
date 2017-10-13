<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.SelectorDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request)%>"></c:set>
<%
	SelectorDao selector = new SelectorDao();
	selector.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	List<Map<String,Object>> list = selector.getAreadDatas();
	pageContext.setAttribute("lists", list);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base >
    
    <title>My JSP 'projLocation.jsp' starting page</title>
    <ui:Include tags="artDialog,sigmagrid,Select,DateTimePicker,zTree"></ui:Include>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

	<script type="text/javascript" src="js/infoquery.js"></script>
	<script type="text/javascript">
	/* 加载项目
	*/
	function selectProject(target){
		var orgId = target.val();
		$("#PROJECT").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getProjectByAreaId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#PROJECT").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#PROJECT").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}
	
	function getOnlineInfo(){
		var projId = $('#PROJECT').val();
		if(null == projId || '' == projId){
			alert('请先选择项目');
			return;
		}
		$('#contentFrame').attr("src","locationInfo.jsp?projId="+projId);
	}
	</script>
  </head>
  
  <body>
    <table style="padding: 0; margin: 0; padding-left: 10px;">
		<tr>
			<td>地区分公司:</td>
			<td width="152px">
				<select id="AREA" name="AREA" class="textbox" onchange="selectProject($(this))" style="width:100%">
					<option value="">--请选择--</option>
					<c:forEach var="list" items="${lists}">
						<option value="${list.ORG_ID}">${list.ORG_NAME}</option>
					</c:forEach>
				</select>
			</td>
			<td style="padding-left: 13px;">项目名称:</td>
			<td width="152px">
				<select id="PROJECT" name="PROJECT" class="textbox"  style="width:100%">
					<option value="">--请选择--</option>
				</select>
			</td>
			<td>
				 <span class="glyphicon glyphicon-search" aria-hidden="true"></span><button type="button" class="btn btn-default" onclick="getOnlineInfo()">查找</button>
			</td>
		</tr>
	</table>
	<div id="content">
		<iframe  width="100%" height="100%" id="contentFrame" src=""></iframe>
	</div>
  </body>
</html>
