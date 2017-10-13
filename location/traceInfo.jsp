<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String userCode = request.getParameter("userCode");
pageContext.setAttribute("userCode", userCode);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base >
    
    <title>My JSP 'traceInfo.jsp' starting page</title>
    <script type="text/javascript" src="/eac-core/res/jquery/jquery.js"></script>
<script type="text/javascript" src="/eac-core/res/jedate/jedate.js"></script>
<script language="javascript" type="text/javascript" src="/eac-core/res/My97DatePicker/WdatePicker.js"></script>

    <!-- 
     <ui:Include tags="DateTimePicker"></ui:Include>
      -->
     <link href="${path }/pages/css/custom.css" rel="stylesheet">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
	function doSearch(){
		var userCode = '${userCode}';
		var traceTime = $('#traceTime').val();
		if(null == traceTime || '' == traceTime){
			alert('外勤时间不能为空');
			return;
		}
		$('#contentFrame').attr("src","userTrace.jsp?userCode="+userCode+"&traceTime="+traceTime);
	}
	</script>
  </head>
  
  <body>
     <table>
     <tr><td >外勤时间:</td>
     <td >
     <input type="text"  id="traceTime"/><img onclick="WdatePicker({el:'traceTime'})" src="/eac-core/res/My97DatePicker/skin/datePicker.gif" width="16" height="22" align="absmiddle">
     </td><td ><input type="button" onclick="doSearch();" value="查询"></td><td></td>
     </tr>
     
     </table>
     <div id="content">
		<iframe  width="100%" height="100%" id="contentFrame" src=""></iframe>
	</div>
  </body>
</html>
