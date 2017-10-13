<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ page import="com.open.eac.core.util.IdGenerator" %>
<%@ page import="com.open.eac.core.util.DateTimeUtil" %>
<%@page import="com.open.eac.core.config.ServerConfig"%>
<%@page import="com.pytech.timesgp.web.dao.SenNoticeDao"%>
<%@page import="com.alibaba.druid.util.StringUtils"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%
    //String newUUID = IdGenerator.getUuid();
	//pageContext.setAttribute("noticeid", newUUID);
	//获取应用的基本路径
	String tmpPath = ServerConfig.getEacHome();
	String savePath = AppHandle.getHandle("eac-core").getConfigProperty("BASE_PATH", tmpPath);
	savePath = savePath.replaceAll("\\\\", "/")+"/temp/";
	File file = new File(savePath);
	   if(!file.exists()){
		   file.mkdirs();
	   }   
      SenNoticeDao mydata = new SenNoticeDao();
       List<Map<String, Object>> allorg = mydata.GetOrgList();
       List<Map<String, Object>> alluser = mydata.GetUserList();
       pageContext.setAttribute("allorg", allorg);
       pageContext.setAttribute("alluser", alluser);
       pageContext.setAttribute("savePath", savePath);
    //得到角色   
 %>
<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>新建公告</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<ui:Include tags="zTree,artDialog,DatePicker,FileUpload,Select"></ui:Include>
<script type="text/javascript" src="js/initTree.js"></script> 
<script type="text/javascript" src="/eac-core/res/kindeditor/kindeditor-all-min.js"></script>
<script type="text/javascript" src="/eac-core/res/kindeditor/lang/zh_CN.js"></script>
<link rel="stylesheet" href="/eac-core/res/kindeditor/themes/default/default.css" />
<script type="text/javascript" src="js/jquery-ui.min.js"></script> 
<script type="text/javascript" src="js/jquery.tagsinput.js"></script> 
<link type="text/css" href="css/jquery.tagsinput.css" rel="stylesheet">
<link type="text/css" href="css/jquery-ui.css" rel="stylesheet">
<script type="text/javascript">

var path = '${path}';
var mypath = '${path}';
//var noticeid = '${noticeid}';
var savepath = '${savePath}'+'/';
var oper = '${param.oper}';
var rootId = '${user.orgCode}';
var editor = null;
 var t;
/* var c; */
var $tag_box;
var act;

//记录原来的文件ID
var fileIds = '';


/* var $boxc; */
 function levCase(){	
		 document.getElementById("treediv").style.display="none";
		 document.getElementById("textdiv").style.width="100%";
}
function getCase(id){
	document.getElementById("treediv").style.display="none";
	 document.getElementById("textdiv").style.width="100%";
}
//标签
 $(function(){
   t=$("#tagBox1").tagsInput({ width: 'auto' ,height:'20px'});
    $tag_box = t[0];
   /*  c=$("#tagBox2").tagsInput({ width: 'auto' ,height:'20px'});
    $boxc = c[0]; */
}); 
$(function() {
	if ('edit' == oper) {
		getNotice();
	}
});

//文本编辑
KindEditor.ready(function(K) {
	editor = K.create('#NOTICE_CONTENT',{'resizeType':0});
});

//树
 $(function(){
	//组织架构调整：只允许选择叶子节点，机构树只出现CITY_CENTER,PARTY_COMMITTEE,GENERAL_PARTY_BRANCH_L1,PARTY_BRANCH_L1这几种类型 
		selector = createTreeSelector({
			inputId : "ORG_ID_REVIEW",
			url : path+"/servlet/structure.action?method=structure&rootId="+rootId,
			width : 250,
			multiSelect : true,
			selectLeaf : 'true',
			includeTypes : 'AREA,CORP,PROJECT',
			asyncAll : true
		});	
	});

 function getNotice(){
	 ajax.remoteCall(
				"${path}/com.pytech.timesgp.web.dao.SenNoticeDao:getNotice",
				[ "${param.NOTICE_ID}"],
				function(reply) {
					var data = reply.getResult();
					Form.mapToForm('noticeForm',data);
					if(data.EMERGENCY=='0'){
						$("#putong").click();
					}else{
						$("#jinji").click();
					}
					/* document.getElementById("tagBox").innerHTML = data.TO_USERS; */
					$("#ORG_ID_REVIEW").val(data.CC_USERS);
					
					$("#orgIds").val(data.TO_USERS);
					/* var listuser=new Array();
					 listuser=userorg.split(",")
					for(var k=0;k<listuser.length;k++){
						$('#tagBox1').addTag(listuser[k]);	
					}	 */
					 
					 /* var orguser=data.CC_USERS;
						var listorg=new Array();
						listorg=orguser.split(",")
						for(var k=0;k<listorg.length;k++){
							$('#tagBox2').addTag(listorg[k]);	
						}	 */
					editor.html(data.NOTICE_CONTENT);
				});
//得到保存而不是提交的历史附件
ajax.remoteCall(
				"${path}/com.pytech.timesgp.web.dao.SenNoticeDao:getSaveFile",
				[ "${param.NOTICE_ID}"],
				function(reply) {
					var mydata = reply.getResult();
					var list = mydata;
					if (list || list.size() > 0) {
						for (var i = 0; i < list.length; i++) {
							var html = '<span><a id="a_'+list[i].ATTACH_ID+'" href="javascript:;" onclick="removeNewAttach(\''+ list[i].ATTACH_ID+'\')">'
									+ '【删除】</a>'
									+ list[i].ATTACH_NAME
									+ '<br></span>';
							$("#attaches1").append(html);
						}
					}
					$("#attaches1").append("--------------------------------------------<br/>");
				});
 }
 
 /* 
 	移除原来的文件
 */
 function removeNewAttach(id){
	 
	 if(fileIds==""){
		 fileIds=id;
	 }else{
		 fileIds+=","+id
	 }
	 $("#fileFlag").val("1");
	 $("#a_"+id).parent().remove();
 }
 
 
 function heigsel(){
	/*  dialogUtil.open("heigsel","高级选择","heigsel.jsp?",170,300,function(){
		 
		}); */
	 document.getElementById("treediv").style.display="none";
	 document.getElementById("heightsel").style.display="";
	 document.getElementById("textdiv").style.width="80%";
 }
 function saveOrUpdate() {
		var postData = Form.formToMap('heigselForm');
		/* alert(postData.TO_USERS_HEIGHT); */
		 $('#tagBox1').addTag(postData.TO_USERS_HEIGHT);
	}
 function closeDialog(){
	 document.getElementById("treediv").style.display="none";
	 document.getElementById("heightsel").style.display="none";
	 document.getElementById("textdiv").style.width="100%";
	}
</script>
<style type="text/css">
.require{
   color: red;
 }
 body a {
	text-decoration: none;
	color: #1024EE;
	line-height: 2.0;
	
	font-weight: bold;
}
 .sbtn{ background-color:#FFF; border:1px solid #CCC;height:25px; width:30px;cursor: pointer;} 
 .table1{
    line-height: 20px;
    border-bottom: 1px solid #CCC;
    width: 100%;
    height: 40px;
    margin: 0px auto;
    overflow: auto;
  }
  .table1:HOVER {
   background-color: #D3E9F9;
   cursor:pointer;
}
</style>
</head>
<body style="margin:0px auto;overflow:auto;">
<form action="" id="hiddenForm" style="display: none">
	<input id="orgId"/>
	<input id="orgName"/>
	<input id="orgCode"/>
	<input id="busiCode"/>
	<input id="orgType"/>
	<input id="orgScore"/>
</form>

     <div id="textdiv" style="width: 100%;overflow:auto;float: left;">
		<form action="" id="noticeForm">
		<!-- 文件修改状态
			0:没有修改
			1:重新上传
			2:在原来基础上删除
		 -->
		<input type="hidden" name="fileFlag" id="fileFlag" value="0">
		<input type="hidden" name="oper" value="${param.oper}">
		
		<c:if test="${param.oper=='edit' }">
			<input type="hidden" name="NOTICE_ID" value="${param.NOTICE_ID}">
			<input type="hidden" id="orgIds" name="orgId">
		</c:if>
		<fieldset style="border:1px solid #e5e5e5;padding:10px;	margin:10px;display:block;overflow:hidden;text-align: left;">
     	<c:if test="${param.oper=='new' }">
		<h3 align="center">新建公告<div style="float: right"></div></h3>
		</c:if>
		<c:if test="${param.oper=='edit' }">
			<h3 align="center">修改公告<div style="float: right"></div></h3>
		</c:if>
			<hr style="border:0;border-bottom:1px solid #e5e5e5;margin: 10px 0;">
			<div id="receiveOrg" style="margin-top: 8px;">
					<span class="require">*</span><b>接收对象：</b>
					<textarea id="ORG_ID_REVIEW" name="TO_ORG_NAMES" rows="3"
						placeholder="点击选择机构" style="width: 100%; height: 40px;"
						 class="textbox"></textarea>
				</div>
			
			<div id="tittle">
				<span class="require">*</span><b>主题：</b><br/>
				<ui:TextBox id="NOTICE_TITLE" style="width:100%"></ui:TextBox>
			</div>			
						
			<div id="content" style="margin-top:8px;">
				<span class="require">*</span><b>正文：</b>
				<textarea id="NOTICE_CONTENT" caption="" style="margin-top:8px;width: 100%;height: 250px;"></textarea>
			</div>
			<div>
				<table style="margin:0px 0px 0px 0px;">
					<tr height="40px">
						<td><h5>添加附件：</h5></td>
						<td width="300px"><ui:FileUpload width="80" path='${savePath }' id="upload"  onUploadSuccess="finish" fileTypeExts="*.xls;*.doc;*.docx;*.ppt;*.pptx;*.xlsx" multiType="true"></ui:FileUpload></td>
						<td width="20px">&nbsp;</td>						
					</tr>										
				</table>		
				<div style="width: 100%;" id="attaches1"></div>
				<div style="width: 100%;" id="attaches"></div>			
			</div>
			
			<div id="buttonGroup">
			<hr style="border:0;border-bottom:1px solid #e5e5e5;margin: 10px 0;">
				<table style="margin-left: 30%;">
					<tr>
						<td>
							<c:if test="${param.oper=='new'}">
								<ui:Button btnType="add" onClick="javascript:addNotice('0','new')">存为草稿</ui:Button>
								<ui:Button btnType="save" onClick="javascript:addNotice('1','new')">立即发送</ui:Button>
							</c:if> 
							<c:if test="${param.oper=='edit'}">
								<ui:Button btnType="add" onClick="javascript:addNotice('0','edit')">存为草稿</ui:Button>
								<ui:Button btnType="save" onClick="javascript:addNotice('1','edit')">立即发送</ui:Button>
							</c:if>
						</td>
						<td>
					    	<ui:Button btnType="cancel" onClick="javascript:window.close()">关闭</ui:Button>
						</td>
					</tr>
				</table>
			</div>
			</fieldset>
		</form>
		</div>
		<div id="treediv" style="width: 19%;height: 300px;float: left;display: none;">
		<input type="text" id="myintivi" class="textbox" placeholder="请输入机构名称" style="width:56%;">
		<input type="button" value="搜索" onclick="SearchHD();" class="sbtn"/>
		<input type="button" value="重置" onclick="ResetHD();" class="sbtn"/>
		<div id="tree" class="ztree" style="width: 100%;height: 200px;float: right;margin: 0px auto;overflow:auto ;display:'';">
		</div>
		 <div id="orglist" style="width: 100%;height: 300px;float: right;margin: 0px auto;overflow:auto ;display: none;">
		
		<c:forEach items="${allorg}" var="myorg" varStatus="j">
		<table class="table1" id="myorglist${j.index}" onclick="acsearch('${myorg.ORG_NAME}')" >
		 <tr><td>${myorg.ORG_NAME}</td></tr>
		 </table>
		 </c:forEach>
		<c:forEach items="${alluser}" var="myuser" varStatus="k">
		<table class="table1" id="myuserlist${k.index}" onclick="acsearch('${myuser.USER_NAME}')" >
		 <tr><td>${myuser.USER_NAME}</td></tr>
		 </table>
		 </c:forEach>
		 </div>
		</div>
<!-- 角色选择 -->		
		<div id="heightsel" style="width: 19%;float: left;background-color: #FFFFFF;margin: 0px auto;overflow:auto;display:none;"></div>
</body>
<script type="text/javascript">
var index = 0;
var fileNames = '';
var chec=true;
var fileIndex=0;
var showFile = [];




/* 上传成功调用得方法 */
function finish(file){
	
	
	$("#fileFlag").val("1");
	
	if(fileNames == ""){
		fileNames=file.name;
	}else{
		fileNames=fileNames+","+file.name;
	}
	showFile[fileIndex]=file.name;
	var html = "【<a href='javascript:;' onclick='removeFile("+fileIndex+")'>删除</a>】"+file.name+"<br>"
	
	$("#attaches").append(html);
	fileIndex++;
	$("#upload").val(fileNames);
}

//删除文件名
function removeFile(fileInde){
	
	showFile.splice(fileInde,1);
	
	$("#fileFlag").val("2");
	
	$("#attaches").html("");
	for(var i=0;i<showFile.length;i++){
		var html = "【<a href='javascript:;' onclick='removeFile("+i+")'>删除</a>】"+showFile[i]+"<br>"
		$("#attaches").append(html);
	}
	fileNames = showFile.toString();
	$("#upload").val(fileNames);
	fileIndex--;
}



function SearchHD(){
	$("#orglist").show();
	$("#tree").hide();
    
    	  $("#orglist table").hide().filter(":contains('"+( $("#myintivi").val() )+"')").show();
    
}
function ResetHD(){
	$("#tree").show();
	$("#orglist").hide();
}
function acsearch(orgname){
	/*  var isshow=document.getElementById("cstagBox").style.display;
	if(isshow == "none"){ */
		$('#tagBox1').addTag(orgname,{focus:true,unique:true})
	/* }else{
		$('#tagBox2').addTag(orgname)
	}  */
}
function back(){
	history.go(-1);
}
</script>

</html>