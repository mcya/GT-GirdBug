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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<title>系统参数增改</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;}
.label {
	text-align: right
}
.require {
	color: red;
	padding-right: 1px;
}
#CANADD,#JJBB,#ORG_NAME,#PROJNAMME,#DICTNAME,#PROJNAME {
	height: 25px;
	width: 250px;
    outline: none;
    box-shadow: none;
    border-radius: 3px;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border: #ccc 1px solid;
}

</style>
<script type="text/javascript" src="js/customer.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var orgType = '${orgType}';
var parameters = {'YEAR':'${year}','MONTH':'${month}','WEEK':'${week}'-1,'ORG_TYPE':orgType};

var oper = '${param.oper}';
var selector = null;
var text=document.getElementById("ORG_NAME");
var save = 2;
var before;	
$(function() {
	if ('edit' == oper) {
		$('#queryForm .jjbbStyle').hide()
		$('#JJBB').attr('disabled', true)
		getChannel();
	}
	if ('view' == oper) {
		getChannel();
		Form.formDisable('queryForm')
	}
	if (oper == 'add') {
		var panduan = localStorage.getItem('jtOxm')
		console.log('panduan', panduan)
		$('#queryForm .jjbbStyle').hide()
		$('#queryForm .prj').hide()
		if (panduan=='项目级') {
			var formData = {JJBB: '3'}
			Form.mapToForm('queryForm', formData)
			$('#JJBB').attr('disabled', true)
			return;
		}
		$('#JJBB').attr('disabled', false)
	}
});



$(function() {
	var channelCode;
	var postData = Form.formToMap('queryForm');
	var data = null;
});

// 关闭取消
function closeDialog(){
	if ('add' == oper) {
		parent.art.dialog.get("addChannel").close();
	}
	if ('edit' == oper) {
		parent.art.dialog.get("editChannel").close();
	}
}

// 修改触发的查询
function getChannel() {
	var abv = '${param.CHANNEL_ID}'.split(",")
	ajax.remoteCall(path + "/com.pytech.timesgp.web.dao.ParametersDao:getParameter", abv, function(reply) {
				var data = reply.getResult();
				console.log('datattt',data)
				xuanran(data)
			});
}
function xuanran(data){
	if (data.PROJNAME==null || data.PROJNAME=='') {
		$("#queryForm .prj").hide();
		data.JJBB = '2';
	} else {
		$('#queryForm .prj').show()
		data.JJBB = '3';
	}
	Form.mapToForm('queryForm', data);
	before = data.CHANNEL_CODE;
}
function jjbbFunction(target) {
	var selectidVal = target.val()
	if (selectidVal==3) {
		$('#queryForm .jjbbStyle').show()
		return
	}
	$('#queryForm .jjbbStyle').hide()
}
// 保存
function saveOrUpdate() {
	if (!Form.checkForm('queryForm')) {
		return;
	}
	var postData = Form.formToMap('queryForm');
	var panduan = localStorage.getItem('jtOxm')
	if (postData.JJBB=="3" && panduan=='集团级') {
		if (postData.ORG_NAME=="" || postData.ORG_NAME==null) {
			dialogUtil.alert("地区公司不能为空")
			return;
		}
		if (postData.PROJNAMME=="" || postData.PROJNAMME==null) {
			dialogUtil.alert("项目名称不能为空")
			return;
		}
	}
	var serviceUrl = null;
	var groupidss = getUrlParam('urlGroupids')
	var trLength = getUrlParam('trLength')
	if (oper == 'edit') {
		var dictid = getUrlParam('dctids')
		var belongids = getUrlParam('belongids')
		var saveParams = {
			CANADD: postData["CANADD"],
			DICTNAME: postData["DICTNAME"],
			GROUPID: groupidss,
			DICTID: dictid,
			BELONGID: belongids
		}
		serviceUrl = "${path}/com.pytech.timesgp.web.dao.ParametersDao:updateParameter";
		ajax.remoteCall(serviceUrl, [ saveParams ], function(reply) {
		var data = reply.getResult();
		dialogUtil.alert(data.msg, function() {
			if (data.success == true) {
				closeDialog();
			}
		});
	});
	} else {
		var addParams = {
			CANADD: postData["CANADD"],
			DICTNAME: postData["DICTNAME"],
			GROUPID: groupidss,
			DICTORDER: trLength,
			PDICTID: '',
			BELONGID: postData.PROJNAMME
		}
		serviceUrl = "${path}/com.pytech.timesgp.web.dao.ParametersDao:addParameter";
		ajax.remoteCall(serviceUrl, [ addParams ], function(reply) {
		var data = reply.getResult();
		dialogUtil.alert(data.msg, function() {
			if (data.success == true) {
				closeDialog();
			}
		});
	});
	}
}	
	


	/* 加载项目
	*/
	function selectProject(target){
		var orgId = target.val();
		$("#PROJNAMME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getProjectByAreaId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#PROJNAMME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				if('${orgType}'=='PROJNAMME')
					$("#PROJNAMME").append('<option value="'+data[i].ORG_ID+'" selected="selected">'+data[i].ORG_NAME+'</option>');
				else
					$("#PROJNAMME").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}

	
	/* 加载销售组
	*/
	function selectGroup(target){
		var orgId = target.val();
		console.log('value:', orgId)
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
							<td width="180px" class="label"><span class="require">*</span>参数名称:</td>
							<td width="250px">
								<ui:TextBox id="DICTNAME" caption="isnull:false;cname:参数名称"></ui:TextBox>
							</td>
						</tr>
						
						<tr style="height: 10px;"></tr>
						<tr>
							<td width="180px" class="label"><span class="require">*</span>是否允许子集:</td>
							<td width="250px">
								<select id="CANADD" name="CANADD" parameter="" serviceId="" caption="isnull:false;cname:是否允许子集">
									<option value="">--请选择--</option>
									<option value="1">是</option>
									<option value="0">否</option>
								</select>
							</td>
						</tr>
						<tr style="height: 10px;"></tr>
						<tr>
							<td width="180px" class="label"><span class="require">*</span>参数级别:</td>
							<td width="250px">
								<select id="JJBB" name="JJBB" parameter="" serviceId="" caption="isnull:false;cname:选择参数级别" onchange="jjbbFunction($(this))">
									<option value="">--请选择--</option>
									<option value="2">集团级</option>
									<option value="3">项目级</option>
								</select>
							</td>
						</tr>
						<tr style="height: 10px;" class="prj"></tr>
						<tr class="prj">
							<td width="180px" class="label"><span class="require">*</span>项目名称:</td>
							<td width="250px">
								<input disabled="false" name="PROJNAME" id="PROJNAME" />
							</td>
						</tr>
						<tr style="height: 10px;" class="jjbbStyle"></tr>
						<tr class="jjbbStyle">
							<td width="180px" class="label"><span class="require">*</span>地区公司:</td>
							<td width="250px">
								<select id="ORG_NAME" name="ORG_NAME" class="textbox" onchange="selectProject($(this))" style="width:100%">
									<option value="">--请选择--</option>
									<c:forEach var="list" items="${lists}">
										<option value="${list.ORG_ID}" <c:if test="${orgType=='PROJNAMME' }">selected="selected"</c:if>>${list.ORG_NAME}</option>
										<c:if test="${orgType=='PROJNAMME' }">
											<script type="text/javascript">
											selectProject($('select#AREA'))
											</script>
										</c:if>
									</c:forEach>
								</select>
							</td>
						</tr><tr style="height: 10px;" class="jjbbStyle"></tr><tr class="jjbbStyle">
							<td width="180px" class="label"><span class="require">*</span>项目名称:</td>
							<td width="250px">
								<select id="PROJNAMME" name="PROJNAMME" class="textbox" onchange="selectGroup($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<div style="width: 100%;text-align: center">
		<br>
		<c:if test="${'view' != param.oper}">
		<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
		</c:if>
		<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
	</div>
</body>
</html>