<%@page import="com.pytech.timesgp.web.helper.Constants"%>
<%@page import="com.pytech.timesgp.web.util.CommonUtil"%>
<%@page import="java.io.File"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.open.eac.core.util.IdGenerator" %>
<%@page import="com.open.eac.core.config.ServerConfig"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag" %>
<%@page import="com.pytech.timesgp.web.dao.SelectorDao"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<%

   	SelectorDao selector = new SelectorDao();
	selector.setRequest(request);
	//根据销售经理的OrgId查询销售人员
	List<Map<String,Object>> list = selector.getAreadDatas();
	pageContext.setAttribute("lists", list);

   String tmpPath = ServerConfig.getEacHome();
   String savePath = CommonUtil.getCachePath();
   savePath = savePath.replaceAll("\\\\", "/")+"/news";

   File file = new File(savePath);
   if(!file.exists()){
	   file.mkdirs();
   }
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+request.getContextPath();
   System.out.println("basePath="+basePath);
   String baseImgPath = basePath+"/Msg/img.action?path=";
   pageContext.setAttribute("savePath", savePath);
   pageContext.setAttribute("baseImgPath", baseImgPath);
   
	/*java获取的办法，<c:forEach>遍历*/
	String newsId = request.getParameter("NEWS_ID");
	
	String newUUID = IdGenerator.getUuid();
	pageContext.setAttribute("newUUID", newUUID);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
.label{text-align: right;font-weight:bold;}
.require{color: red;padding-right: 1px;}
</style>
<title>发布</title>

<link rel="stylesheet" href="/eac-core/res/kindeditor/themes/default/default.css" />


<script type="text/javascript" src="/eac-core/res/kindeditor/themes/simple/simple.js"></script>

<link media="screen" href="css/lightbox.css" rel="stylesheet">
<ui:Include tags="artDialog,Select,FileUpload,zTree,sigmagrid"></ui:Include>
<link href="${path }/pages/css/custom4purpose.css" rel="stylesheet">
<script type="text/javascript" src="/eac-core/res/kindeditor/kindeditor-all-min.js"></script>
<script type="text/javascript" src="js/news.js"></script>

<script type="text/javascript" src="/eac-core/res/kindeditor/lang/zh_CN.js"></script>
<script type="text/javascript" src="js/lightbox-2.6.min.js"></script>
<link media="screen" href="css/select2.css" rel="stylesheet">

<style type="text/css">
#searchContanter{position: absolute;top: 26px;z-index: 10;left: 2px;background-color: #eee}
#baseContainer{position: relative;}
#treePanel {white-space: nowrap;font-size:12px;margin: 0;width: 200px;height: 100%;padding: 0px 0px;float: left;border: 0px solid #c6dcf1;position: relative;overflow: auto;}
.sbtn{ background-color:#FFF; border:1px solid #CCC;height:24px; width:40px;cursor: pointer;} 

.dk_toggle {
    border: 1px solid #ccc;
    color: #333;
    padding: 5px -17px 5px 10px;
    text-shadow: #fff 1px 1px 0;
    border-radius: 3px;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    -webkit-transition: border-color .5s;
    -moz-transition: border-color .5s;
    -o-transition: border-color .5s;
    transition: border-color .5s;
    position: relative;
    white-space: nowrap;
    overflow: hidden;
    width: 196px;
}
</style>

<script type="text/javascript" src="js/select2.js"></script>
<script type="text/javascript" src="../../js/initTree.js"></script>
<script type="text/javascript">

var path = '${path}';
var rootId = '${user.orgCode}';
var orgType = '${orgType}';
var CHANNEL_ID = '${param.CHANNEL_ID}';
var oper = '${param.oper}';
var editor = null;
var flag = 0;
var selector = null;
var newUUID = '${newUUID}';

KindEditor.ready(function(K) {
	editor = K.create('#NEWS_CONTENT',{
			resizeType:0,
			items : simple,
			allowMediaUpload:false//禁止上传视频
		});
});	


$(function(){
	selector=createTreeSelector({inputId:"ORG_NAME",defaultOpen:'NEWS_ORG_NAME',width:240,selectLeaf:"true"});
});

$(function(){
	if('edit' == oper){
		$("#ORG_NAME").attr("disabled", true)
		$("#PROJNAME").attr("disabled", true)
		getNews();
	}
	if('view' == oper){
		console.log("进入到view")
		getNews();
		Form.formDisable('dataForm')
	}
	if ('add' == oper) {
		$("#ORG_NAME").attr("disabled", false)
		$("#PROJNAME").attr("disabled", false)
	}
});
$(function(){
	$("ORG_TYPE").val(orgType);
	$("#tree").height($(window).height());
	initTree();
})
/* $(function() {
	$("#NEWS_KEY_WORD").select2({
		width:250,
		tags:true,
		allowClear: true,
		placeholder: "请选择关键字"
	}); 
}); */



function closeDialog(){
	//解决chrome下iframe无法后退的问题
	/* if(parent.goTo){
		parent.goTo();
	}else{editMsg
		history.go(-1);
	} */
	if('edit' == oper){
		artDialog.opener.reloadGrid('grid');
		parent.art.dialog.get("editMsg").close();
	}else{
		artDialog.opener.reloadGrid('grid');
		parent.art.dialog.get("addMsg").close();
	}
	
}
function getNews(){
	var editPjorData = JSON.parse(localStorage.getItem("editPjorData"))
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.MsgDao:getNews",['${param.NEWS_ID}'],function(reply){
		var data = reply.getResult();

		data["ORG_NAME"] = editPjorData[0]
		console.log("修改的数据", data)
		/* data["ORG_NAME"]=data.NEWS_ORG_NAME; */
		Form.mapToForm('dataForm',data);
		editor.html(data.NEWS_CONTENT);
		//$("#NEWS_THUMB_IMG").val("");
		var url = '${baseImgPath}'+data.NEWS_THUMB_IMG
		$("#thumb_img").attr("src",url);
	});
	selectProjectInt()
}
function saveOrUpdate(){
	if(!Form.checkForm('dataForm')){
		return;
	}
	
	var postData = Form.formToMap('dataForm');
	var serviceUrl = null;
	var text = document.getElementById("MAIN_TITLE").value;
	if(text.length>100){
		alert('标题不能超过一百个字');
		return false;
	}
	
	if(postData["oper"] == 'edit'){
		serviceUrl = "${path}/com.pytech.timesgp.web.dao.MsgDao:updateNews";
	}else{
		serviceUrl = "${path}/com.pytech.timesgp.web.dao.MsgDao:addNews";
	}
	
	/* var _value = $("#NEWS_KEY_WORD").val();
    postData["NEWS_KEY_WORD"]=_value; */
    
    
	if(""==editor.html()){
		alert("内容: 不能为空");
	    return false;
	}
	postData["NEWS_CONTENT"] = editor.html();
	postData.PROJID=postData.PROJNAME
	
	if(flag == 0){
		ajax.remoteCall(serviceUrl,[postData],function(reply){
			var data = reply.getResult();
			flag = flag+1;
			
			dialogUtil.alert(data.msg, function() {
				if (data.success == true) {
					//artDialog.opener.reloadGrid('grid');
					closeDialog();
				}
			});
			
			
		});
	}
}
//路径
function finish(file){
	console.log('111111111111', file)
	var url = '${baseImgPath}news/'+file.name;
	$("#thumb_img").attr("src",url);
	$("#IMG_NAME").val(file.name);
}

//标题输入字数提示
$(function(){
	//$('#MAIN_TITLE').HRinputtip({tipId:'searchtip'});
	var input = $("input[name='MAIN_TITLE']");//$(this);
	var tipId = 'searchtip';//div的id属性
	
	if(tipId != ""){
		$(input).focusin(function(){
			$('#'+tipId).hide();
		}).focusout(function(){
			if($(input).val() == ""){
				$('#'+tipId).show();
			}
		});
		$('#'+tipId).click(function(){
			$(this).hide();
			$(input).focus();
		});
	}
});


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

	function selectProjectInt(target){
		var editPjorData = JSON.parse(localStorage.getItem("editPjorData"))
		var orgId = editPjorData[0]
		$("#PROJNAME").html("");
		console.log('editPjorData', editPjorData, editPjorData[1])
		var names = editPjorData[1]
		var idss = editPjorData[2]
		var serviceUrl = "${path}/com.pytech.timesgp.web.dao.SelectorDao:getProjectByAreaId";
		ajax.remoteCall(serviceUrl,[{"orgId":orgId}],function(reply){
			var data = reply.getResult();
			$("#PROJNAME").append('<option value='+idss+'>'+names+'</option>');
			for(var i=0;i<data.length;i++){
				if('${orgType}'=='PROJNAME')
					$("#PROJNAME").append('<option value="'+data[i].ORG_ID+'" selected="selected">'+data[i].ORG_NAME+'</option>');
				else
					$("#PROJNAME").append('<option value="'+data[i].ORG_ID+'">'+data[i].ORG_NAME+'</option>');
			}
		});
	}


	/* 加载销售组
	*/
	function selectGroup(target){
		console.log('1111~~1111111')
	}
</script>

</head>
<body style="overflow: auto;">
<br>

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
		<div id="head" style="margin-left: 10px;">
<form action="" id="dataForm">
<input type="hidden" name="newUUID" value="${newUUID}"/>
<input type="hidden" name="CHANNEL_ID" value="${param.CHANNEL_ID}"/>
<%-- <input type="hidden" name="TOPIC_ID" value="${param.TOPIC_ID}"/> --%>
<input type="hidden" name="oper" value="${param.oper}">
<input type="hidden" name="NEWS_THUMB_IMG" id="NEWS_THUMB_IMG"/>
<input type="hidden" name="NEWS_ORIGIN_IMG" id="NEWS_ORIGIN_IMG"/>
<input type="hidden" id="ORG_TYPE" name="ORG_TYPE" value='${orgType}'>
<c:if test="${'edit' == param.oper}">
	<input type="hidden" name="NEWS_ID" value="${param.NEWS_ID}"/>
</c:if>

<table width="100%" cellspacing="5" cellpadding="1">
	<tr>
		<td class="label" style="padding-right: 10px"><span class="require">*</span>地区公司:</td>
		<td width="198px" style="text-align: left;">
			<select disabled="false" id="ORG_NAME" name="ORG_NAME" class="textbox" onchange="selectProject($(this))" style="width:100%">
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
		<td class="label" style="padding-right: 10px"><span class="require">*</span>项目名称:</td>
		<td width="198px" style="text-align: left;">
			<select disabled="false" id="PROJNAME" name="PROJNAME" class="textbox" onchange="selectGroup($(this))" style="width:100%">
				<option value="">--请选择--</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="label" style="padding-right: 10px"><span class="require">*</span>标题:</td>
		<td width="198px" style="text-align: left;">
			<ui:TextBox id="MAIN_TITLE" caption="isnull:false;cname:标题" style="width:198px"></ui:TextBox>
		</td>
		<td width="100px" class="label" style="display:none;padding-right: 10px">作者:</td>
		<td width="240px" style="display:none;text-align: left;">
			<ui:TextBox id="NEWS_AUTHOR"></ui:TextBox>
		</td>
		<td width="100px" class="label" style="padding-right: 10px"><span class="require">*</span>栏目:</td>
		<td width="198px" style="text-align: left;">
			<ui:Select serviceId="com.pytech.timesgp.web.query.SubChannelSelect" id="CHANNEL_ID" parameter=""  caption="isnull:false;cname:栏目"/>
		</td>
	</tr>
	<tr style="display: none;">
		<td width="100px" class="label" style="padding-right: 10px">副标:</td>
		<td width="240px" style="text-align: left;">
			<ui:TextBox id="SUB_TITLE"></ui:TextBox>
		</td>
		<td width="100px" class="label" style="padding-right: 10px">来源:</td>
		<td width="240px" style="text-align: left;">
			<ui:TextBox id="NEWS_SOURCE" value=""></ui:TextBox>
		</td>
	</tr>
	
	<tr>
		<td width="100px" class="label" style="padding-right: 10px">图片:</td>
		<td width="240px" style="text-align: left;">
			<ui:FileUpload width="196px" onUploadSuccess="finish"  path="${savePath}" id="myFile" fileTypeExts="*.jpg" fileSizeLimit="10240"></ui:FileUpload>
			<!-- 
			<img id="thumb_img" style="width: 28px;height: auto;" />
			 -->
			<input type="hidden" id="IMG_NAME" name="IMG_NAME">
		</td>
		<td></td><td></td>
		<%-- <td width="100px" class="label" style="display:none;padding-right: 10px"><span class="require">*</span>栏目:</td>
		<td width="120px" style="display:none;text-align: left;">
			<ui:Select style="width:120px" serviceId="com.pytech.timesgp.web.query.SubChannelSelect" id="CHANNEL_ID" parameter=""  caption="isnull:false;cname:栏目"/>
		</td> --%>
	</tr>
	
	
	<tr>
		<td width="100px" class="label" valign="top" style="padding-right: 10px"><span class="require">*</span>内容:</td>
		<td colspan="3">
			<textarea id="NEWS_CONTENT"  style="width: 440px;height: 280px" ></textarea>
		</td>
	</tr>
</table>
</form>
		</div>
	</div>
</div>


<div style="width: 100%;text-align: center">
	<br>
	<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
	<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
</div>


</body>
</html>