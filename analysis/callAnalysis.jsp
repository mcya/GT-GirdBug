<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="year" value="<%=CommonUtil.getCurrentYear() %>"></c:set>
<c:set var="month" value="<%=CommonUtil.getCurrentMonth() %>"></c:set>
<c:set var="week" value="<%=CommonUtil.getCurrentWeek() - 1 %>"></c:set>
<c:set var="orgId" value="<%=AppHandle.getCurrentUser(request).getOrgId() %>"></c:set>
<c:set var="orgType" value="<%=AppHandle.getCurrentUser(request).getOrgType() %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>数据统计-转化率</title>
<ui:Include tags="artDialog,Select,zTree,DateTimePicker"></ui:Include>
<link rel="stylesheet" type="text/css" href="grid/gt_grid.css" />
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<!-- <script type="text/javascript" src="callAnalysis.js"></script> -->
<script type="text/javascript" src="grid/gt_msg_cn.js"></script>
<script type="text/javascript" src="grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../js/initTree.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var parameters = {'year':'${year}','month':'${month}','week':'${week}','orgId':'${orgId}','orgType':'${orgType}'};
	$(function() {
		$("#tree").height($(window).height());
		
		var height = $(window).height() - $("#head").height()+20;
		var width = $(window).width()-$('#treePanel').width() - 1;
		
		$("#grid").height(height);
		$("#grid").width(width);
		$("#grid2").height(height);
		$("#grid2").width(width);
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+20;
			$("#grid").height(height);
			$("#grid2").height(height);
			width = $(window).width()-$('#treePanel').width() - 1;
			$("#grid").width(width);
			$("#grid2").width(width);
		});
		
		initAreaHeader(width, height);
		initProjectHeader(width, height);
	});
	
	var mygrid2,mygrid;
	function initAreaHeader(width, height) {
		var dsOption= {
			fields :[
				{name: 'groupName'  },
				{name: 'saleName'  },
				{name: 'taskCt'  },
				{name: 'finishCt'  },
				{name: 'visitRate'  },
				{name: 'visitDealCt'  },
				{name: 'visitDealRate'  },
				{name: 'visitACt'  },
				{name: 'visitARate'  },
				{name: 'visitBCt'  },
				{name: 'visitBRate'  },
				{name: 'visitCCt'  },
				{name: 'visitCRate'  }
				/* {name: 'GROUPNAME'  },
				{name: 'SALENAME'  },
				{name: 'TASKCT'  },
				{name: 'FINISHCT'  },
				{name: 'VISITRATE'  },
				{name: 'VISITDEALCT'  },
				{name: 'VISITDEALRATE'  },
				{name: 'VISITACT'  },
				{name: 'VISITARATE'  },
				{name: 'VISITBCT'  },
				{name: 'VISITBRATE'  },
				{name: 'VISITCCT'  },
				{name: 'VISITCRATE'  } */

			]
		}

		var colsOption = [
			/* {id: 'groupName' , header: "所在地区" , width :150, grouped : true  },
			{id: 'saleName' , header: "项目名称" , width :150,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'taskCt' , header: "来访客户任务量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'finishCt' , header: "来访完成总数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitRate' , header: "来访客户完成率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}  },
			{id: 'visitDealCt' , header: "来访成交数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitDealRate' , header: "来访成交率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'visitACt' , header: "来访A客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitARate' , header: "来访A客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'visitBCt' , header: "来访B客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitBRate' , header: "来访B客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'visitCCt' , header: "来访C客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitCRate' , header: "来访C客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}} */
					  {id: 'GROUPNAME' , header: "所在地区" , width :150, grouped : true  },
			{id: 'SALENAME' , header: "项目名称" , width :150,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'TASKCT' , header: "来访客户任务量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'FINISHCT' , header: "来访完成总数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITRATE' , header: "来访客户完成率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}  },
			{id: 'VISITDEALCT' , header: "来访成交数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITDEALRATE' , header: "来访成交率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'VISITACT' , header: "来访A客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITARATE' , header: "来访A客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'VISITBCT' , header: "来访B客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITBRATE' , header: "来访B客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'VISITCCT' , header: "来访C客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITCRATE' , header: "来访C客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}}
		];
		var gridOption2={
			id : "myGrid2",
			loadURL : path+'/servlet/visit.analysis?method=getOrgData',
			width: width,  
			height: height,
			parameters : {
				'orgId':'${orgId}',
				'orgType':'${orgType}',
				'first':true,
				'year':'${year}',
				'month':'${month}',
				'week':'${week}',
				 autoLoad : false,
			},
			
			container : 'grid2', 
			replaceContainer : true, 
			customHead : 'myHead2',
			dataset : dsOption ,
			columns : colsOption,
			toolbarContent : 'nav | goto',
			pageSize : 600,
			loadFailure:function(  respD,  respD,  e) {
			}
		};

		var mygrid2=new Sigma.Grid(gridOption2);
		Sigma.Util.onLoad( Sigma.Grid.render(mygrid2) );
	}

	function initProjectHeader(width, height) {
		var dsOption= {
			fields :[
						{name: 'groupName'  },
						{name: 'saleName'  },
						{name: 'taskCt'  },
						{name: 'finishCt'  },
						{name: 'visitRate'  },
						{name: 'visitDealCt'  },
						{name: 'visitDealRate'  },
						{name: 'visitACt'  },
						{name: 'visitARate'  },
						{name: 'visitBCt'  },
						{name: 'visitBRate'  },
						{name: 'visitCCt'  },
						{name: 'visitCRate'  }
			]
		}

		var colsOption = [
/* 			{id: 'groupName' , header: "所在地区" , width :150, grouped : true  },
			{id: 'saleName' , header: "项目名称" , width :150,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'taskCt' , header: "来访客户任务量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'finishCt' , header: "来访完成总数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitRate' , header: "来访客户完成率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}  },
			{id: 'visitDealCt' , header: "来访成交数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitDealRate' , header: "来访成交率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'visitACt' , header: "来访A客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitARate' , header: "来访A客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'visitBCt' , header: "来访B客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitBRate' , header: "来访B客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'visitCCt' , header: "来访C客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'visitCRate' , header: "来访C客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}} */
			{id: 'GROUPNAME' , header: "所在地区" , width :150, grouped : true  },
			{id: 'SALENAME' , header: "项目名称" , width :150,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'TASKCT' , header: "来访客户任务量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'FINISHCT' , header: "来访完成总数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITRATE' , header: "来访客户完成率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}  },
			{id: 'VISITDEALCT' , header: "来访成交数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITDEALRATE' , header: "来访成交率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'VISITACT' , header: "来访A客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITARATE' , header: "来访A客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'VISITBCT' , header: "来访B客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITBRATE' , header: "来访B客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}},
			{id: 'VISITCCT' , header: "来访C客数量" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			} },
			{id: 'VISITCRATE' , header: "来访C客转化率" , width :100,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
	     		if(record.saleName==' 小组总计 ')
					return "<font color='red'>"+value+"</font>";
				else
					return value;
			}}
		];
		var gridOption2={
			id : "myGrid",
			loadURL : path+'/servlet/visit.analysis?method=getOrgData',
			width: width,  //"100%", // 700,
			height: height,  //"100%", // 330,
			parameters : {
				'orgId':'${orgId}',
				'orgType':'${orgType}',
				'first':true,
				'year':'${year}',
				'month':'${month}',
				'week':'${week}',
				 autoLoad : false,
			},
			
			container : 'grid', 
			replaceContainer : true, 
			customHead : 'myHead',
			dataset : dsOption ,
			columns : colsOption,
			toolbarContent : 'nav | goto',
			pageSize : 600,
			loadFailure:function(  respD,  respD,  e) {
			}
		};

		var mygrid=new Sigma.Grid( gridOption2 );
		Sigma.Util.onLoad( Sigma.Grid.render(mygrid) );

	}

	/**
	 * 导出操作
	 */
	 function exportData(){
		var nodes = zTree.getSelectedNodes();
		var params = {};
	 	params.orgId = nodes[0].id;
		params.orgType = nodes[0].type;
		params.year = $('#YEAR').val();
		params.month = $('#MONTH').val();
		params.week = $('#WEEK').val();
		var paramStr = '';
		for(var i in params)
			paramStr = paramStr + "&" + i + '=' + params[i];
		location.href = path + "/servlet/rate_report.action?fileName=RateReport"+paramStr;
	}
	/* gridId,parameters */
	function query() {
		var nodes = zTree.getSelectedNodes();
		var params = {};
		params.orgId = nodes[0].id;
		params.orgType = nodes[0].type;
		params.year = $('#YEAR').val();
		params.month = $('#MONTH').val();
		params.week = $('#WEEK').val();
		reloadGrid('myGrid2',params);
		reloadGrid('myGrid',params);
		toggleShowGrid(nodes[0].type)
	}
	function reloadGrid(gridId,parameters){
		var grid = Sigma.$grid(gridId);
		if(parameters){
			resetParameter(grid,parameters);
		}
		grid.reload(true,true);
	}
	function resetParameter(grid,parameters){
		grid.cleanParameters();
		for(var key in parameters){
			grid.addParameters(key,parameters[key]);
		}
	}
	function toggleShowGrid(type){
		try {
			if(type=='CORP' || type=='AREA'){
				Sigma.$('box').style.display="none";
				Sigma.$('box2').style.display='';
				mygrid2.onShow();
			}else if(type=='PROJECT'){
				Sigma.$('box2').style.display="none";
				Sigma.$('box').style.display='';
				mygrid.onShow();
			}
		}catch(e){
			//console.log(e);
		}
	}
	function doReset(){
		document.getElementById("queryForm").reset();
		query();
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
							<td style="padding-left:10px;">周次:</td>
							<td  width="150px">
							<ui:Select serviceId="" id="WEEK" caption="isnull:false;cname:周次">
								<option value="-1" <c:if test="${0==week}">selected="selected"</c:if>>全周</option>
								<option value="0" <c:if test="${0==week}">selected="selected"</c:if>>第一周</option>
								<option value="1" <c:if test="${1==week}">selected="selected"</c:if>>第二周</option>
								<option value="2" <c:if test="${2==week}">selected="selected"</c:if>>第三周</option>
								<option value="3" <c:if test="${3==week}">selected="selected"</c:if>>第四周</option>
								<option value="4" <c:if test="${4==week}">selected="selected"</c:if>>第五周</option>
								<option value="5" <c:if test="${5==week}">selected="selected"</c:if>>第六周</option>
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
			
			<table  id="myHead" style="display:none">
				<tr>
					<td>销售团队</td><td>销售人员</td><td>来访客户任务量</td><td>来访完成总数量</td><td>来访客户完成率</td><td>来访成交数量</td><td>来访成交率</td><td>来访A客数量</td><td>来访A客转化率</td><td>来访B客数量</td><td>来访B客转化率</td><td>来访C客数量</td><td>来访C客转化率</td>
				</tr>
			</table>
			<table  id="myHead2" style="display:none">
				<tr>
					<td>销售团队</td><td>销售人员</td><td>来访客户任务量</td><td>来访完成总数量</td><td>来访客户完成率</td><td>来访成交数量</td><td>来访成交率</td><td>来访A客数量</td><td>来访A客转化率</td><td>来访B客数量</td><td>来访B客转化率</td><td>来访C客数量</td><td>来访C客转化率</td>
				</tr>
			</table>
			
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