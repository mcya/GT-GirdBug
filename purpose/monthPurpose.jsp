<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.SelectorDao"%>
<%@page import="com.open.eac.core.structure.User"%>
<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="year" value="<%=CommonUtil.getCurrentYear() %>"></c:set>
<c:set var="month" value="<%=CommonUtil.getCurrentMonth() %>"></c:set>
<c:set var="orgType" value="<%=AppHandle.getCurrentUser(request).getOrgType() %>"></c:set>
<c:set var="userCode" value="<%=AppHandle.getCurrentUser(request).getUserCode()%>"></c:set>
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
<title>目标管理-月目标</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="monthPurpose.js"></script>
<script type="text/javascript" src="../js/initTree.js"></script>
<script type="text/javascript">
	var path = '${path}';
	var rootId = '${user.orgCode}';
	var orgType = '${orgType}';
	var parameters = {'YEAR':'${year}','ORG_TYPE':orgType};
	$(function() {
		var columns;
		if(orgType!='PROJECT')
			columns = [{
				id : "MONTH_NAME",
				header : "月份",
				width :80,
				headAlign:'left',
				align : 'center',
				grouped : true,
				sortable:false
			},{
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
			}, {
				id : "DEAL_MONEY",
				header : "成交金额<br/>目标数(万)",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:dealMoneyEdit
			}, {
				id : "DEAL_CNT",
				header : "成交套数目标<br/>(估算后手动填写)",
				align : 'center',
				width :110,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
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
				beforeEdit:expandCntEdit
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
				editor: { type:"text",validRule:['R','I']  } ,
				beforeEdit:expandCallEdit
			}, {
				id : "EXPAND_SHEET_CNT",
				header : "拓展-派单<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I']  } ,
				beforeEdit:expandSheetEdit
			}, {
				id : "EXPAND_ABDUCTION_CNT",
				header : "拓展-外展<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: {  type:"text",validRule:['R','I']  },
				beforeEdit:expandAbductionEdit
			}, {
				id : "EXPAND_OUTSOURCE_CNT",
				header : "拓展-外部资源<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:expandOutsourceEdit
			},{
				id : "EXPAND_BIGCLI_CNT",
				header : "拓展-大客户<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:expandBigcliEdit
			}, {
				id : "EXPAND_INTRO_CNT",
				header : "拓展-业主活动<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:expandIntroEdit
			}];
		else
			columns = [{
				id : "MONTH_NAME",
				header : "月份",
				width :80,
				headAlign:'left',
				align : 'center',
				grouped : true,
				sortable:false
			},{
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
			}, {
				id : "DEAL_MONEY",
				header : "成交金额<br/>目标数(万)",
				align : 'center',
				width :100,
				sortable:false,
				beforeEdit:dealMoneyEdit,
				renderer:dealMoneyRender
			}, {
				id : "DEAL_CNT",
				header : "成交套数目标<br/>(估算后手动填写)",
				align : 'center',
				width :110,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
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
				beforeEdit:visitCntEdit,
				renderer:function(val, record, columnObj, grid, colNo, rowNo){
					return '<font color="red">'+val+'</font>'}
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
				beforeEdit:expandCntEdit,
				renderer:expandRender,
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
				editor: { type:"text",validRule:['R','I']  } ,
				beforeEdit:expandCallEdit
			}, {
				id : "EXPAND_SHEET_CNT",
				header : "拓展-派单<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I']  } ,
				beforeEdit:expandSheetEdit
			}, {
				id : "EXPAND_ABDUCTION_CNT",
				header : "拓展-外展<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: {  type:"text",validRule:['R','I']  },
				beforeEdit:expandAbductionEdit
			}, {
				id : "EXPAND_OUTSOURCE_CNT",
				header : "拓展-外部资源<br/>目标数",
				width :100,
				headAlign:'left',
				align : 'center',
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:expandOutsourceEdit
			},{
				id : "EXPAND_BIGCLI_CNT",
				header : "拓展-大客户<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:expandBigcliEdit
			}, {
				id : "EXPAND_INTRO_CNT",
				header : "拓展-业主活动<br/>目标数",
				align : 'center',
				width :100,
				sortable:false,
				editor: { type:"text",validRule:['R','I'] },
				beforeEdit:expandIntroEdit
			}];
		
		$("#tree").height($(window).height());
		
		var height = $(window).height() - $("#head").height()+22;
		var width = $(window).width()  - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', 
			path + '/com.pytech.timesgp.web.query.PurposeMgrQuery',
			columns,
			parameters,
			{ autoLoad : false,
			  afterEdit:function(value,  oldValue,  record,  col,  grid) {//编辑表格后回调函数
				  	/* if(0==grid.getCellValue('EXPAND_CNT',record))
				  		alert('请先设置该行的总拓展数！'); */
			  		//TODO:判断当设置了总拓展数并且其他五类的拓展数全为0时，平均分配该拓展数到该五类拓展
				  	/* if(value==oldValue)
				  		return; */
					var year = $('#YEAR').val();
				  	var month = record.MONTH_INDEX + '';
				  	if(month.length==1)
				  		month='0'+month;
				  	var projId = record.PROJECT_ID;
					var fieldId = col.id;
					var fieldVal = value; 
				  	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.PurposeDao:updateMonthPurpose",[year,month,projId,fieldId,fieldVal],function(reply){
				  		reloadGrid('grid');
						var data = reply.getResult();
						dialogUtil.alert(data.message,function(){
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
			width = $(window).width()  - 1;
			$("#grid").width(width);
		});
	});
	function expandCntEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function expandCallEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	//到访次数（统计范围）：0次,1-3次,4-6次,6次以上
	function expandEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function expandAbductionEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function expandOutsourceEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function expandBigcliEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function expandIntroEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function expandSheetEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function visitCntEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function dealMoneyEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	function dealCntEdit(value,  record,  col,  grid) {
		if(record.MONTH_INDEX<'${month}')
			return false;
		return true;
	}
	
	/**
	 * 导出操作
	 */
	function exportProgram(){
		exportExcel("grid","活动排期列表");
	}
	/*导入操作  */
	function importCustomer(){
		dialogUtil.open("customerImport","月目标导入","${path}/pages/purpose/monthImport.jsp",250,500);
	}
	/*同步项目完成数据*/
	function syncFinishDb() {
		var projId = $('#PROJECT').val();
		if(!projId){
			dialogUtil.alert('请选择要同步完成数据的项目！',function(){ });
			return;
		}
		var ym = $('#YEAR').val() + "-" + $('#MONTH').val();
		Form.showWaiting();
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.SyncFinishCtDao:syncCurrMonthFinishDbToPurposeTable",[projId, ym],function(reply){
			var data = reply.getResult();
				Form.hideWaiting();
			dialogUtil.alert(data.msg,function(){
			});
		}); 
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
							<td width="150px">
								<ui:Select serviceId="" id="YEAR" caption="isnull:false;cname:年份">
									<option value="2016" <c:if test="${2016==year}">selected="selected"</c:if>>2016年</option>
									<option value="2017" <c:if test="${2017==year}">selected="selected"</c:if>>2017年</option>
									<option value="2018" <c:if test="${2018==year}">selected="selected"</c:if>>2018年</option>
									<option value="2019" <c:if test="${2019==year}">selected="selected"</c:if>>2019年</option>
									<option value="2020" <c:if test="${2020==year}">selected="selected"</c:if>>2020年</option>
								</ui:Select>
							</td>
							<td style="padding-left:5px;">月份:</td>
							<td width="150px">
								<ui:Select serviceId="" id="MONTH" caption="isnull:false;cname:年份">
									<option value="01" <c:if test="${01==month}">selected="selected"</c:if>>1月</option>
									<option value="02" <c:if test="${02==month}">selected="selected"</c:if>>2月</option>
									<option value="03" <c:if test="${03==month}">selected="selected"</c:if>>3月</option>
									<option value="04" <c:if test="${04==month}">selected="selected"</c:if>>4月</option>
									<option value="05" <c:if test="${05==month}">selected="selected"</c:if>>5月</option>
									<option value="06" <c:if test="${06==month}">selected="selected"</c:if>>6月</option>
									<option value="07" <c:if test="${07==month}">selected="selected"</c:if>>7月</option>
									<option value="08" <c:if test="${08==month}">selected="selected"</c:if>>8月</option>
									<option value="09" <c:if test="${09==month}">selected="selected"</c:if>>9月</option>
									<option value="10" <c:if test="${10==month}">selected="selected"</c:if>>10月</option>
									<option value="11" <c:if test="${11==month}">selected="selected"</c:if>>11月</option>
									<option value="12" <c:if test="${12==month}">selected="selected"</c:if>>12月</option>	
								</ui:Select>
							</td>
							<td style="padding-left:5px;">地区:</td>
							<td width="153px">
								<%-- <ui:Select serviceId="com.pytech.timesgp.web.query.AreaSelect" parameter="{'orgType':'${orgType}'}" id="AREA" caption="isnull:false;cname:地区">
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
						</tr>
						<tr>
							<td style="padding-left:5px;padding-top:2px" colspan="8">
							    <ui:Button btnType="query" onClick="query()">查询</ui:Button>
								<ui:Button btnType="reset" onClick="doReset()">重置</ui:Button>
								<c:if test="${orgType!='PROJECT'}">
									<ui:Button btnType="import" onClick="importCustomer()">导入</ui:Button>
								</c:if>
								<c:if test="${orgType!='PROJECT'}">
									<ui:Button btnType="excel" onClick="javascript:exportMonthList();" id="btn_excel" btnText="导出">导出</ui:Button>
								</c:if>
								<%-- <c:if test="${userCode=='admin'}"> --%>
									<ui:Button btnType="excel" onClick="syncFinishDb()">同步项目完成数</ui:Button>
								<%-- </c:if> --%>
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