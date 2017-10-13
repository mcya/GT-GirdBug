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
<c:set var="orgId" value="<%=AppHandle.getCurrentUser(request).getOrgId() %>"></c:set>
<c:set var="orgType" value="<%=AppHandle.getCurrentUser(request).getOrgType() %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>数据统计-转化率</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree,DateTimePicker"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="callAnalysis.js"></script>
<script type="text/javascript" src="../js/initTree.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var parameters = {'YEAR':'${year}','MONTH':'${month}','WEEK':'${week}'-1,'orgId':'${orgId}','orgType':'${orgType}'};
	$(function() {
		$("#tree").height($(window).height());
		
		var height = $(window).height() - $("#head").height()+20;
		var width = $(window).width()-$('#treePanel').width() - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', path + '/com.pytech.timesgp.web.query.AnalysisRateQuery',
				columns, parameters,{
					autoLoad : true
				});
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+20;
			$("#grid").height(height);
			width = $(window).width()-$('#treePanel').width()-1;
			$("#grid").width(width);
		});
		
		$("#grid2").height(height);
		$("#grid2").width(width);
		loadGrid('grid2', path + '/com.pytech.timesgp.web.query.AnalysisRateQuery',
				columns2, parameters,{
					autoLoad : true
				});
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+20;
			$("#grid2").height(height);
			width = $(window).width()-$('#treePanel').width()-1;
			$("#grid2").width(width);
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
			<div id="head"  style="padding-left:10px;padding-bottom:4px;padding-top:3px">
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
							<td style="padding-left:10px;">月份:</td>
							<td  width="150px">
								<ui:Select serviceId="" id="MONTH" caption="isnull:false;cname:月份">
									<option value="01" <c:if test="${1==month}">selected="selected"</c:if>>1月</option>
									<option value="02" <c:if test="${2==month}">selected="selected"</c:if>>2月</option>
									<option value="03" <c:if test="${3==month}">selected="selected"</c:if>>3月</option>
									<option value="04" <c:if test="${4==month}">selected="selected"</c:if>>4月</option>
									<option value="05" <c:if test="${5==month}">selected="selected"</c:if>>5月</option>
									<option value="06" <c:if test="${6==month}">selected="selected"</c:if>>6月</option>
									<option value="07" <c:if test="${7==month}">selected="selected"</c:if>>7月</option>
									<option value="08" <c:if test="${8==month}">selected="selected"</c:if>>8月</option>
									<option value="09" <c:if test="${9==month}">selected="selected"</c:if>>9月</option>
									<option value="10" <c:if test="${10==month}">selected="selected"</c:if>>10月</option>
									<option value="11" <c:if test="${11==month}">selected="selected"</c:if>>11月</option>
									<option value="12" <c:if test="${12==month}">selected="selected"</c:if>>12月</option>	
								</ui:Select>
							</td>
							<td style="padding-left:10px;">周数:</td>
							<td  width="150px">
							<ui:Select serviceId="" id="WEEK" caption="isnull:false;cname:周数">
								<option value="0">第一周</option>
								<option value="1">第二周</option>
								<option value="2">第三周</option>
								<option value="3">第四周</option>
								<option value="4">第五周</option>
								<option value="5">第六周</option>
							</ui:Select>
							</td>
							<td style="padding-left:10px;">
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
								<ui:Button btnType="excel" onClick="export()">导出</ui:Button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div id="box">
				<div id="grid"></div>
			</div>
			<div id="box2">
				<div id="grid2"></div>
			</div>
		</div>
	</div>
</body>
</html>