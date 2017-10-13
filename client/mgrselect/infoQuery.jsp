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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>客户列表</title>
<ui:Include tags="artDialog,sigmagrid,Select,DateTimePicker,zTree"></ui:Include>
<link href="${path }/pages/css/custom.css" rel="stylesheet">
<style type="text/css">
#baseContainer {
	position: relative;
}

#treePanel {
	white-space: nowrap;
	font-size: 12px;
	margin: 0;
	width: 160px;
	height: 100%;
	padding: 0px 0px;
	float: left;
	border: 1px solid #c6dcf1;
	position: relative;
	overflow: auto;
}

#searchContanter {
	position: absolute;
	top: 26px;
	z-index: 10;
	left: 2px;
	background-color: #eee
}

.head_fen {
	line-height: 20px;
	font-weight: 400;
	border-top: 1px dotted #e1e7f5;
}

.head_fen h4 {
	width: 120px;
	float: left;
}

.head_fen ul {
	list-style-type: none;
}

.queryview {
	background: none !important;
	/* line-height: 12px; */
	font-weight: 400;
	border-top: 1px dotted #e1e7f5;
	padding-left: 10px;
	padding-top: 2px;
	padding-bottom: 1px;
}

.normal {
	margin-right: 5px;
	text-decoration: none !important;
}

.queryview span.normal:HOVER {
	color: #F7421C;
}

.queryview span {
	cursor: default;
}

.queryview span.normal {
	cursor: pointer;
}

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

.queryview .selected {
	color: white;
	font-weight: bold;
	background-color: #3399FF;
	padding: 0px 2px;
	border-radius: 3px;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
}
</style>
<script type="text/javascript" src="js/infoquery.js"></script>
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
		params['ORG_ID'] = orgId;
		reloadGrid('grid', params);
	}

	function reloadPage(flg) {
		window.location.href = "${path}/pages/client/mgrselect/infoQuery.jsp?expand="
				+ flg;
	}

	$(function() {
		$("#tree").height($(window).height());
		var height = $(window).height() - $("#head").height();
		var width = $(window).width();
		initData();//默认录入时间为当前日期
		var inputTime=$("#INPUT_TIME").val();
		parameters={INPUT_TIME:inputTime}
		var expand = '${param.expand}';//-1收起，空或者1展开
		if (!expand)//展开
			height = $(window).height() - $("#head").height();
		if (expand == 1)//展开
			height = $(window).height() - $("#head").height();
		if (expand == -1) {//收起
			height = $(window).height();
			$('#head').css('display', 'none');
			$('#expandBtn').css('display', 'block');
		}
		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', path + '/com.pytech.timesgp.web.query.ClientQuery',
				columns, parameters, {
					autoLoad : true,
					singleSelect : false
				});

		initTree();		
		$(window).resize(function() {
			height = $(window).height() - $("#head").height();
			$("#grid").height(height);
			width = $(window).width();
			$("#grid").width(width);
		});
	});
	var initData= function(){
		var nowDate = new Date();
        var setMonth = nowDate.getMonth() + 1;
        if (setMonth < 10) setMonth = '0' + setMonth;
        var setDay=nowDate.getDate();
        if(setDay<10) setDay="0"+setDay;
		$("#INPUT_TIME").val(nowDate.getFullYear() + '-' + setMonth+'-'+setDay);
	}
	
	/* 加载销售人员
	*/
	function selectPerson(target){
		var groupId = target.val();
		$("#SALE_NAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
		ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
			var data = reply.getResult();
			$("#SALE_NAME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#SALE_NAME").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
			}
		});
	}
	/* 加载销售组
	*/
	function selectGroup(target){
		var orgId = target.val();
		$("#SALE_GROUP").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getGroupByProjectId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#SALE_GROUP").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#SALE_GROUP").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
			}
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
				$("#PROJECT").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}
	/**
	* 批量调整客户所属销售
	*/
	function batchAdjust() {
		dialogUtil.open("batchAdjustPg","批量调整客户所属销售人员",path+"/pages/client/mgrselect/batchAdjust.jsp",200,450);
	}
	/**
	* 批量调整客户所属销售
	*/
	function batchToPublic() {
		var records = getSelectedRecords('grid');
		if(records.length == 0){
			dialogUtil.alert('请至少选择一条记录导出！',true);
			return false;
		}
		var ids = new Array();
		for(var i = 0;i<records.length;i++)
			ids.push(records[i].CUST_ID);
		
		dialogUtil.confirm('确认将选择的'+records.length+'个客户置为公客吗？',function(){
			ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.CustomerDao:batchToPublic",[ids.join(",")],function(reply){
				var result = reply.getResult();
				dialogUtil.alert(result.msg,true);
				if(result.success){
					reloadGrid('grid');
				}
			});
		},function(){});
		
	}
	
	/**
	* 批量导入新客户
	*/
	function batchImport() {
		dialogUtil.open("batchImportPg","批量导入新客户",path+"/pages/client/mgrselect/batchImport.jsp",200,500);
	}
</script>

</head>
<body style="padding: 0; margin: 0px;">

	<div id="baseContainer" style="overflow: hidden;">
		<div id="treePanel" style="overflow: hidden; display: none">
			<div id="mgrbtn" style="padding-left: 3px;"></div>
			<div id="searchContanter"
				style="height: 30px; width: 100%; margin-top: 0px; padding-top: 2px; margin-left: 0px; display: none">
				<span><input id="search_str" name="search_str" type="text"
					class="textbox" style="width: 150px" /></span> <input type="button"
					value="搜索" onclick="doSearch();" class="sbtn" />
			</div>
			<div id="tree" class="ztree"
				style="padding: 5px 0px 0px 0px; margin: 0px; width: 200px; overflow: auto; background-color: #fff; border-top: 0px solid #c6dcf1;"></div>
		</div>

		<div id="content" style="float: left;">
			<div id="head">
				<form action="" id="queryForm">
					<input type="hidden" id="CUTO_TYPE" name="CUTO_TYPE"> <input
						type="hidden" id="CUTO_FROM" name="CUTO_FROM"> <input
						type="hidden" id="CUTO_INTE" name="CUTO_INTE"> <input
						type="hidden" id="CUTO_COM" name="CUTO_COM"> <input
						type="hidden" id="CUTO_TAG" name="CUTO_TAG"> <input
						type="hidden" id="CUTO_INDUST" name="CUTO_INDUST"> <input
						type="hidden" id="CUTO_WAY" name="CUTO_WAY"> <input
						type="hidden" id="CUTO_SALESTATUS" name="CUTO_SALESTATUS"><input
						type="hidden" id="CUTO_VISIT" name="CUTO_VISIT">
						
					<input type="hidden" id="CUTO_PAYWAY" name="CUTO_PAYWAY">
					<div class="queryview">
						<span> <span style="font-weight: bold; margin-right: 6px;">公客标记:</span>
							<span id="TAG" class="normal selected" for="CUTO_TAG"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_TAG" onclick="changeScope(this, '1')">公客</span> <span
							class="normal" for="CUTO_TAG" onclick="changeScope(this, '0')">非公客</span>
						</span> <span> <span
							style="font-weight: bold; margin-right: 6px; margin-left: 13px;">成交意向:</span>
							<span id="INTE" class="normal selected" for="CUTO_INTE"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_INTE" onclick="changeScope(this, 'A')">A级</span> <span
							class="normal" for="CUTO_INTE" onclick="changeScope(this, 'B')">B级</span>
							<span class="normal" for="CUTO_INTE"
							onclick="changeScope(this, 'C')">C级</span>
						</span> <span> <span
							style="font-weight: bold; margin-right: 6px; margin-left: 8px;">销售状态:</span>
							<span id="TYPE" class="normal selected" for="CUTO_TYPE"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_TYPE" onclick="changeScope(this, '1')">未来访</span> <span
							class="normal" for="CUTO_TYPE" onclick="changeScope(this, '2')">已来访</span>
							<span class="normal" for="CUTO_TYPE"
							onclick="changeScope(this, '3')">已成交</span>
						</span>
						<span> <span
							style="font-weight: bold; margin-right: 6px; margin-left: 10px;">来访标识:</span>
							<span id="VISIT" class="normal selected" for="CUTO_VISIT"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_VISIT" onclick="changeScope(this, '0')">未来访</span> <span
							class="normal" for="CUTO_VISIT" onclick="changeScope(this, '1')">已来访</span>
						</span>
					</div>
					<div class="queryview">
						<span> <span style="font-weight: bold; margin-right: 6px;">付款方式:</span>
							<span id="PAYWAY" class="normal selected" for="CUTO_PAYWAY"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_PAYWAY" onclick="changeScope(this, '一次性付款')">一次性付款</span>
							<span class="normal" for="CUTO_PAYWAY"
							onclick="changeScope(this, '分期付款')">分期付款</span> <span
							class="normal" for="CUTO_PAYWAY"
							onclick="changeScope(this, '商业银行按揭')">商业银行按揭</span> <span
							class="normal" for="CUTO_PAYWAY"
							onclick="changeScope(this, '公积金按揭')">公积金按揭</span>
						</span> <span> <span
							style="font-weight: bold; margin-right: 6px; margin-left: 50px;">沟通阶段:</span>
							<span id="COM" class="normal selected" for="CUTO_COM"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_COM" onclick="changeScope(this, '了解项目')">了解项目</span> <span
							class="normal" for="CUTO_COM" onclick="changeScope(this, '看板房')">看板房</span>
							<span class="normal" for="CUTO_COM"
							onclick="changeScope(this, '议价')">议价</span> <span class="normal"
							for="CUTO_COM" onclick="changeScope(this, '下筹')">下筹</span> <span
							class="normal" for="CUTO_COM" onclick="changeScope(this, '成交')">成交</span>
						</span>
					</div>
					<div class="queryview">
						<span style="font-weight: bold; margin-right: 6px;">工作行业:</span> <span
							id="INDUST" class="normal selected" for="CUTO_INDUST"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_INDUST" onclick="changeScope(this, '制造业')">制造业</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '金融业')">金融业</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '政府机关')">政府机关</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '教育业')">教育业</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '事业单位')">事业单位</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '医疗企业')">医疗企业</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '房地产')">房地产</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '快销行业')">快销行业</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '电子商务')">电子商务</span> <span
							class="normal" for="CUTO_INDUST"
							onclick="changeScope(this, '其他')">其他</span>
					</div>
					<div class="queryview">
						<span style="font-weight: bold; margin-right: 6px;">认知途径:</span> <span
							id="WAY" class="normal selected" for="CUTO_WAY"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_WAY" onclick="changeScope(this, '电视')">电视</span> <span
							class="normal" for="CUTO_WAY" onclick="changeScope(this, '电台')">电台</span>
						<span class="normal" for="CUTO_WAY"
							onclick="changeScope(this, '网络')">网络</span> 
						<span class="normal" for="CUTO_WAY"
							onclick="changeScope(this, '报纸')">报纸</span>
						<span class="normal" for="CUTO_WAY"
							onclick="changeScope(this, '活动')">活动</span>
						<span class="normal"
							for="CUTO_WAY" onclick="changeScope(this, '户外')">户外</span> <span
							class="normal" for="CUTO_WAY" onclick="changeScope(this, '公交站')">公交站</span>
						<span class="normal" for="CUTO_WAY"
							onclick="changeScope(this, '电话')">电话</span> 
						<span class="normal"
							for="CUTO_WAY" onclick="changeScope(this, '短信')">短信</span> 
						<span
							class="normal" for="CUTO_WAY" onclick="changeScope(this, '朋友介绍')">朋友介绍</span>
						<span
							class="normal" for="CUTO_WAY" onclick="changeScope(this, '中介')">中介</span>
						<span class="normal" for="CUTO_WAY"
							onclick="changeScope(this, '传单')">传单</span> <span class="normal"
							for="CUTO_WAY" onclick="changeScope(this, '途径')">途径</span> <span
							class="normal" for="CUTO_WAY" onclick="changeScope(this, '外展')">外展</span>
						<span class="normal" for="CUTO_WAY"
							onclick="changeScope(this, '新媒体')">新媒体</span>
					</div>
					<div class="queryview">
						<span style="font-weight: bold; margin-right: 6px;">客户来源:</span> <span
							id="FROM" class="normal selected" for="CUTO_FROM"
							onclick="changeScope(this, '')">不限</span> <span class="normal"
							for="CUTO_FROM" onclick="changeScope(this, '自来客')">自来客</span> <!-- <span
							class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '业主介绍')">业主介绍</span> --> <span
							class="normal" for="CUTO_FROM" onclick="changeScope(this, '来电')">来电</span>
						<span class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '拓展-派单')">拓展-派单</span> <span
							class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '拓展-外展')">拓展-外展</span> <span
							class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '拓展-大客户')">拓展-大客户</span> <span
							class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '拓展-外部资源')">拓展-外部资源</span> <span
							class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '拓展-业主介绍')">拓展-业主介绍</span> <span
							class="normal" for="CUTO_FROM"
							onclick="changeScope(this, '拓展-call客')">拓展-call客</span>
					</div>
					<table style="padding: 0; margin: 0; padding-left: 10px;">
						<tr>
							<td>意向单价(元):</td>
							<td width="110px"><ui:Select id="INTENT_PRICE_START"
									serviceId="com.pytech.timesgp.web.query.IntentSPriceSelect"></ui:Select></td>
							<td>至</td>
							<td width="110px"><ui:Select id="INTENT_PRICE_END"
									serviceId="com.pytech.timesgp.web.query.IntentSPriceSelect"></ui:Select></td>
							<td style="padding-left: 10px;">意向总价(万元):</td>
							<td width="110px"><ui:Select id="INTENT_TOTAL_START"
									serviceId="com.pytech.timesgp.web.query.IntentTPriceSelect"></ui:Select></td>
							<td>至</td>
							<td width="110px"><ui:Select id="INTENT_TOTAL_END"
									serviceId="com.pytech.timesgp.web.query.IntentTPriceSelect"></ui:Select></td>
							<td style="padding-left: 10px;">意向面积(平米):</td>
							<td width="110px"><ui:Select id="INTENT_SIZE_START"
									serviceId="com.pytech.timesgp.web.query.IntentSizeSelect"></ui:Select></td>
							<td>至</td>
							<td width="110px"><ui:Select id="INTENT_SIZE_END"
									serviceId="com.pytech.timesgp.web.query.IntentSizeSelect"></ui:Select></td>
						</tr>
					</table>
					<table style="padding: 0; margin: 0; padding-left: 10px;">
						<tr>
							<td>录入时间始:</td>
							<td width="150px"><ui:DateTimePicker format="YYYY-MM-DD"
									id="INPUT_TIME" style="width:150px"></ui:DateTimePicker></td>
							<td>录入时间止:</td>
							<td width="150px"><ui:DateTimePicker format="YYYY-MM-DD"
									id="INPUT_TIME_END" style="width:150px"></ui:DateTimePicker></td>
							<td style="padding-left: 8px;">来访时间始:</td>
							<td width="150px"><ui:DateTimePicker format="YYYY-MM-DD"
									id="VISIT_TIME" style="width:150px"></ui:DateTimePicker></td>
							<td>来访时间止:</td>
							<td width="150px"><ui:DateTimePicker format="YYYY-MM-DD"
									id="VISIT_TIME_END" style="width:150px"></ui:DateTimePicker></td>
						</tr>
					</table>
					<table style="padding: 0; margin: 0; padding-left: 10px;">
						<tr>
							<td>成交时间始:</td>
							<td width="150px"><ui:DateTimePicker format="YYYY-MM-DD"
									id="DEAL_TIME" style="width:150px"></ui:DateTimePicker></td>
							<td>成交时间止:</td>
							<td width="150px"><ui:DateTimePicker format="YYYY-MM-DD"
									id="DEAL_TIME_END" style="width:150px"></ui:DateTimePicker></td>
							<td style="padding-left: 21px;">工作区域:</td>
							<td width="150px"><ui:TextBox id="WORK_AREA" style="width:150px"></ui:TextBox></td>
							<td style="padding-left: 13px;">居住区域:</td>
							<td width="150px"><ui:TextBox id="LIVE_AREA" style="width:150px"></ui:TextBox></td>
						</tr>
					</table>
					<table style="padding: 0; margin: 0; padding-left: 10px;">
						<tr>
							<td>地区分公司:</td>
							<td width="152px">
								<%-- <ui:Select
									serviceId="com.pytech.timesgp.web.query.AreaSelect"
									parameter="{'orgType':'${orgType}'}" id="AREA"
									caption="isnull:false;cname:地区">
								</ui:Select> --%>
								<select id="AREA" name="AREA" class="textbox" onchange="selectProject($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.ORG_ID}">${list.ORG_NAME}</option>
									</c:forEach>
								</select>
							</td>
							<td style="padding-left: 13px;">项目名称:</td>
							<td width="152px">
								<%-- <ui:Select
									serviceId="com.pytech.timesgp.web.query.ProjectSelect"
									parameter="{'orgType':'${orgType}'}" id="PROJECT"
									caption="isnull:false;cname:项目">
								</ui:Select> --%>
								<select id="PROJECT" name="PROJECT" class="textbox" onchange="selectGroup($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left: 21px;">销售小组:</td>
							<td width="152px">
								<%-- <ui:Select id="SALE_GROUP"
									serviceId="com.pytech.timesgp.web.query.SaleGroupSelect"
									parameter="{'orgType':'${orgType}'}" style="width:150px"></ui:Select> --%>
								<select id="SALE_GROUP" name="SALE_GROUP" class="textbox" onchange="selectPerson($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td style="padding-left: 13px;">销售人员:</td>
							<td width="152px">
								<%-- <ui:TextBox id="SALE_NAME"
									style="width:150px"></ui:TextBox> --%>
								<select id="SALE_NAME" name="SALE_NAME" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
						</tr>
					</table>
					<table style="padding: 0; margin: 0; padding-left: 10px;">
						<tr>
							<td style="padding-left: 13px;">客户姓名:</td>
							<td width="150px"><ui:TextBox id="CUST_NAME" style="width:150px"></ui:TextBox></td>
							<td style="padding-left: 13px;">客户电话:</td>
							<td width="150px"><ui:TextBox id="CUST_PHONE" style="width:150px"></ui:TextBox></td>
						</tr>
					</table>
					<table
						style="padding: 0; margin: 0; width: 100%; padding-left: 10px;">
						<tr>
							<td style="width: 90%">
								<ui:Button btnType="query" onClick="javascript:query();">查询</ui:Button> 
								<ui:Button btnType="reset" onClick="javascript:doReset();">重置</ui:Button>																
								<ui:Button btnType="import" onClick="javascript:batchToPublic();">批量转入公客池</ui:Button>
								<ui:Button btnType="import" onClick="javascript:batchImport();">批量客户导入</ui:Button>
								<ui:Button btnType="import" onClick="javascript:batchAdjust();">批量调整销售员</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportSelectedList();" btnText="导出">导出已选中客户</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportSimpleList();" id="btn_excel" btnText="导出">导出客户列表</ui:Button>
								<ui:Button btnType="excel" onClick="javascript:exportDetailList();">导出客户全信息</ui:Button>
							</td>
							<td style="width: 10%">
								<a onclick="javascript:reloadPage(-1);" href="#"><font color="blue" style="cursor: pointer;">全部收起</font></a>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="queryview" id="expandBtn" style="display: none">
				<table width="100%">
					<tr>
						<td style="width: 90%"><font color="gray">高级查询</font></td>
						<td style="width: 10%"><a onclick="javascript:reloadPage(1);"
							href="#"><font color="blue" style="cursor: pointer;">全部展开</font></a></td>
					</tr>
				</table>
			</div>
			<div class="box">
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>