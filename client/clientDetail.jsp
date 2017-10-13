<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.CustFollowDao"%>
<%@page import="com.pytech.timesgp.web.dao.CustomerDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>

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
	height: 25px
}
input{
	height: 30px
}
</style>
<title>structure</title>
<ui:Include tags="artDialog,Select"></ui:Include>
<ui:Data var="userData" value="${data}"></ui:Data>
<script type="text/javascript">
		var path = '${path}';
		var custName = '${param.custName}';
		var custCard = '${param.custCard}';
		var custId = '${param.id}';
		function excelImport(){
			var d='<%=id%>';
			location.href=path+"/servlet/excel.action?publicFlg=1&id="+d+"&fileName=公客详情";
		}
		function saveInfo() {
			if(!Form.checkForm('dataForm'))
				return;
			var postData = Form.formToMap('dataForm');
			ajax.remoteCall("${path}/com.pytech.timesgp.web.dao.BindDealCustDao:createNewCust",[postData],function(reply){
				var data = reply.getResult();
				dialogUtil.alert(data.msg,function(){
					if(data.success == true)
						history.go(-1);
				});
			});
		}
		
	</script>
</head>
<body style='font-family:"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:12px;'>
	<div class="container">
		<div style="line-height: 33px;margin-top:10px;position: relative;">
			<c:if test="${param.op!=1 }">
			<button class="btn btn-info" onclick="saveInfo()" style="float: right;margin-right: 40px;">保存</button>
			</c:if>
			<c:if test="${param.op==1 }">
			<button class="btn btn-info" onclick="excelImport()" style="float: right;margin-right: 40px;">导出公客详情</button>
			</c:if>
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
		
		<form action="" id="dataForm" style="padding-right: 10px;">
 		<input type="hidden" name="custId" id="custId" value="${param.id}" />
			<div id="myTabContent" class="tab-content">
			    <div class="tab-pane fade in active" id="baseInfo">
			     	<table width="" cellspacing="2" cellpadding="2" class="form-table" >
			     		<tr>
			     			<td width="100px" class="label1">姓名：</td>
			     			<td><input type="text" style="width:300px" id="CUST_NAME" name="CUST_NAME" <c:if test="${param.op==1 }">value="${entry.CUST_NAME }"</c:if> 
			     			<c:if test="${param.op!=1 }">value="${param.custName}"</c:if> <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> /></td>
			     			<td width="100px" class="label1">性别：</td>
			     			<td style="text-align: left">
								<input type="radio" name="CUST_SEX" ${entry.CUST_SEX==1?'checked="checked"':'' }  value="1" />男
								<input type="radio" style="margin-left:20px" name="CUST_SEX" ${entry.CUST_SEX==0?'checked="checked"':'' }  value="1" />女
							</td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">证件类型：</td>
			     			<td><input type="text" name="CARD_TYPE" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CARD_TYPE" value="${entry.CARD_TYPE}"/></td>
			     			<td width="100px" class="label1">证件号码：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">value="${entry.CRED_NO}"</c:if> 
			     			<c:if test="${param.op!=1 }">value="${param.custCard}"</c:if> <c:if test="${param.op==1 }">readOnly="readOnly"</c:if>  id="CRED_NO" name="CRED_NO" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">邮箱：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_EMAIL" name="CUST_EMAIL" value="${entry.CUST_EMAIL }" /></td>
			     			<td width="100px" class="label1">微信号：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_WX" name="CUST_WX" value="${entry.CUST_WX }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">通讯地址：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_ADDR" name="CUST_ADDR" value="${entry.CUST_ADDR }" /></td>
			     			<td width="100px" class="label1">手机号码：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_MOBILE" name="CUST_MOBILE" value="${entry.CUST_MOBILE }" /></td>
			     		</tr>
						<tr>
			     			<td width="100px" class="label1">客户来源：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_SOURCE" name="CUST_SOURCE" value="${entry.CUST_SOURCE }" /></td>
			     			<td width="100px" class="label1">拓展渠道：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_CHANNEL" name="CUST_CHANNEL" value="${entry.CUST_CHANNEL }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">获知途径：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_KNOW" name="CUST_KNOW" value="${entry.CUST_KNOW }" /></td>
			     			<td width="100px" class="label1">客户状态：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_SALE_STATUS" name="CUST_SALE_STATUS " value="${entry.CUST_SALE_STATUS  }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">流失原因：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="FAIL_REASON" name="FAIL_REASON" value="${entry.FAIL_REASON }" /></td>
			     			<td width="100px" class="label1">前所属销售员：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="PRE_SALE_NAME" name="PRE_SALE_NAME" value="${entry.SALE_NAME }" /></td>
			     		</tr>
			     		
			     		<!-- 公客详情的查看、增加“前所属销售”、“前所属销售组”、"转公客时间" -->
			     		<tr>
			     			<c:if test="${param.op==2 }">
			     			<td width="100px" class="label1">现所属销售员：</td>
			     			<td><input type="text" style="width:300px" id="SALE_NAME" name="SALE_NAME" value="${entry.SALE_NAME }" /></td>
			     			</c:if>
			     			<c:if test="${param.op!=1 }">
			     			<td></td><td></td>
			     			</c:if>
			     			<c:if test="${param.op==1 }">
			     			<td width="100px" class="label1">转公客时间：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="PUBLIC_TIME" name="PUBLIC_TIME" value="<fmt:formatDate value="${entry.PUBLIC_TIME }" pattern="yyyy-MM-dd HH:mm:ss"/>" /></td>
			     			</c:if>
			     		</tr>
			     	</table>
			   </div>
			   <div class="tab-pane fade" id="buyInfo">
			      	<table width="" cellspacing="2" cellpadding="2" class="form-table" >
			     		<tr>
			     			<td width="100px" class="label1">意向面积：</td>
			     			<td><input type="text" style="width:300px" id="INTENT_AREA" name="INTENT_AREA" value="${entry.INTENT_AREA }" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> /></td>
			     			<td width="100px" class="label1">付款方式：</td>
			     			<td>
								<input type="text" style="width:300px" id="PAY_WAY" name="PAY_WAY" value="${entry.PAY_WAY }" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> />
							</td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">购房目的：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="INTENT" name="INTENT" value="${entry.INTENT}"/></td>
			     			<td width="100px" class="label1">购房次数：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if>  id="HOUSE_TIME" name="HOUSE_TIME" value="${entry.HOUSE_TIME}" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">居住区域：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="LIVE_AREA" name="LIVE_AREA" value="${entry.LIVE_AREA }" /></td>
			     			<td width="100px" class="label1">工作区域：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="WORK_AREA" name="WORK_AREA" value="${entry.WORK_AREA }" /></td>
			     		</tr>
			     		<tr>
			     			<td width="100px" class="label1">工作行业：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_INDUST" name="CUST_INDUST" value="${entry.CUST_INDUST }" /></td>
			     			<td width="100px" class="label1">备&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
			     			<td><input type="text" style="width:300px" <c:if test="${param.op==1 }">readOnly="readOnly"</c:if> id="CUST_REMARK" name="CUST_REMARK" value="${entry.CUST_KNOW }" /></td>
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