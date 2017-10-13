<%@page import="com.open.eac.core.util.FileUtil"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>

<%
	/* String savePath = AppHandle.getHandle(AppConstants.APP_NAME).getConfigProperty("BASE_PATH", ServerConfig.getEacHome()); */
	pageContext.setAttribute("savePath", FileUtil.changeSavePath());
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
.label {
	text-align: right
}

.require {
	color: red;
	padding-right: 1px;
}


#dataForm tr {
	height: 30px;
	line-height: 50px;
}
</style>
<title>call客导入</title>
<ui:Include tags="FileUpload,artDialog,Grid"></ui:Include>

<script type="text/javascript">
		var path = '${path}';
		//标志是否上传了文件
		var flag=false;
		var oper = '${param.oper}';
		function closeDialog(){
			parent.art.dialog.get("calleeImport").close();
		}
		
		$(function(){
			var height = $(window).height()
			$("#grid").height(370);
			$("#grid").width(587);
		});
		
		
		/* 保存用户 */
		var isClick = false;
		function saveOrUpdate(){
			if(!flag){
				dialogUtil.tips("请上传文件！");
				return;
			}
			/*
			var records = getSelectedRecords('grid');
			if(records.length == 0){
				dialogUtil.alert('请选择需要分配的销售人员！',true);
				return false;
			}
			
			var ids = new Array();
			for(var i = 0;i<records.length;i++){
				ids.push("'"+records[i].USER_CODE+"'");
			}
			*/
			var serviceUrl = "${path}/com.pytech.timesgp.web.dao.CalleeDao:addCalleeByExcelDao";
			
			if(isClick == false){
				isClick = true;
			}else{
				dialogUtil.tips("正在处理，请勿重复提交！");
				return;
			}
			Form.showWaiting();
			var postData = Form.formToMap('dataForm');
	//		postData['ids']=ids.join(",");
			ajax.remoteCall(serviceUrl,[postData],function(reply){
				isClick = false;
				Form.closeWaiting();
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					isClick = false;
					if(data.success == true){
						artDialog.opener.reloadGrid('grid');
						parent.art.dialog.get("calleeImport").close();
					}
				},function(){});
			});
		}
	
		function finish(file){
			flag = true;
			$("#fileName").val(file.name);
		}
		
		/* 性别 */
		var sex = {"1":"男","0":"女"}
		function sexRenderer(val,record){
			
			return sex[val];
			
		}
	</script>
</head>
<body style="overflow: hidden;">
	<form action="" id="dataForm">
		<input type="hidden" name="fileName" id="fileName">
		<div style="display: inline-block;margin-top: 10px;">
			<div style="margin: 0 auto;display: inline-block;">
				<span>Excel文件：</span>
				<ui:FileUpload width="200px;" path="${savePath}" id="myfileid"  onUploadSuccess="finish" fileTypeExts="*.xls;*.xlsx"></ui:FileUpload>
			</div>
			
			<div style="display: inline-block;margin-left: 20px;">
				<ui:Button btnType="save" onClick="saveOrUpdate();">立即导入</ui:Button>
			</div>
		</div>
		<div style="margin-top: 5px;">
			<span style="color: red;">注：请下载<a href="${path}/pages/call/Call客模板.xlsx" style="font-size: 17px;">模板</a>,按照模板文件填写数据后并导入文件</span>
		</div>
		
	</form>
	<ui:Grid style="display:none;background-color: #f3f3f3;margin-top:10px;" 
		id="grid" 
		dataProvider="${path}/com.pytech.timesgp.web.query.SalerQuery">
		
		<ui:GridField id="USER_CODE" width="" header="" checkColumn="true" exportable="false"/>
		<ui:GridField id="USER_NAME" width="200" header="销售名称" align="center"/>
		<ui:GridField id="USER_SEX" width="100" header="性别" align="center" renderer="sexRenderer"/>
		<ui:GridField id="GROUP_NAME" width="200" header="所属销售组" toolTip="true"/>
		<ui:GridField id="BELONG_ORG_NAME" width="200" header="所在项目" toolTip="true"/>
	</ui:Grid>
		
</body>
</html>