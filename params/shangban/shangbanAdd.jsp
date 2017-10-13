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
<title>上班地址</title>
<ui:Include tags="sigmagrid,artDialog,Select,zTree,DateTimePicker"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<style type="text/css">
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 
</style>
<script type="text/javascript" src="js/shangban.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript" src="../../js/laydate/laydate.js"></script>
<script type="text/javascript">
var path = '${path}';
var rootId = '${user.orgCode}';
var orgType = '${orgType}';
var isUpdatee = getUrlParam('isUpdate')
var parameters = {'YEAR':'${year}','MONTH':'${month}','WEEK':'${week}'-1,'ORG_TYPE':orgType};
	$(function() {
		$("ORG_TYPE").val(orgType);
		if (isUpdatee==1) {
			chushihua()
		}
		var columns = [
		{
			id: 'R_R',
			header: 'id',
			width: 50,
			align : 'center',
			isCheckColumn: true
		}, {
			id : "ORG_NAME",
			header : "公司",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "PROJNAME",
			header : "项目",
			width :200,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "GROUP_NAME",
			header: "小组",
			width:200,
			align : 'center',
			type :'string',
			toolTip:true,
		}, {
			id : "USERNAME",
			header : "人员",
			width :150,
			align : 'center',
			type :'string',
			toolTip:true
		},{
			id : "ADDR",
			header : "上班地点",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "IS_ATTEND",
			header : "打卡时间",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}, {
			id : "ATTENDPERIOD",
			header : "活动范围",
			width :100,
			align : 'center',
			type :'string',
			toolTip:true
		}];
		
		$("#tree").height($(window).height());
		
		var height = $(window).height() - $("#head").height()+22;
		var width = $(window).width() - 1;

		$("#grid").height(height);
		$("#grid").width(width);
		loadGrid('grid', 
			path + '/com.pytech.timesgp.web.query.WorkplaceQuery',
			columns,
			parameters,
			{
				singleSelect: true,
				autoLoad : true,
		});
		initTree();
		$(window).resize(function() {
			height = $(window).height() - $("#head").height()+22;
			$("#grid").height(height);
			width = $(window).width() -1;
			$("#grid").width(width);
		});

		$("#ADDR").html(function(idx, val){
			$(this).html("<a href=javascript:; id=ADDR>"+xianshiName+"</a>")
		})

		laydate.render({
		  elem: '#test5',
		  type: 'time'
		});

		$("#ADDR").on('click', function(e){
			e.stopPropagation();
			e.preventDefault();
			console.log('111')
			if (isUpdatee==0) {
				dialogUtil.open(
					"addChannel",
					"选择地图",
					path+"/pages/params/shangban/gaodeMap.jsp?isAddFlag=1",550,860,
					function(e, value, recoer){
						var lnlaAddr = JSON.parse(localStorage.getItem("lnlaAddr"))
						saveName = e.saveName;
						saveInfo = e.saveInfo;
						saveData = e.saveData;
						xianshiName = lnlaAddr[2]
						console.log('eeeeeeeeeeee', e, value, recoer, e.saveInfo, e.saveName, saveName, saveInfo)
						$("#ADDR").html(function(idx, val){
							$(this).html("<a href=javascript:; id=ADDR>"+xianshiName+"</a>")
						})
					}
				);
			} else if (isUpdatee==1) {
				// 修改
				// 需要传经纬度
				dialogUtil.open(
					"addChannel",
					"选择地图",
					path+"/pages/params/shangban/gaodeMap.jsp?isAddFlag=0",550,860,
					function(e, value, recoer){
						var lnlaAddr = JSON.parse(localStorage.getItem("lnlaAddr"))
						saveName = e.saveName;
						saveInfo = e.saveInfo;
						saveData = e.saveData;
						xianshiName = lnlaAddr[2]
						console.log('eeeeeeeeeeee', e, value, recoer, e.saveInfo, e.saveName, saveName, saveInfo)
						$("#ADDR").html(function(idx, val){
							$(this).html("<a href=javascript:; id=ADDR>"+xianshiName+"</a>")
						})
					}
				);
			}
		})
	});

	// 修改前的查询初始化
	function chushihua() {
		selectProjectInt();
		selectGroupInt();
		selectPersonInt();
		chushihuaFunction();
	}

	function chushihuaFunction() {
		var initData = JSON.parse(localStorage.getItem("records"))
		var lnlaAddr = JSON.parse(localStorage.getItem("lnlaAddr"))
		var setData = {
			ORG_NAME: initData.ORGID,
			PROJNAME: initData.PROJID,
			GROUP_NAME: initData.GROUPID,
			USERNAME: initData.USERCODE,
			CRATED: initData.ATTENDTIME,
			ADDR: lnlaAddr[2],
			ATTENDPERIOD:initData.RANGE
		}
		xianshiName = lnlaAddr[2]
		console.log('初始化得到的数据', initData, setData, lnlaAddr)
		Form.mapToForm('queryForm', setData);
	}

	function saveOrUpdate() {
		var may = Form.formToMap('queryForm');
		var updateLocalData = JSON.parse(localStorage.getItem("records"))
		var lnlaAddr = JSON.parse(localStorage.getItem("lnlaAddr"))
		var dateValue = $("#test5").val()
		if (may.ORG_NAME==''||may.ORG_NAME==null) {
			dialogUtil.alert("请选择地区公司<br />或点击[取消]返回上一页");
			return
		}
		if (may.PROJNAME==''||may.PROJNAME==null) {
			dialogUtil.alert("请选择项目名称<br />或点击[取消]返回上一页");
			return
		}
		if (may.GROUP_NAME==''||may.GROUP_NAME==null) {
			dialogUtil.alert("请选择销售小组<br />或点击[取消]返回上一页");
			return
		}
		if (may.USERNAME==''||may.USERNAME==null) {
			dialogUtil.alert("请选择销售人员<br />或点击[取消]返回上一页");
			return
		}
		if (xianshiName=='请点击此处选择上班地址') {
			dialogUtil.alert("请选择上班地址<br />或点击[取消]返回上一页");
			return
		}
		if (dateValue==''||dateValue==null) {
			dialogUtil.alert("请输入打卡时间<br />或点击[取消]返回上一页");
			return
		}
		if (may.ATTENDPERIOD==''||may.ATTENDPERIOD==null) {
			dialogUtil.alert("请输入活动范围<br />或点击[取消]返回上一页");
			return
		}
		if(isUpdatee==0) {
			var addParams = {
				ORGID: may.ORG_NAME,
				PROJID: may.PROJNAME,
				GROUPID: may.GROUP_NAME,
				USERCODE: may.USERNAME,
				ATTENDTIME: dateValue,
				ADDR: lnlaAddr[2],
				LONGITUDE: lnlaAddr[0],
				LATITUDE: lnlaAddr[1],
				RANGE:may.ATTENDPERIOD
			}
			console.log('新增保存', addParams, saveInfo, saveData, saveName, xianshiName)
			ajax.remoteCall(path+
				"/com.pytech.timesgp.web.dao.WorkplaceDao:addWorkplace",
				[addParams],function(reply){
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					goBack()
					reloadGrid('grid');
				});
			});
		} else if (isUpdatee==1) {
			// 修改
			// 修改数据，一个是经纬度的变化，现在这边需要翻译的经纬度是否会发生变化
			var LONGITUDEV =  saveData[0];
			var LATITUDEV = saveData[1];
			if (xianshiName==lnlaAddr[2]) {
				LONGITUDEV = lnlaAddr[0];
				LATITUDEV = lnlaAddr[1];
			}
			var updateParams = {
				ORGID: may.ORG_NAME,
				PROJID: may.PROJNAME,
				GROUPID: may.GROUP_NAME,
				USERCODE: may.USERNAME,
				ATTENDTIME: dateValue,
				ADDR: lnlaAddr[2],
				LONGITUDE:LONGITUDEV,
				LATITUDE: LATITUDEV,
				RANGE:may.ATTENDPERIOD
			}
			console.log('修改保存', updateParams)
			ajax.remoteCall(path+
				"/com.pytech.timesgp.web.dao.WorkplaceDao:updateWorkplace",
				[updateParams],function(reply){
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					goBack()
					reloadGrid('grid');
				});
			});
		}
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

	/* 加载销售人员
	*/
	function selectPerson(target){
		var groupId = target.val();
		$("#USERNAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
		ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
			var data = reply.getResult();
			$("#USERNAME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#USERNAME").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
			}
		});
	}
	/* 加载销售组
	*/
	function selectGroup(target){
		var orgId = target.val();
		$("#GROUP_NAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getGroupByProjectId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#GROUP_NAME").append('<option value="">--请选择--</option>');
			for(var i=0;i<data.length;i++){
				$("#GROUP_NAME").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
			}
		});
	}


	/* 加载项目
	*/
	function selectProjectInt(){
		var initData = JSON.parse(localStorage.getItem("records"))
		var orgId = initData.ORGID;
		var projNames = initData.PROJNAME;
		var PROJIDs = initData.PROJID;
		$("#PROJNAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getProjectByAreaId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#PROJNAME").append('<option value='+PROJIDs+'>'+projNames+'</option>');
			for(var i=0;i<data.length;i++){
				if('${orgType}'=='PROJNAME')
					$("#PROJNAME").append('<option value="'+data[i].ORG_ID+'" selected="selected">'+data[i].ORG_NAME+'</option>');
				else
					$("#PROJNAME").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}

	/* 加载销售人员
	*/
	function selectPersonInt(){
		var initData = JSON.parse(localStorage.getItem("records"))
		var groupId = initData.GROUPID;
		var personCode = initData.USERCODE;
		var personName = initData.USERNAME;
		$("#USERNAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.UserMgrDao:getUserByGroupId";
		ajax.remoteCall(serviceUrl,[{"groupId":groupId}],function(reply){
			var data = reply.getResult();
			$("#USERNAME").append('<option value='+personCode+'>'+personName+'</option>');
			for(var i=0;i<data.length;i++){
				$("#USERNAME").append('<option value="'+data[i].USER_CODE+'">'+data[i].USER_NAME+'</option>');
			}
		});
	}
	/* 加载销售组
	*/
	function selectGroupInt(){
		var initData = JSON.parse(localStorage.getItem("records"))
		var orgId = initData.PROJID;
		var grouids = initData.GROUPID;
		var grouNames = initData.GROUPNAME;
		$("#GROUP_NAME").html("");
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getGroupByProjectId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#GROUP_NAME").append('<option value='+grouids+'>'+grouNames+'</option>');
			for(var i=0;i<data.length;i++){
				$("#GROUP_NAME").append('<option value="'+data[i].GROUP_ID+'">'+data[i].GROUP_NAME+'</option>');
			}
		});
	}

	function goBack(){
		window.history.go(-1);
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
						<tr style="height: 20px;"></tr>
						<tr>
							<td style="padding-left:21px;"><span style="color: red">*</span>地区公司:</td>
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
							<td width="153px"></td>
							<td width="153px"></td>
							<td style="padding-left:13px;"><span style="color: red">*</span>项目名称:</td>
							<td width="153px">
								<select id="PROJNAME" name="PROJNAME" class="textbox" onchange="selectGroup($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							</tr><tr style="height: 30px;"></tr><tr>
							<td style="padding-left: 21px;"><span style="color: red">*</span>销售小组:</td>
							<td width="152px">
								<select id="GROUP_NAME" name="GROUP_NAME" class="textbox" onchange="selectPerson($(this))" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
							<td width="153px"></td>
							<td width="153px"></td>
							<td style="padding-left: 13px;"><span style="color: red">*</span>销售人员:</td>
							<td width="152px">
								<select id="USERNAME" name="USERNAME" class="textbox" style="width:100%">
									<option value="">--请选择--</option>
								</select>
							</td>
						</tr>
						<tr style="height: 30px;"></tr>
						<tr>
							<td style="padding-left: 21px;"><span style="color: red">*</span>上班地点:</td>
							<td><a href="javascript:;" id="ADDR"></a></td>
							<td width="153px"></td><td width="153px"></td>
							<td style="padding-left: 13px;">打卡时间:</td>
							<td>
								<ui:TextBox id="test5"></ui:TextBox></td>
							</td>
						</tr>
						<tr style="height: 30px;"></tr>
						<tr>
							<td style="padding-left: 21px;"><span style="color: red">*</span>活动范围:</td>
							<td><ui:TextBox id="ATTENDPERIOD"></ui:TextBox></td>
						</tr>
					</table>
				</form>
			</div>
			<div style="width: 100%;text-align: center">
				<br>
				<a class="btn" href="javascript:;" onclick="saveOrUpdate()"><img src="/eac-core/res/css/img/pixel.gif" class="save"/><span>保存</span></a>
				<a class="btn" href="javascript:;" onclick="goBack()"><img src="/eac-core/res/css/img/pixel.gif" class="cancel" style="border:0"/><span>取消</span></a>
			</div>
			<div id="box" style="display: none;">
				<div id="grid"></div>
			</div>
		</div>
	</div>
</body>
</html>