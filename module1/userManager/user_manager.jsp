<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>销售管理</title>
<ui:Include tags="sigmagrid,artDialog,zTree"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="user_manager.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var rootId = '${user.orgCode}';
	var parameters = {};
	
	// button methods.......
	function query() {
		var map = Form.formToMap('queryForm');
		
		var params = parameters;
		for ( var key in map) {
			params[key] = map[key];
		}
		var nodes = zTree.getSelectedNodes();
	  	var orgId = nodes[0].id;
	 // 	var types = nodes[0].tpye;
	//  	alert(JSON.stringify(nodes));
	 //	alert(nodes[0].type);
		params['ORG_ID'] = orgId;
		reloadGrid('grid', params);
	}
	
	$(function() {
		$("#tree").height($(window).height());
		initTree();
		
		var height = $(window).height() - $("#head").height()-7;
		var width = $(window).width()  - $("#treePanel").width()-2;

		$("#grid").height(height);
		$("#grid").width(width);
		$(window).resize(function() {
			
			height = $(window).height() - $("#head").height()-7;
			$("#grid").height(height);
			width = $(window).width()-$("#treePanel").width()-1;
			$("#grid").width(width);
		});

		loadGrid('grid', path + '/com.pytech.timesgp.web.query.UserQuery',
				columns, parameters,{
					autoLoad : false,
					singleSelect:true
				});
	});
	
	/**
	 * 弹出添加对话框
	 */
	function add(){
		var nodes = zTree.getSelectedNodes();
	  	var orgId = nodes[0].id;
		dialogUtil.open("user","添加人员",path+"/pages/module1/userManager/userEdit.jsp?orgId="+orgId,490,490,function(){});
	}
	/**
	 * 弹出导入对话框
	 */
	function importSallee(){
		var nodes = zTree.getSelectedNodes();
	  	var orgId = nodes[0].id;
	  	var prj ='PROJECT';
	  	if(nodes[0].type==prj){
		dialogUtil.open("salleeImport","销售成员导入",path+"/pages/module1/userManager/importAdd.jsp?orgId="+orgId,450,590);
	  	}
	  	else
	  		dialogUtil.alert('请选择一个项目进行修改！',true);
	}

	/**
	 * 弹出修改对话框
	 */
	function update(){
		var nodes = zTree.getSelectedNodes();
	  	var orgId = nodes[0].id;
		var records = getSelectedRecords('grid');
		if(records.length!=1){
			dialogUtil.alert('请选择一条记录进行修改！',true);
			return false;
		}
		var id = records[0].USER_MOBILE;
		dialogUtil.open("user","修改人员信息",path+"/pages/module1/userManager/userEdit.jsp?oper=edit&USER_MOBILE="+id,490,490,function(){
		});
	}
</script>


</head>
<body style="padding: 0; margin: 0px;overflow: hidden;">
	
	<div id="baseContainer" style="overflow: hidden;">
		
		<div id="treePanel" style="overflow: hidden;">
			<div id="mgrbtn" style="padding-left: 3px;display:none"></div>
			<div id="searchContanter" style="height: 30px; width: 100%; margin-top: 0px; padding-top: 2px; margin-left: 0px;display: none">
				<span><input id="search_str" name="search_str" type="text" class="textbox" style="width:150px"/></span>
				<input type="button" value="搜索" onclick="doSearch();" class="sbtn"/>
			</div>
			<div id="tree" class="ztree" style="padding: 5px 0px 0px 0px; margin: 0px; width: 200px; overflow: auto; background-color: #fff; border-top: 0px solid #c6dcf1;"></div>
		</div>
		
		
		<div id="content" style="float: left;">
			<div id="head" style="padding-left:10px;padding-bottom:6px">
			<form action="" id="queryForm">
					<div style="display: none;">
						<input id="ORG_ID" name="ORG_ID"/>
						<input id="orgName"/>
						<input id="orgCode"/>
						<input id="busiCode"/>
					</div>	
				<table>
					<tr>
						<td>姓名:</td>
							<td><ui:TextBox id="USER_NAME"></ui:TextBox></td>
						<td style="padding-left:10px;">
							<ui:Button btnType="query" onClick="javascript:query();">查询</ui:Button>
							<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>
						</td>
					</tr>
				</table>
				</form>
				<div id="buttons">
					<!--<ui:Button onClick="javascript:add();" btnType="add">新增</ui:Button>
					<%-- <ui:Button onClick="javascript:view();" btnType="view">查看</ui:Button> --%>
					<ui:Button onClick="javascript:update();" btnType="edit">修改</ui:Button>
					<ui:Button onClick="javascript:deleteUser();" btnType="delete">删除</ui:Button>-->
					<ui:Button onClick="javascript:adjust();" btnType="tree">调整销售组</ui:Button>
					<!--<ui:Button onClick="importSallee();" btnType="import">导入</ui:Button>-->
				</div>
			</div>
			<div class="box">
				<div id="grid"></div>
			</div>
			
		</div>
	</div>
	
</body>
</html>