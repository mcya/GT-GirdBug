
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
<%
	//项目id
	String projid = request.getParameter("projid");
	//上传路径设置
   String tmpPath = ServerConfig.getEacHome();
   String savePath = CommonUtil.getCachePath();
   savePath = savePath.replaceAll("\\\\", "/")+File.separator+projid;
   File file = new File(savePath);
   if(!file.exists()){
	   file.mkdirs();
   }
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+request.getContextPath();
   String baseImgPath = basePath+"/Msg/img.action?path=";
   pageContext.setAttribute("savePath", savePath);
   pageContext.setAttribute("baseImgPath", baseImgPath);

%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
.label{text-align: right;font-weight:bold;}
.require{color: red;padding-right: 1px;}
#fileName{
	position: absolute;
    top: 52px;
    left: 118px;
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    width: 190px;
}
</style>
<title>沙盘图</title>
<meta name="renderer" content="webkit">
<link rel="stylesheet" href="${path }/pages/js/layui/css/layui.css"  media="all">
<ui:Include tags="artDialog,Select,FileUpload,zTree"></ui:Include>
<script type="text/javascript">
var path = '${path}';
var flag = 0;
function closeDialog(){
    parent.art.dialog.get("uploadSpt").close();
}
function saveOrUpdate(){
	if(!Form.checkForm('dataForm')){
		return;
	}
	
	var postData = Form.formToMap('dataForm');
	var serviceUrl = null;
	serviceUrl = "${path}/com.pytech.timesgp.web.dao.SptDao:addSpt";

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
	var url = '${baseImgPath}news/'+file.name;
	$("#thumb_img").attr("src",url);
	$("#IMG_NAME").val(file.name);
}

</script>
<style type="text/css">
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
</head>
<body style="overflow: auto;">
<br>
<form action="" id="dataForm" style="width:100%;text-align: center;margin: 0 auto">
<input type="hidden" name="projid" id="projid" VALUE="<%=projid%>"/>
<table width="100%" cellspacing="5" cellpadding="1">
	<!-- <tr bgcolor="#FFFFFF">
		<td width="100px" class="label" style="padding-right: 10px">图片:</td>
		<td width="240px" style="text-align: left;">
			<ui:FileUpload width="196px" onUploadSuccess="finish"  path="${savePath}" id="myFile" fileTypeExts="*.jpg" fileSizeLimit="10240"></ui:FileUpload>
			<input type="hidden" id="IMG_NAME" name="IMG_NAME">
		</td>
	</tr> -->
	<tr bgcolor="#FFFFFF">
		<td width="140px" class="label" style="padding-right: 10px"></td>
		<td width="240px" style="text-align: left;">
			<!-- <ui:FileUpload width="196px" onUploadSuccess="finish"  path="${savePath}" id="myFile" fileTypeExts="*.jpg" fileSizeLimit="10240"></ui:FileUpload> -->
			<div class="layui-upload">
			  <button type="button" class="layui-btn layui-btn-normal" id="test8">选择文件</button>
			  <button style="display: none;" id="test9">开始上传</button>
			</div>
			<input type="hidden" id="IMG_NAME" name="IMG_NAME">
		</td>
	</tr>
	<tr bgcolor="#FFFFFF" style="height: 10px;line-height: 30px;">
		<td width="135px" class="label" style="padding-right: 10px"></td>
		<td width="240px" style="text-align: left;">
			<p id="fileName"></p>
		</td>
	</tr>
</table>
</form>

<div style="width: 100%;text-align: center">
	<br>
	<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
	<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>
</div>

<script src="${path }/pages/js/layui/layui.js" charset="utf-8"></script>
<script>
layui.use('upload', function(){
  var upload = layui.upload;
  upload.render({
    elem: '#test8'
    ,url: '/upload/'
    ,auto: false
    // ,multiple: false
    ,bindAction: '#test9'
    ,done: function(res){
      console.log('done', res)
    },
    choose: function(obj) {
	    var files = obj.pushFile();
	    obj.preview(function(index, file, result){
		    console.log('index, file, result', index, file, file.name)
		    $("#fileName").append("已选择文件: <font color=blue>"+file.name+"</font>")
		    var url = '${baseImgPath}news/'+file.name;
			$("#thumb_img").attr("src",url);
			$("#IMG_NAME").val(file.name);
	    });
    }
  });
})
</script>



</fieldset>

</body>
</html>