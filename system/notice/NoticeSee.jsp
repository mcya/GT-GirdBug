<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ page import="com.open.eac.core.util.IdGenerator" %>
<%@ page import="com.open.eac.core.util.DateTimeUtil" %>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.open.eac.core.config.ServerConfig"%>
<%@page import="java.io.File"%>
<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<%
	//获取应用的基本路径
	   String baseFilePath = request.getContextPath()+"/file.action?filePath=";
		pageContext.setAttribute("baseFilePath", baseFilePath);
	   
%>

<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>
<%-- <c:set var="remoteTemplatePath" value="<%=remoteTemplatePath%>"></c:set> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>公告详情</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<ui:Include tags="zTree,artDialog,DatePicker,FileUpload,Select"></ui:Include>
<!-- <script type="text/javascript" src="../js/initTree.js"></script>  -->
<!-- <script type="text/javascript" src="../js/tagging.min.js"></script>
<script type="text/javascript" src="/eac-core/res/kindeditor/kindeditor-all-min.js"></script>
<script type="text/javascript" src="/eac-core/res/kindeditor/lang/zh_CN.js"></script>
<link rel="stylesheet" href="/eac-core/res/kindeditor/themes/default/default.css" /> -->
<link type="text/css" href="../css/tag-basic-style.css" rel="stylesheet">
<script type="text/javascript">

var path = '${path}';
var mypath = '${path}';
var oper = '${param.oper}';
var rootId = '${user.orgCode}';
var editor = null;
var t;
var $tag_box;

$(function() {
	if ('view' == oper) {
		getNotice();
	}
});

/* KindEditor.ready(function(K) {
	editor = K.create('#NOTICE_CONTENT',{'resizeType':0});
}); */
/* //标签
 $(function(){
	t=$("#tagBox").tagging();
	$tag_box = t[0];
}); */
//单选	
 var emergency=null;
 function change()
 {
  var New=document.getElementsByName("GroupName");
  var strNew;
  for(var i=0;i<New.length;i++)
  {
   if(New.item(i).checked) 
   {
    strNew=New.item(i).getAttribute("value"); 
    emergency=strNew;
    break;
   }
   else
   {
    continue;
   }
  }  
 }
 
 function getNotice(){
	 ajax.remoteCall(
				"${path}/com.pytech.timesgp.web.dao.SenNoticeDao:readNotice",
				[ "${param.NOTICE_ID}"],
				function(reply) {
					var data = reply.getResult();
					Form.mapToForm('noticeForm',data);
					if(data.EMERGENCY=='0'){
						$("#putong").click();
					}else{
						$("#jinji").click();
					}
					 document.getElementById("resname").innerHTML = data.CC_USERS;
					 document.getElementById("sentime").innerHTML = null == data.SEND_TIME?"":data.SEND_TIME;
					 document.getElementById("senname").innerHTML = data.CREATE_USER_NAME;
					 document.getElementById("NOTICE_CONTENT").innerHTML = data.NOTICE_CONTENT;
					 document.getElementById("NOTICE_TITLE").innerHTML = data.NOTICE_TITLE;
					 /* var userorg=data.TO_USERS;
					var listuser=new Array();
					 listuser=userorg.split(",")
					for(var k=0;k<listuser.length;k++){
						$tag_box.tagging( "add",listuser[k]);	
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
							var html = '<span><a href="${baseFilePath}'+list[i].ATTACH_PATH+'&ATTACH_ID='+list[i].ATTACH_ID+'&fileName='+list[i].ATTACH_NAME+'">'+[i+1]+':【下载附件】'+list[i].ATTACH_NAME+'</a><br></span>';		
							 $("#attaches").append(html);
						}
					}
				});
 }
 
 function goback(){
	 window.close();
 }
 
</script>
<style type="text/css">
#showOrHideAccessory .btn,#createAck .btn{height:20px;padding-top:1px;}
.require{
   background-color: #F4F6F8;
   width: 100%;
   height:30px;
   line-height: 20px;
 }
</style>
</head>
<body style="margin:0px auto;overflow:auto;">
     <div style="width: 100%;overflow:auto;float: left;">
     <div style="width: 97%;margin-left: 10px;background-color: #F4F6F8">
     <table style="line-height: 2.0;">
     <tr><td>发件人：</td><td><div id="senname"></div></td></tr>
     <tr><td>时&nbsp;&nbsp;间：</td><td><div id="sentime"></div></td></tr>
     <tr><td>收件人：</td><td><div id="resname"></div></td></tr>
     </table>
     </div>
		<form action="" id="noticeForm">
		<fieldset style="border:1px solid #e5e5e5;padding:10px;	margin:10px;display:block;text-align: left;">		
			<!-- <h3 align="center">查看公告<div style="float: right"><a href="javascript:;" onclick='goback()'>返回上一级</a></div></h3>
			<hr style="border:0;border-bottom:1px solid #e5e5e5;margin: 10px 0;"> -->
			<div id="tittle">
				<div style="width: 100%;border-bottom : 1px solid #e5e5e5;float: left;background-color:#F4F6F8;font-size: 15px;"><h5>主题：</h5></div><br/>
				<%-- <ui:TextBox id="NOTICE_TITLE" readOnly="true"></ui:TextBox> --%>
			<span id="NOTICE_TITLE" style="margin-top:8px;width: 100%;height: 80px;"></span>
			</div>			
			<!-- <div id="receiveOrg" style="margin-top: 8px;">
				<span class="require">*</span><b>接收对象：</b><br/>
			 <div data-tags-input-name="tag" id="tagBox" style="width:98%;height: 20px;overflow: auto;"></div> 
			</div>	 -->		
			<div id="content" style="margin-top:8px;">
				<div style="width: 100%;border-bottom : 1px solid #e5e5e5;float: left;background-color:#F4F6F8;font-size: 15px;"><h5>正文：</h5></div></br>
				<!-- <textarea id="NOTICE_CONTENT" caption="" style="margin-top:8px;width: 100%;height: 260px;" readonly="readonly"></textarea> -->
			   <span id="NOTICE_CONTENT" style="margin-top:8px;width: 100%;height:300px;"></span>
			</div>
			
			</fieldset>
		
		</div>
		<div style="width: 98%;margin-left: 10px;border-bottom : 1px solid #e5e5e5;float: left;background-color:#F4F6F8;">
				<%-- <table style="margin:0px 0px 0px 0px;">
					<tr height="40px">
						<td><h5>失效时间:</h5></td>
							<td width="130px"><ui:TextBox id="INVALID_TIME" readOnly="true"></ui:TextBox></td>
							<td width="20px">&nbsp;</td>
							<td><h5>公告类型:</h5></td>
						<td width="5px;"></td>
						<td><input type="radio" value="0" name="GroupName" onchange = "change();" id="putong">普通</td>
						<td width="5px;"></td>
						<td><input type="radio" value="1" name="GroupName" onchange = "change();" id="jinji">紧急</td>						
						</tr>										
				</table>	 --%>
				<div style="font-size: 15px;"><h5>附件列表：</h5></div>	
				<div style="width: 100%;" id="attaches"></div>			
			</div>
		</form>		
		<div id="buttons" style="text-align: center;">				
	 <ui:Button onClick="javascript:goback();" btnType="cancel">返回</ui:Button>
		</div>
</body>


</html>