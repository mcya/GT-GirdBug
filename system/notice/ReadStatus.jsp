<%@page import="com.pytech.timesgp.web.dao.SenNoticeDao"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<c:set var="path" value="<%=request.getContextPath()%>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request)%>"></c:set>
<%
	String noticeid = request.getParameter("NOTICE_ID");
	SenNoticeDao mydata = new SenNoticeDao();
	List<Map<String, Object>> readlist = mydata.GetReadList(noticeid);
	pageContext.setAttribute("readlist", readlist);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>阅读详情</title>
<ui:Include tags="artDialog"></ui:Include>
<style type="text/css">
.mytable {
	width: 100%;
	text-align: center;
	line-height: 2;
	background-color: white;
}

.mytable td {
	border-bottom: 1px solid #CCC;
}

.mytable th {
	background-color: #F4F6F8;
}
</style>
<script type="text/javascript">
	var mypath = '${path}';
</script>
<script type="text/javascript">
	var parameters = {
		issen : 2
	};
	$(function() {
		var height = $(window).height() - $("#head").height();
		var width = $(window).width() - $("#treePanel").width() - 40;
		$("#grid").height(height);
		$("#grid").width(width);
	});
</script>
</head>
<body style="padding: 0; margin: 0px; overflow: auto;">
	<div id="content" style="float: left; width: 100%;">
		<table class="mytable">
			<tr>
				<th>收件人</th>
				<th>阅读状态</th>
				<th>阅读时间</th>
			</tr>
			<c:forEach items="${readlist}" var="myread" varStatus="k">
				<tr>
					<td>${myread.RECV_USER_NAME}</td>
					<c:if test="${myread.READ_FLAG==0}">
						<td>未读</td>
					</c:if>
					<c:if test="${myread.READ_FLAG==1}">
						<td>已读</td>
					</c:if>
					<c:if test="${myread.READ_FLAG==0}">
						<td>无</td>
					</c:if>
					<c:if test="${myread.READ_FLAG==1}">
						<td>${myread.MYDATE}</td>
					</c:if>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>