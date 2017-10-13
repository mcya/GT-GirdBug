<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.SelectorDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>

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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>消息管理</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
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


#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 


</style>
<script type="text/javascript" src="js/news.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var CHANNEL_ID = '${param.CHANNEL_ID}';
	var rootId = '${user.orgCode}';
	var orgType = '${orgType}';
	var parameters = {"CHANNEL_ID":CHANNEL_ID};
	$(function(){
		$("ORG_TYPE").val(orgType);
		$("#tree").height($(window).height());
		var height = $(window).height()-$("#head").height();
		var width = $(window).width();
		$("#grid").height(height);
		$("#grid").width(width);
		initTree();
		$(window).resize(function() {
			var height = $(window).height()-$("#head").height();
			var width = $(window).width();
			$("#grid").height(height);
			$("#grid").width(width);
		});
	});

	function addMsg(){	
			dialogUtil.open("addMsg","新增消息",path+"/pages/sale/new/msgMgrEdit.jsp?oper=add",500,900,function(){
			});
	}


	function editMsg(){
		var records = getSelectedRecords('grid');
		if(records.length!=1){
			dialogUtil.alert('请选择一条记录进行修改！',true);
			return false;
		}
		//window.location.href="channelEdit.jsp?oper=edit&CHANNEL_ID="+records[0].CHANNEL_ID;
		var editPjorData = []
		editPjorData.push(records[0].ORGID)
		editPjorData.push(records[0].PROJNAME)
		editPjorData.push(records[0].PROJID)
		editPjorData = JSON.stringify(editPjorData)
        window.localStorage.setItem("editPjorData", editPjorData)
		dialogUtil.open("editMsg","修改消息",path+"/pages/sale/new/msgMgrEdit.jsp?oper=edit&NEWS_ID="+records[0].NEWS_ID,500,900,function(){
			reloadGrid('grid');
		});
	}


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

	/* 加载销售组
	*/
	function selectGroup(target){
		console.log('1111~~1111111')
	}

</script>
</head>
<body>
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
			<div id="head" style="margin-left: 10px;">
				<form action="" id="queryForm">
				<%-- <input type="hidden" name="CHANNEL_ID" value="${param.CHANNEL_ID}"/> --%>
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



							<td>栏目:</td>
							<td><ui:TextBox id="CHANNEL_NAME"></ui:TextBox></td>
							<td>作者:</td>
							<td><ui:TextBox id="NEWS_AUTHOR"></ui:TextBox></td>
							
							<td>
							    <ui:Button btnType="query" onClick="queryy()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
							</td>
						</tr>
					</table>
				</form>
				<div id="buttons">
						<ui:Button onClick="javascript:addMsg();" functionId="channel_user" btnType="add">新增</ui:Button>
						<ui:Button onClick="javascript:editMsg();" functionId="channel_user" btnType="edit">修改</ui:Button>
						<ui:Button onClick="javascript:deleteMsg();" functionId="channel_user" btnType="delete">删除</ui:Button>
						<!--<ui:Button onClick="javascript:editDept();" functionId="channel_user" btnType="tree">调整责任部门</ui:Button>-->
				</div>
			</div>
			<div id="box">
				<ui:Grid 
			id="grid"
			dataProvider="${path}/com.pytech.timesgp.web.query.MsgQuery"
			parameters="{issen:1}"
			singleSelect="true"
			style="">
			<ui:GridField id="NEWS_ID" width="50"  header="消息id" checkColumn="true"></ui:GridField>
			<ui:GridField id="PROJNAME" width="200" header="所属项目" toolTip="true" align="center"/>
			<ui:GridField id="CHANNEL_NAME" width="100" header="所属栏目" toolTip="true" align="center"/>
			<ui:GridField id="MAIN_TITLE" width="250" header="标题" align="center" toolTip="true"></ui:GridField>
			<ui:GridField id="READ_COUNT" width="100" header="阅读人数" toolTip="true" align="center"/>
			<ui:GridField id="CREATE_TIME" width="200" header="创建时间" align="center"></ui:GridField>
			<%-- <ui:GridField id="NEWS_AUTHOR" width="100" header="作者"  align="center"/> --%>
			<ui:GridField id="NEWS_STATUS" width="100" header="状态" renderer="status" align="center"/>
			</ui:Grid>		
			</div>
		</div>
	</div>
</body>
</html>