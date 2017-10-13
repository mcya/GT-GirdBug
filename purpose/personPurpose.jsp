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
<title>目标管理-个人目标</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="personPurpose.js"></script>
<script type="text/javascript" src="../js/initTree.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var orgType = '${orgType}';
var parameters = {'YEAR':'${year}','MONTH':'${month}','WEEK':'${week}'-1,'ORG_TYPE':orgType};
	$(function() {
		$("ORG_TYPE").val(orgType);
		var columns;
		if(orgType=='PROJECT')
			columns = [{
				id : "AREA_NAME",
				header : "地区",
				width :130,
				headAlign:'left',
				align : 'center',grouped : true,
				sortable:false
			},{
				id : "PROJECT_NAME",
				header : "项目",
				width :80,
				headAlign:'left',
				align : 'center',grouped : true,
				sortable:false
			},{
				id : "GROUP_NAME",
				header : "组别",
				width :150,
				headAlign:'left',
				align : 'center',
				grouped : true,
				sortable:false
			},{
				id : "USER_TYPE",
				header : "职位",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,grouped : true,
				renderer:posRender
			},  {
				id : "USER_NAME",
				header : "姓名",
				width :150,
				headAlign:'left',
				align : 'center',
				sortable:false,grouped : true,
				renderer:nameRender
			},{
				id : "WEEK_DESC",
				header : "周次描述",
				width :80,
				headAlign:'left',
				align : 'center',
				grouped : true,
				sortable:false,
				renderer:colorRender
			},{
				id : "START_DT",
				header : "开始时间",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false
			},  {
				id : "END_DT",
				header : "结束时间",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false
			}/* , {
				id : "DEAL_MONEY",
				header : "成交金额(万)",
				align : 'center',
				width :100,
				sortable:false,
				renderer:dealMoneyRender,
				beforeEdit:dealMoneyEdit
			} */, {
				id : "DEAL_CNT",
				header : "成交套数目标<br/>(估算后手动填写)",
				align : 'center',
				width :110,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				renderer:dealCntRender,
				beforeEdit:dealCntEdit
			}, {
				id : "DEAL_FINISH_CNT",
				header : "实际<br/>成交套数",
				align : 'center',
				width :100,
				sortable:false,
				renderer:readonlyRender
			}, {
				id : "VISIT_CNT",
				header : "来访<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				renderer:visitCntRender,
				beforeEdit:visitCntEdit
			}, {
				id : "VISIT_FINISH_CNT",
				header : "实际<br/>完成量",
				align : 'center',
				width :100,
				sortable:false,
				renderer:visitFinishCntRender
			}, {
				id : "EXPAND_CNT",
				header : "总拓展<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				renderer:expandRender,
				beforeEdit:expandEdit
			}, {
				id : "EXPAND_FINISH_CNT",
				header : "实际总拓展<br/>完成量",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandFinishRender
			}, {
				id : "EXPAND_CALL_CNT",
				header : "拓展-Call客<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I']  },
				renderer:expandCallRender,
				beforeEdit:expandCallEdit
			}, {
				id : "EXPAND_SHEET_CNT",
				header : "拓展-派单<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I']  },
				renderer:expandSheetRender,
				beforeEdit:expandSheetEdit
			}, {
				id : "EXPAND_ABDUCTION_CNT",
				header : "拓展-外展<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: {  type:"text",validRule:['R','I']  },
				renderer:expandAbductionRender,
				beforeEdit:expandAbductionEdit
			}, {
				id : "EXPAND_OUTSOURCE_CNT",
				header : "拓展-外部资源<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				renderer:expandOutsourceRender,
				beforeEdit:expandOutsourceEdit
			},{
				id : "EXPAND_BIGCLI_CNT",
				header : "拓展-大客户<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				renderer:expandBigcliRender,
				beforeEdit:expandBigcliEdit
			}, {
				id : "EXPAND_INTRO_CNT",
				header : "拓展-业主活动<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				renderer:expandIntroRender,
				beforeEdit:expandIntroEdit
			}];
		else 
			columns = [{
				id : "AREA_NAME",
				header : "地区",
				width :130,
				headAlign:'left',
				align : 'center',grouped : true,
				sortable:false
			},{
				id : "PROJECT_NAME",
				header : "项目",
				width :80,
				headAlign:'left',
				align : 'center',grouped : true,
				sortable:false
			},{
				id : "GROUP_NAME",
				header : "组别",
				width :150,
				headAlign:'left',
				align : 'center',
				grouped : true,
				sortable:false
			},{
				id : "USER_TYPE",
				header : "职位",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,grouped : true,
				renderer:posRender
			},  {
				id : "USER_NAME",
				header : "姓名",
				width :150,
				headAlign:'left',
				align : 'center',
				sortable:false,grouped : true,
				renderer:nameRender
			},{
				id : "WEEK_DESC",
				header : "周次描述",
				width :80,
				headAlign:'left',
				align : 'center',
				grouped : true,
				sortable:false,
				renderer:colorRender
			},{
				id : "START_DT",
				header : "开始时间",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false
			},  {
				id : "END_DT",
				header : "结束时间",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false
			}/* , {
				id : "DEAL_MONEY",
				header : "成交金额(万)",
				align : 'center',
				width :100,
				sortable:false,
				renderer:dealMoneyRender,
				beforeEdit:dealMoneyEdit
			} */, {
				id : "DEAL_CNT",
				header : "成交套数目标<br/>(估算后手动填写)",
				align : 'center',
				width :110,
				sortable:false,
				renderer:dealCntRender,
				beforeEdit:dealCntEdit
			}, {
				id : "DEAL_FINISH_CNT",
				header : "实际<br/>成交套数",
				align : 'center',
				width :100,
				sortable:false,
				renderer:readonlyRender
			}, {
				id : "VISIT_CNT",
				header : "来访<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				renderer:visitCntRender,
				beforeEdit:visitCntEdit
			}, {
				id : "VISIT_FINISH_CNT",
				header : "实际<br/>来访量",
				align : 'center',
				width :100,
				sortable:false,
				renderer:visitFinishCntRender
			}, {
				id : "EXPAND_CNT",
				header : "总拓展<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandRender,
				beforeEdit:expandEdit
			}, {
				id : "EXPAND_FINISH_CNT",
				header : "实际总拓展<br/>完成量",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandFinishRender
			}, {
				id : "EXPAND_CALL_CNT",
				header : "拓展-Call客<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandCallRender,
				beforeEdit:expandCallEdit
			}, {
				id : "EXPAND_SHEET_CNT",
				header : "拓展-派单<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandSheetRender,
				beforeEdit:expandSheetEdit
			}, {
				id : "EXPAND_ABDUCTION_CNT",
				header : "拓展-外展<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandAbductionRender,
				beforeEdit:expandAbductionEdit
			}, {
				id : "EXPAND_OUTSOURCE_CNT",
				header : "拓展-外部资源<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				renderer:expandOutsourceRender,
				beforeEdit:expandOutsourceEdit
			},{
				id : "EXPAND_BIGCLI_CNT",
				header : "拓展-大客户<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				renderer:expandBigcliRender,
				beforeEdit:expandBigcliEdit
			}, {
				id : "EXPAND_INTRO_CNT",
				header : "拓展-业主活动<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				renderer:expandIntroRender,
				beforeEdit:expandIntroEdit
			}];

		
		$("#tree").height($(window).height());
		var height = $(window).height() - $("#head").height()+22;
		var width = $(window).width()  - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', 
			path + '/com.pytech.timesgp.web.query.PurposeMgrPersonQuery',
			columns,
			parameters,
			{	pageSize:500,
				autoLoad : true,
			  afterEdit:function(value,  oldValue,  record,  col,  grid) {//编辑表格后回调函数
				  	/* if(value==oldValue)
				  		return; */
				  	/* if(value<oldValue)
				  		alert('请设置不小于原目标值！'); */
				  	var year = $('#YEAR').val();
				  	var month = $('#MONTH').val();
				  	if(month.length==1)
				  		month='0'+month;
				  	var week = $('#WEEK').val();
				  	var projId = record.PROJECT_ID;
				  	var personId = record.USER_CODE;
					var fieldId = col.id;
					var fieldVal = value; 
				  	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.PurposeDao:updatePersonPurpose",[year,month,week,personId,fieldId,fieldVal],function(reply){
				  		reloadGrid('grid');
						var data = reply.getResult();
						dialogUtil.alert(data.msg,function(){
							reloadGrid('grid');
						});
					}); 
		  	},
			  toolbarContent:false
		});
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+22;
			$("#grid").height(height);
			width = $(window).width() - 1;
			$("#grid").width(width);
		});
	});
	

	//到访次数（统计范围）：0次,1-3次,4-6次,6次以上
	function expandEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function expandCallEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function expandAbductionEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function expandOutsourceEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function expandBigcliEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function expandIntroEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function expandSheetEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function visitCntEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function dealMoneyEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	function dealCntEdit(value,  record,  col,  grid) {
		if(record.WEEK<'${week}')
			return false;
		if(record.GROUP_NAME=='周总计' || record.GROUP_NAME=='周目标')
			return false;
		return true;
	}
	
	function getMonthWeek(a, b, c) { 
		/* 
		a = d = 当前日期 
		b = 6 - w = 当前周的还有几天过完(不算今天) 
		a + b 的和在除以7 就是当天是当前月份的第几周 
		*/
		var date = new Date(a, parseInt(b) - 1, c), w = date.getDay(), d = date.getDate(); 
		return Math.ceil((d + 6 - w) / 7); 
	};
	
	/**
	 * 导出操作
	 */
	function exportProgram(){
		exportExcel("grid","活动排期列表");
	}
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
				if('${orgType}'=='PROJECT')
					$("#PROJECT").append('<option value="'+data[i].ORG_ID+'" selected="selected">'+data[i].ORG_NAME+'</option>');
				else
					$("#PROJECT").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
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
					      	<td style="padding-left:5px;">年份:</td>
							<td  width="150px">
								<ui:Select serviceId="" id="YEAR" caption="isnull:false;cname:年份">
									<option value="2016" <c:if test="${2016==year}">selected="selected"</c:if>>2016年</option>
									<option value="2017" <c:if test="${2017==year}">selected="selected"</c:if>>2017年</option>
									<option value="2018" <c:if test="${2018==year}">selected="selected"</c:if>>2018年</option>
									<option value="2019" <c:if test="${2019==year}">selected="selected"</c:if>>2019年</option>
									<option value="2020" <c:if test="${2020==year}">selected="selected"</c:if>>2020年</option>
								</ui:Select>
							</td>
							<td style="padding-left:5px;">月份:</td>
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
							<td style="padding-left:5px;">周次:</td>
							<td  width="150px">
							<ui:Select serviceId="" id="WEEK" caption="isnull:false;cname:周数">
								<option value="-1" <c:if test="${1==week}">selected="selected"</c:if>>全周</option>
								<option value="0" <c:if test="${1==week}">selected="selected"</c:if>>第一周</option>
								<option value="1" <c:if test="${2==week}">selected="selected"</c:if>>第二周</option>
								<option value="2" <c:if test="${3==week}">selected="selected"</c:if>>第三周</option>
								<option value="3" <c:if test="${4==week}">selected="selected"</c:if>>第四周</option>
								<option value="4" <c:if test="${5==week}">selected="selected"</c:if>>第五周</option>
								<option value="5" <c:if test="${6==week}">selected="selected"</c:if>>第六周</option>
							</ui:Select>
							</td>
							<td>&nbsp;</td>
							<td width="150px">&nbsp;</td>
						</tr>
						<tr>
							<td style="padding-left:5px;">地区:</td>
							<td width="153px">
								<%-- <ui:Select serviceId="com.pytech.timesgp.web.query.AreaSelect" id="AREA" parameter="{'orgType':'${orgType}'}" caption="isnull:false;cname:地区">
								</ui:Select> --%>
								<select id="AREA" name="AREA" class="textbox" onchange="selectProject($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.ORG_ID}" <c:if test="${orgType=='PROJECT' }">selected="selected"</c:if>>${list.ORG_NAME}</option>
										<c:if test="${orgType=='PROJECT' }">
											<script type="text/javascript">
											selectProject($('select#AREA'))
											</script>
										</c:if>
									</c:forEach>
								</select>
							</td>
							<td style="padding-left:5px;">项目:</td>
							<td width="153px">
								<%-- <ui:Select serviceId="com.pytech.timesgp.web.query.ProjectSelect" parameter="{'orgType':'${orgType}'}" id="PROJECT" caption="isnull:false;cname:项目">
								</ui:Select> --%>
								<select id="PROJECT" name="PROJECT" class="textbox" style="width:100%">
									<c:if test="${orgType!='PROJECT' }">
										<option value="">--请选择--</option>
									</c:if>
								</select>
							</td>
							<td style="padding-left:10px;padding-top:2px" colspan="4">
							   	<ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
								<%-- <ui:Button btnType="tree" onClick="reAllocate()">更新个人目标</ui:Button> --%>
								<ui:Button btnType="excel"
									onClick="javascript:exportPersonList();" id="btn_excel"
									btnText="导出">导出</ui:Button>
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