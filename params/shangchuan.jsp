
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
   savePath = savePath.replaceAll("\\\\", "/")+File.separator+projid+File.separator+"ProjAndDetailImg";
   File file = new File(savePath);
   if(!file.exists()){
	   file.mkdirs();
   }
   String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/"+request.getContextPath();
   String basePathh = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
   String baseImgPath = basePath+"/Msg/img.action?path=";
   String baseImgPathh = basePathh+"/Msg/img.action";
   pageContext.setAttribute("savePath", savePath);
   pageContext.setAttribute("baseImgPath", baseImgPath);
   pageContext.setAttribute("baseImgPathh", baseImgPathh);

%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9,chrome=1" />

<meta name="renderer" content="webkit">
<link rel="stylesheet" href="${path }/pages/js/layui/css/layui.css"  media="all">

<style type="text/css">
.label{text-align: right;font-weight:bold;}
.require{color: red;padding-right: 1px;}
</style>
<title>沙盘图</title>
<ui:Include tags="artDialog,Select,FileUpload,zTree"></ui:Include>
<script type="text/javascript">
var path = '${path}';
var flag = 0;
function getUrlParam(paramName) {
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=") > 1) {
        arrSource = unescape(this.location.search).substring(1, this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound) {
            if (arrSource[i].indexOf("=") > 0) {
                if (arrSource[i].split("=")[0].toLowerCase() == paramName.toLowerCase()) {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                }
            }
            i++;
        }
    }
    return paramValue;
}
function closeDialog(){
    parent.art.dialog.get("shangchuan").close();
}
function saveOrUpdate(){
	if(!Form.checkForm('dataForm')){
		return;
	}
	
	var postData = Form.formToMap('dataForm');
	var treeSeleted = JSON.parse(localStorage.getItem("treeSeleted"))	
	var isZuzhi = getUrlParam('isZuzhi')
	var serviceUrl = null;
	serviceUrl = "${path}/com.pytech.timesgp.web.dao.AttachDao:uploadProjAttach";


	if(isZuzhi==1){
		var saveParams = {
			IMG_NAME: postData.IMG_NAME,
			type: 'proj',
			projid: treeSeleted[1]
		}
		ajax.remoteCall(serviceUrl,[saveParams],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg, function() {
				if (data.success == true) {
					closeDialog();
				}
			});
		});
		return
	}
	if (isZuzhi==0) {
		var prjid = getUrlParam('projid')
		var saveParams = {
			IMG_NAME: postData.IMG_NAME,
			type: 'detail',
			projid: prjid
		}
		ajax.remoteCall(serviceUrl,[saveParams],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg, function() {
				if (data.success == true) {
					closeDialog();
				}
			});
		});
		return
	}
}
//路径
function finish(file){
	console.log("上传path", '${savePath}')
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
</head>
<body style="overflow: auto;">
<br>
<form action="" id="dataForm" style="width:100%;text-align: center;margin: 0 auto">
<input type="hidden" name="projid" id="projid" VALUE="<%=projid%>"/>
<table width="100%" cellspacing="5" cellpadding="1">
	<tr bgcolor="#FFFFFF">
		<td width="140px" class="label" style="padding-right: 10px"></td>
		<td width="240px" style="text-align: left;">
			<!-- <ui:FileUpload width="196px" onUploadSuccess="finish"  path="${savePath}" id="myFile" fileTypeExts="*.jpg" fileSizeLimit="10240"></ui:FileUpload> -->
			<div class="layui-upload">
			  <button type="button" class="layui-btn layui-btn-normal" id="test1">选择文件</button>
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
  var isZuzhi = getUrlParam('isZuzhi')
  var projidValue = ''
  if(isZuzhi==1){
  	var treeSeleted = JSON.parse(localStorage.getItem("treeSeleted"))
  	projidValue = treeSeleted[1]
  } else if (isZuzhi==0) {
  	projidValue = getUrlParam('projid')
  }
  var urlValue = "/home/asiainfo1/upload/"+projidValue+"/ProjAndDetailImg/"
  console.log("~~~", '${savePath}', projidValue, urlValue,)
  var realUrl = '${baseImgPathh}'+"?path="+urlValue
  console.log("~~~~~~~~~~", '${baseImgPath}', '${baseImgPathh}', realUrl)
  var urlrrrrrr = '${savePath}'+"/"
  upload.render({
    elem: '#test1'
    ,url: urlrrrrrr
    // ,field: urlValue
    // ,method: 'get'
    ,auto: true
    // ,multiple: false
    // ,bindAction: '#test9'
    ,done: function(res){
      console.log('done', res)
    }
    ,error: function(index, upload) {
    	console.log("error", index, upload)
    }
    ,choose: function(obj) {
    	//将每次选择的文件追加到文件队列
	    var files = obj.pushFile();
	    
	    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
	    obj.preview(function(index, file, result){
	      console.log('index, file, result', index, file, file.name)
	      // console.log(index); //得到文件索引
	      // console.log(file); //得到文件对象
	      // console.log(result); //得到文件base64编码，比如图片
	      $("#fileName").append("已选择文件: <font color=blue>"+file.name+"</font>")
	      //这里还可以做一些 append 文件列表 DOM 的操作

	    // gt-gril操作
	    var url = '${baseImgPath}news/'+file.name;
		$("#thumb_img").attr("src",url);
		$("#IMG_NAME").val(file.name);
	      
	      //obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
	      //delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
	    });
    },
  });
})
</script>


</fieldset>

</body>
</html>