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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>数据统计-全景图</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="clientAnalysis.js"></script>
<script type="text/javascript" src="../js/structureTypeTree.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var parameters = {'year':'${year}','orgType':'${orgType}','condition':''};
var orgType = '${orgType}';
	$(function() {
		$("#tree").height($(window).height());
		var height = $(window).height() - $("#head").height()+20;
		var width = $(window).width()-$('#treePanel').width() - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', 
			path + '/com.pytech.timesgp.web.query.AnalysisAllQuery',
			columns, parameters,{
				autoLoad : true,
				  toolbarContent:false,
				  pageSize:1000
			});
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+20;
			$("#grid").height(height);
			width = $(window).width()-$('#treePanel').width() - 1;
			$("#grid").width(width);
		});
	});
	
	function getMonthWeek(a, b, c) { 
		/* 
		a = d = 当前日期 
		b = 6 - w = 当前周的还有几天过完(不算今天) 
		a + b 的和在除以7 就是当天是当前月份的第几周 
		*/
		var date = new Date(a, parseInt(b) - 1, c), w = date.getDay(), d = date.getDate(); 
		return Math.ceil((d + 6 - w) / 7); 
	};
	
	// button methods.......
	function query() {
		var params = parameters;
		var nodes = zTree.getSelectedNodes();
		orgType = nodes[0].id;
		params.orgType = orgType;
		params.year =  $('#YEAR').val();
		params.condition = '';
		if(orgType=='CORP') {
			$('#tdName').text('分公司:');
			$('#tdSaler').css('display','none');
			$('#tdArea').css('display','');
			$('#tdProject').css('display','none');
			$('#tdProj4Saler').css('display','none');
			params.condition = $('#AREA').val();
		} else if(orgType=='AREA') {
			$('#tdName').text('');
			$('#tdProj4Saler').css('display','');
			$('#tdProject').css('display','');
			$('#tdSaler').css('display','none');
			$('#tdArea').css('display','none');
			params.condition = $('#PROJECT').val();
		} else if(orgType=='PROJECT') {
			$('#tdName').text('销售人员:');
			$('#tdSaler').css('display','');
			$('#tdProj4Saler').css('display','');
			$('#tdProject').css('display','');
			$('#tdArea').css('display','none');
			params.condition = $('#PROJECT').val();
			params.saler = $('#SALER').val();
		}
		var map = Form.formToMap('queryForm');
		for ( var key in map) {
			params[key] = map[key];
		}
		reloadGrid('grid', params);
	}
	
	/**
	 * 导出操作
	 */
	 function exportData(){
		 exportExcel("grid","AllReport");
	}
</script>
</head>
<body style="padding: 0; margin: 0px;">
	<form action="" id="" style="display: none">
	</form>
	<div id="baseContainer" style="overflow: hidden;">
		<div id="treePanel" style="overflow: hidden;">
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
			<div id="head"  style="padding-left:10px;padding-bottom:6px;padding-top:2px">
				<form action="" id="queryForm">
					<table>
						<tr>
					      	<td>年份:</td>
							<td  width="150px">
								<ui:Select serviceId="" id="YEAR" caption="isnull:false;cname:年份">
									<option value="2016" <c:if test="${2016==year}">selected="selected"</c:if>>2016年</option>
									<option value="2017" <c:if test="${2017==year}">selected="selected"</c:if>>2017年</option>
									<option value="2018" <c:if test="${2018==year}">selected="selected"</c:if>>2018年</option>
									<option value="2019" <c:if test="${2019==year}">selected="selected"</c:if>>2019年</option>
									<option value="2020" <c:if test="${2020==year}">selected="selected"</c:if>>2020年</option>
								</ui:Select>
							</td>
							<%-- <td style="padding-left:10px;">销售组:</td>
							<td width="150px">
								<ui:Select serviceId="com.pytech.timesgp.web.query.GroupSelect" id="GROUP" caption="isnull:false;cname:销售组"></ui:Select>
							</td> --%>
							<td id="tdProj4Saler" style="padding-left:10px;display:none">项目:</td>
							<td id="tdProject" width="150px" style="display:none">
								<ui:Select serviceId="com.pytech.timesgp.web.query.ProjectSelect" parameter="{'orgType':'${orgType}'}" id="PROJECT" caption="isnull:false;cname:项目">
								</ui:Select>
							</td>
							<td id="tdName" style="padding-left:10px;"></td>
							<td id="tdSaler" width="150px" style="display:none">
								<ui:TextBox id="SALER" style="width:150px"></ui:TextBox>
							</td>
							<td id="tdArea" width="150px" style="display:none">
								<ui:Select serviceId="com.pytech.timesgp.web.query.AreaSelect4AllAnalysis"  defaultValue="-1" id="AREA" parameter="{'orgType':'${orgType}'}" caption="isnull:false;cname:地区">
								</ui:Select>
							</td>
							<td style="padding-left:10px;">
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
								<ui:Button btnType="excel" onClick="exportData()">导出</ui:Button>
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