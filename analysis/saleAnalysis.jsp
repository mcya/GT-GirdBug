<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="year" value="<%=CommonUtil.getCurrentYear() %>"></c:set>
<c:set var="orgId" value="<%=AppHandle.getCurrentUser(request).getOrgId() %>"></c:set>
<c:set var="orgType" value="<%=AppHandle.getCurrentUser(request).getOrgType() %>"></c:set>
<c:set var="month" value="<%=CommonUtil.getCurrentMonth() %>"></c:set>
<c:set var="currMonthStart" value="<%=CommonUtil.getCurrMonthFirstDate() %>"></c:set>
<c:set var="currMonthEnd" value="<%=CommonUtil.getCurrMonthLastDate() %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>销售报表</title>
<ui:Include tags="artDialog,Select,zTree,DateTimePicker"></ui:Include>

<link rel="stylesheet" type="text/css" href="grid/gt_grid.css" />
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;}
table.gt-table tbody tr td{
    text-align:center;//水平居中
    line-height: 25px;//行高  
    vertical-align:middle;//垂直居中
    border:1px solid red;
    height:35px;
}
.dk_container {
    background-color: #FFFFFF;
    font-family: ' Microsoft YaHei " !important; font-size: 0.9em;
    border-radius: 3px;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    height: 25px;
    width: 99%;
    text-align: left;
}
</style>
<script type="text/javascript" src="grid/gt_msg_cn.js"></script>
<script type="text/javascript" src="grid/gt_grid_all.js"></script>
<script type="text/javascript" src="../js/initTree.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var rootId = '${user.orgCode}';

	var parameters = {'YEAR':'${year}','MONTH':'${month}'};
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
		initProjectHeader(width, height)
		
	});

	var mygrid2,mygrid;
	function initAreaHeader(width, height) {
		var dsOption= {
				uniqueField : 'saleId' ,
				fields :[
					{name: 'groupName'  },
					{name: 'saler'  },
					{name: 'dealIntro'  },//成交-业主介绍
					{name: 'dealExpand'  },//成交-其他拓展
					{name: 'dealSelf'  },//成交-自来客
					{name: 'dealTotal'  },//成交-小计
					{name: 'dealRate'  },
					{name: 'visitIntroF'  },
					{name: 'visitIntroR'  },
					{name: 'visitExpandF'  },
					{name: 'visitExpandR'  },
					{name: 'visitSelfF'  },
					{name: 'visitSelfR'  },
					{name: 'visitTotal'  },
					{name: 'visitTarget'  },
					{name: 'visitTargetRate'  },
					{name: 'visitFollowA'  },
					{name: 'visitFollowB'  },
					{name: 'visitFollowC'  },
					{name: 'visitFollowT'  },
					{name: 'expandIntroF'  },
					{name: 'expandCallF'  },
					{name: 'expandOutSourceF'  },
					{name: 'expandSheetF'  },
					{name: 'expandAbductionF'  },
					{name: 'expandBigCliF'  },
					{name: 'expandTotal'  },
					{name: 'expandTarget'  },
					{name: 'expandTargetRate'  },
					{name: 'incomingCt'  }//来电数
				]
			}

			var colsOption = [
		     	{id: 'groupName' , header: "所在地区" , width :150, grouped : true  },
		     	{id: 'saler' , header: "项目名称" , width :150 },
			   	{id: 'dealIntro' , header: "业主介绍" , width :80 },//成交-业主介绍
			   	{id: 'dealExpand' , header: "其他拓展" , width :80},//成交-其他拓展
			   	{id: 'dealSelf' , header: "自来客" , width :80  },//成交-自来客
			   	{id: 'dealTotal' , header: "小计" , width :80},//成交-小计
		   		{id: 'dealRate' , header: "转化率" , width :80},
			  	{id: 'visitIntroF' , header: "首访" , width :80},
		   		{id: 'visitIntroR' , header: "复访" , width :80},
		   		{id: 'visitExpandF' , header: "首访" , width :80},
		   		{id: 'visitExpandR' , header: "复访" , width :80},
		   		{id: 'visitSelfF' , header: "首访" , width :80},
		   		{id: 'visitSelfR' , header: "复访" , width :80},
		   		{id: 'visitTotal' , header: "小计" , width :80},
		   		{id: 'visitTarget' , header: "来访目标" , width :80},
		   		{id: 'visitTargetRate' , header: "目标完成率" , width :80},
		   		{id: 'visitFollowA' , header: "A客" , width :80},
		   		{id: 'visitFollowB' , header: "B客" , width :80},
		   		{id: 'visitFollowC' , header: "C客" , width :80},
		   		{id: 'visitFollowT' , header: "小计" , width :80},
		   		{id: 'expandIntroF' , header: "获得客户量" , width :80},
		   		{id: 'expandCallF' , header: "获得客户量" , width :80},
		   		{id: 'expandOutSourceF' , header: "获得客户量" , width :80},
		   		{id: 'expandSheetF' , header: "获得客户量" , width :80},
		   		{id: 'expandAbductionF' , header: "获得客户量" , width :80},
		   		{id: 'expandBigCliF' , header: "获得客户量" , width :80},
		   		{id: 'expandTotal' , header: "小计" , width :80},
		   		{id: 'expandTarget' , header: "拓展目标" , width :80},
		   		{id: 'expandTargetRate' , header: "目标完成率" , width :80},
		   		{id: 'incomingCt' , header: "来电数" , width :80 }//来电数
			];

			var gridOption2={
				id : "myGrid2",
				loadURL : path+'/servlet/sale.analysis?method=getOrgData',
				width: width,  //"100%", // 700,
				height: height,  //"100%", // 330,
				parameters : {
					'orgId':'${orgId}',
					'orgType':'${orgType}',
					'first':true,
					 autoLoad : false,
					 addStart:'${currMonthStart}',
					 addEnd:'${currMonthEnd}'
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

			var mygrid2=new Sigma.Grid( gridOption2 );
			Sigma.Util.onLoad( Sigma.Grid.render(mygrid2) );
	}
	
	function initProjectHeader(width, height) {
		var dsOption= {
				uniqueField : 'saleId' ,
				fields :[
					{name: 'groupName'  },
					{name: 'saler'  },
					{name: 'dealIntro'  },//成交-业主介绍
					{name: 'dealExpand'  },//成交-其他拓展
					{name: 'dealSelf'  },//成交-自来客
					{name: 'dealTotal'  },//成交-小计
					{name: 'dealRate'  },
					{name: 'visitIntroF'  },
					{name: 'visitIntroR'  },
					{name: 'visitExpandF'  },
					{name: 'visitExpandR'  },
					{name: 'visitSelfF'  },
					{name: 'visitSelfR'  },
					{name: 'visitTotal'  },
					{name: 'visitTarget'  },
					{name: 'visitTargetRate'  },
					{name: 'visitFollowA'  },
					{name: 'visitFollowB'  },
					{name: 'visitFollowC'  },
					{name: 'visitFollowT'  },
					{name: 'expandIntroF'  },
					{name: 'expandCallF'  },
					{name: 'expandOutSourceF'  },
					{name: 'expandSheetF'  },
					{name: 'expandAbductionF'  },
					{name: 'expandBigCliF'  },
					{name: 'expandTotal'  },
					{name: 'expandTarget'  },
					{name: 'expandTargetRate' },
					{name: 'incomingCt'  }//来电数
				]
			}

			var colsOption = [
		     	{id: 'groupName' , header: "销售团队" , width :150, grouped : true},
		     	{id: 'saler' , header: "销售人员" , width :150 ,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
			   	{id: 'dealIntro' , header: "业主介绍" , width :80 ,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},//成交-业主介绍
			   	{id: 'dealExpand' , header: "拓展" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},//成交-其他拓展
			   	{id: 'dealSelf' , header: "自来客" , width :80  ,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},//成交-自来客
			   	{id: 'dealTotal' , header: "小计" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},//成交-小计
		   		{id: 'dealRate' , header: "转化率" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
			  	{id: 'visitIntroF' , header: "首访" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitIntroR' , header: "复访" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
				{id: 'visitExpandF' , header: "首访" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitExpandR' , header: "复访" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitSelfF' , header: "首访" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitSelfR' , header: "复访" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitTotal' , header: "小计" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitTarget' , header: "来访目标" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitTargetRate' , header: "目标完成率" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitFollowA' , header: "A客" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitFollowB' , header: "B客" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitFollowC' , header: "C客" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'visitFollowT' , header: "小计" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandIntroF' , header: "获得客户量" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandCallF' , header: "获得客户量" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandOutSourceF' , header: "获得客户量" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandSheetF' , header: "获得客户量" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandAbductionF' , header: "获得客户量" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandBigCliF' , header: "获得客户量" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},	
				{id: 'expandTotal' , header: "小计" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandTarget' , header: "拓展目标" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
		   		{id: 'expandTargetRate' , header: "目标完成率" , width :80,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				}},
				{id: 'incomingCt' , header: "来电数" , width :80, renderer : function(value ,record,columnObj,grid,colNo,rowNo){
		     		if(record.saler==' 小组总计 ')
						return "<font color='red'>"+value+"</font>";
					else
						return value;
				} }//来电数
			];

			var gridOption2={
				id : "myGrid",
				loadURL : path+'/servlet/sale.analysis?method=getOrgData',
				width: width,  //"100%", // 700,
				height: height,  //"100%", // 330,
				parameters : {
					'orgId':'${orgId}',
					'orgType':'${orgType}',
					'first':true,
					 autoLoad : false,
					 addStart:'${currMonthStart}',
					 addEnd:'${currMonthEnd}'
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
		params.addStart = $('#ADD_TIME_FROM').val();
		params.addEnd = $('#ADD_TIME_TO').val();
		var paramStr = '';
		for(var i in params) {
			paramStr = paramStr + '&' + i + '=' + params[i];
		}
		location.href = path + "/servlet/sale_report.action?fileName=SaleReport"+paramStr;
	}
	
	/* gridId,parameters */
	function query() {
		var nodes = zTree.getSelectedNodes();
		var params = {};
		params.orgId = nodes[0].id;
		params.orgType = nodes[0].type;
		params.addStart = $('#ADD_TIME_FROM').val();
		params.addEnd = $('#ADD_TIME_TO').val();
		
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
							<td style="text-align:right;">新增时间：</td>
							<td>
								<ui:DateTimePicker format="YYYY-MM-DD" id="ADD_TIME_FROM" style="width:150px" defaultDate="${currMonthStart }"></ui:DateTimePicker> 至
								<ui:DateTimePicker format="YYYY-MM-DD" id="ADD_TIME_TO" style="width:150px" defaultDate="${currMonthEnd }"></ui:DateTimePicker>
							</td>
							<td>
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
							</td>
							<td>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
							</td>
							<td>
								<ui:Button  btnType="excel" onClick="exportData()">导出</ui:Button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			
			<!-- <table  id="myHead" style="display:none">
				<tr>
					<td rowspan="3">销售团队</td> <td rowspan="3">销售人员</td> <td colspan="4">成交</td> <td rowspan="3">转化率</td> <td colspan="13">来访客户</td> <td colspan="15">客户拓展</td>
				</tr>
				<tr>
					<td rowspan="2">拓展-业主介绍</td> <td rowspan="2">自来客</td> <td rowspan="2">拓展-其他</td> <td rowspan="2">小计</td>
					<td colspan="2">拓展-业主介绍</td> <td colspan="2">自来客</td> <td colspan="2">拓展-其他</td> <td rowspan="2">小计</td> <td rowspan="2">来访目标</td> <td rowspan="2">目标完成率</td>  
					<td colspan="4">可跟进客户</td> <td colspan="1">业主拓展</td> <td colspan="1">Call客拓展</td>
					<td colspan="1">外部资源</td> <td colspan="1">派单</td> <td colspan="1">外展</td> <td colspan="1">大客户</td>
					<td rowspan="2">小计</td> <td rowspan="2">拓展目标</td><td rowspan="2">目标完成率</td>
				</tr>
				
				<tr>
					<td>首访</td> <td>复访</td> <td>首访</td>
					<td>复访</td> <td>首访</td> <td>复访</td>
					<td>A客</td> <td>B客</td><td>C客</td> <td>小计</td>
					<td>获得客户量</td>
					<td>获得客户量</td><td>获得客户量</td> 
					<td>获得客户量</td>
					<td>获得客户量</td> <td>获得客户量</td> 
				</tr>
			</table>
			<table  id="myHead2" style="display:none">
				<tr>
					<td rowspan="3">所在地区</td> <td rowspan="3">项目名称</td> <td colspan="4">成交</td> <td rowspan="3">转化率</td> <td colspan="13">来访客户</td> <td colspan="15">客户拓展</td>
				</tr>
				<tr>
					<td rowspan="2">拓展-业主介绍</td> <td rowspan="2">自来客</td> <td rowspan="2">拓展-其他</td> <td rowspan="2">小计</td>
					<td colspan="2">拓展-业主介绍</td> <td colspan="2">自来客</td> <td colspan="2">拓展-其他</td> <td rowspan="2">小计</td> <td rowspan="2">来访目标</td> <td rowspan="2">目标完成率</td>  
					<td colspan="4">可跟进客户</td> <td colspan="1">业主拓展</td> <td colspan="1">Call客拓展</td>
					<td colspan="1">外部资源</td> <td colspan="1">派单</td> <td colspan="1">外展</td> <td colspan="1">大客户</td>
					<td rowspan="2">小计</td> <td rowspan="2">拓展目标</td><td rowspan="2">目标完成率</td>
				</tr>
				
				<tr>
					<td>首访</td> <td>复访</td> <td>首访</td>
					<td>复访</td> <td>首访</td> <td>复访</td>
					<td>A客</td> <td>B客</td><td>C客</td> <td>小计</td>
					<td>获得客户量</td>
					<td>获得客户量</td><td>获得客户量</td> 
					<td>获得客户量</td>
					<td>获得客户量</td> <td>获得客户量</td> 
				</tr>
			</table> -->
			
			<table  id="myHead" style="display:none">
				<tr>
					<td rowspan="4">销售团队</td> <td rowspan="4">销售人员</td> <td colspan="4">成交</td> <td rowspan="4">转化率</td> <td colspan="13">来访客户</td> <td colspan="9">客户拓展</td><td rowspan="4">来电数</td>
				</tr>
				<tr>
					<td colspan="2" rowspan="2">拓展</td> <td rowspan="3">自来客</td> <td rowspan="3">小计</td>
					<td colspan="4">拓展</td> <td rowspan="2" colspan="2">自来客</td> <td rowspan="3">小计</td> 
					<td rowspan="3">来访目标</td> <td rowspan="3">目标完成率</td>  
					<td colspan="4" rowspan="2">可跟进客户</td> <td colspan="1" rowspan="2">业主拓展</td> <td colspan="1" rowspan="2">Call客拓展</td>
					<td colspan="1" rowspan="2">外部资源</td> <td colspan="1" rowspan="2">派单</td> <td colspan="1" rowspan="2">外展</td> <td colspan="1" rowspan="2">大客户</td>
					<td rowspan="3">小计</td> <td rowspan="3">拓展目标</td><td rowspan="3">目标完成率</td>
				</tr>
				
				<tr>
					<td colspan="2">业主介绍</td> <td colspan="2">其他拓展</td> 
				</tr>

				<tr>
					<td>业主介绍</td><td>其他拓展</td>
					<td>首访</td> <td>复访</td> <td>首访</td>
					<td>复访</td> <td>首访</td> <td>复访</td>
					<td>A客</td> <td>B客</td><td>C客</td> <td>小计</td>
					<td>获得客户量</td>
					<td>获得客户量</td><td>获得客户量</td> 
					<td>获得客户量</td>
					<td>获得客户量</td> <td>获得客户量</td> 
				</tr>
			</table>
			
			<table  id="myHead2" style="display:none">
				<tr>
					<td rowspan="4">所在地区</td> <td rowspan="4">项目名称</td> <td colspan="4">成交</td> <td rowspan="4">转化率</td> <td colspan="13">来访客户</td> <td colspan="9">客户拓展</td><td rowspan="4">来电数</td>
				</tr>
				<tr>
					<td colspan="2" rowspan="2">拓展</td> <td rowspan="3">自来客</td> <td rowspan="3">小计</td>
					<td colspan="4">拓展</td> <td rowspan="2" colspan="2">自来客</td> <td rowspan="3">小计</td> 
					<td rowspan="3">来访目标</td> <td rowspan="3">目标完成率</td>  
					<td colspan="4" rowspan="2">可跟进客户</td> <td colspan="1" rowspan="2">业主拓展</td> <td colspan="1" rowspan="2">Call客拓展</td>
					<td colspan="1" rowspan="2">外部资源</td> <td colspan="1" rowspan="2">派单</td> <td colspan="1" rowspan="2">外展</td> <td colspan="1" rowspan="2">大客户</td>
					<td rowspan="3">小计</td> <td rowspan="3">拓展目标</td><td rowspan="3">目标完成率</td>
				</tr>
				
				<tr>
					<td colspan="2">业主介绍</td> <td colspan="2">其他拓展</td> 
				</tr>

				<tr>
					<td>业主介绍</td><td>其他拓展</td>
					<td>首访</td> <td>复访</td> <td>首访</td>
					<td>复访</td> <td>首访</td> <td>复访</td>
					<td>A客</td> <td>B客</td><td>C客</td> <td>小计</td>
					<td>获得客户量</td>
					<td>获得客户量</td><td>获得客户量</td> 
					<td>获得客户量</td>
					<td>获得客户量</td> <td>获得客户量</td> 
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