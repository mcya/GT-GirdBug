<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.CustFollowDao"%>
<%@page import="com.pytech.timesgp.web.dao.CustomerDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>

<%
	//客户id
	String id = request.getParameter("id");
	CustomerDao customerDao = new CustomerDao();
	//公客信息
	pageContext.setAttribute("entry",customerDao.getEntryById(id));
	
	//查询记录
	CustFollowDao custFollowDao = new CustFollowDao(); 
	List<Map<String,Object>> lists = custFollowDao.getEntrysById(id);
	pageContext.setAttribute("list",lists);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<link rel="stylesheet"  href="/times-web/assets/css/bootstrap.min.css" />
<script type="text/javascript" src="/times-web/assets/js/jquery.min.js" ></script>
<script type="text/javascript" src="/times-web/assets/js/bootstrap.min.js" ></script>
<style type="text/css">
.label1 {
	color: #555555;
	text-align:right;
	font-family:"Microsoft YaHei"; 
}
.div-inline{ 
	display:inline
}

.require {
	color: red;
	padding-right: 1px;
}

.form-table {
	margin-top: 10px;
}

.form-table tr {
	height: 40px;
}
#myTab>li a{
	color:#555555;
}
#myTab>li.active a{
	 border-bottom: 5px solid #f0ad4e;
	 color:#2b7ac4;
}
.nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {
    color: #585757;
    cursor: default;
    border:0;
}

 .nav-tabs > li > a {
 	width: 80px;
    border-radius: 4px 4px 0 0;
}
table thead th,table tbody td{
	text-align: center;
	height: 30px
}
table thead th{
height: 25px}
input{
height: 30px}
</style>
<title>structure</title>
<ui:Include tags="artDialog,Select,DateTimePicker"></ui:Include>
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">
		var path = '${path}';
		$(function(){
			
			
		});
		
		function excelImport(){
			var d='<%=id%>';
			location.href=path+"/servlet/excel.action?publicFlg=0&id="+d+"&fileName=客户详情";
			
		}
	</script>
</head>
<body style='font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:12px;'>
	<div class="container">
		<div style="line-height: 33px;margin-top:10px;position: relative;">
			<button class="btn btn-info" onclick="excelImport()" style="float: right;margin-right: 40px;">导出客户详情</button>
			<button class="btn btn-warning"onclick="history.go(-1);" style="position: absolute;right: -20px">返回</button>
		</div>
	
		<ul id="myTab" class="nav nav-tabs">
		   <li class="active">
		      <a href="#baseInfo" data-toggle="tab">
		         	基础信息
		      </a>
		   </li>
		   <li><a href="#buyInfo" data-toggle="tab">购房信息</a></li>
		   <li><a href="#followInfo" data-toggle="tab">跟进信息</a></li>
		</ul>
		 <form action="" id="userForm" style="padding-right: 10px;">
		<div id="myTabContent" class="tab-content">
			   <div class="tab-pane fade in active" id="baseInfo">
			     	<table width="" cellspacing="2" cellpadding="2" class="form-table" >
			     		<tr>
			     			<td width="100px" class="label1">姓名：</td>
			     			<td><input type="TextBox" style="width:300px" id="CUST_NAME" value="${entry.CUST_NAME }" readOnly="readOnly" /></td>
			     			<td width="100px" class="label1">性别：</td>
			     			<td style="text-align: left">
								<input type="radio" name="CUST_SEX" ${entry.CUST_SEX==1?'checked="checked"':'' }  value="1" />男
								<input type="radio" style="margin-left:20px" name="CUST_SEX" ${entry.CUST_SEX==0?'checked="checked"':'' }  value="1" />女
							</td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">证件类型：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CARD_TYPE" value="${entry.CARD_TYPE}"/></td>
			     			<td width="100px" class="label1">证件号码：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly"  id="CRED_NO" value="${entry.CRED_NO}" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">邮箱：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_EMAIL" value="${entry.CUST_EMAIL }" /></td>
			     			<td width="100px" class="label1">微信号：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_WX" value="${entry.CUST_WX }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">通讯地址：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_ADDR" value="${entry.CUST_ADDR }" /></td>
			     			<td width="100px" class="label1">手机号码：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_MOBILE" value="${entry.CUST_MOBILE }" /></td>
			     		</tr>
						<tr>
			     			<td width="100px" class="label1">客户来源：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_SOURCE" value="${entry.CUST_SOURCE }" /></td>
			     			<td width="100px" class="label1">拓展渠道：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_CHANNEL" value="${entry.CUST_CHANNEL }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">获知途径：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_KNOW" value="${entry.CUST_KNOW }" /></td>
			     			<td width="100px" class="label1">客户状态：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_SALE_STATUS " value="${entry.CUST_SALE_STATUS  }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">流失原因：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="FAIL_REASON" value="${entry.FAIL_REASON }" /></td>
			     			
			     		</tr>
			     	</table>
			   </div>
			   <div class="tab-pane fade" id="buyInfo">
			      	<table width="" cellspacing="2" cellpadding="2" class="form-table" >
			     		<tr>
			     			<td width="100px" class="label1">意向面积：</td>
			     			<td><input type="TextBox" style="width:300px" id="INTENT_AREA" value="${entry.INTENT_AREA }" readOnly="readOnly" /></td>
			     			<td width="100px" class="label1">付款方式：</td>
			     			<td>
								<input type="TextBox" style="width:300px" id="PAY_WAY" value="${entry.PAY_WAY }" readOnly="readOnly" />
							</td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">购房目的：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="INTENT" value="${entry.INTENT}"/></td>
			     			<td width="100px" class="label1">购房次数：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly"  id="HOUSE_TIME" value="${entry.HOUSE_TIME}" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">居住区域：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="LIVE_AREA" value="${entry.LIVE_AREA }" /></td>
			     			<td width="100px" class="label1">工作区域：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="" value="${entry.WORK_AREA }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">工作行业：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_INDUST" value="${entry.CUST_INDUST }" /></td>
			     			<td width="100px" class="label1">备&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
			     			<td><input type="TextBox" style="width:300px" readOnly="readOnly" id="CUST_KNOW" value="${entry.CUST_KNOW }" /></td>
			     		</tr>
			     	</table>
			   </div>
			    <div class="tab-pane fade" id="followInfo">
			      	<table border="1" style="border-collapse: collapse;border:1px solid #dedede;margin:20px auto 0;">
						<thead>
							<tr>
								<th width="300px">时间</th>
								<th width="300px">方式</th>
								<th width="300px">备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="list" items="${list}">
								<tr>
									<td>${list.ACTION_TIME }</td>
									<td>${list.ACTION }</td>
									<td>${list.ACTION_RESULT }</td>
								</tr>
							</c:forEach>
						</tbody>
						
					</table>
			   </div>
		</div>
		 </form>
	</div>
	
</body>
</html>