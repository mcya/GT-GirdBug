<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.pytech.timesgp.web.dao.LocationDao"%>
<%@page import="com.pytech.timesgp.web.vo.ProjOnlineVo"%>

<%@page import="com.open.eac.core.app.AppHandle"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>

<c:set var="path" value="<%=request.getContextPath() %>"></c:set>
<c:set var="user" value="<%=AppHandle.getCurrentUser(request) %>"></c:set>

<%
	String projId = request.getParameter("projId");
	LocationDao locationDao = new LocationDao();
	ProjOnlineVo onlineInfo = locationDao.getProjOnlineInfo(projId);
	
	pageContext.setAttribute("onlineInfo", onlineInfo);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
<style type="text/css">
.treetable-show{
position:absolute;
background: url("/times-web/images/xtb.jpg") no-repeat scroll -150px -155px;
width:18px;
height:20px;
}
.treetable-hide{
position:absolute;
background: url("/times-web/images/xtb.jpg") no-repeat scroll -182px -155px;
width:18px;
height:20px;
}
</style>
<title>structure</title>
<ui:Include tags="artDialog,Select"></ui:Include>
<script type="text/javascript">
	$(function(){
		//$('.sub1,.sub2').toggle();
		$('#proj').bind('click',function() {
			if($(this).children("div").first().hasClass("treetable-show")){
				$(this).children("div").first().removeClass("treetable-show");
				$(this).children("div").first().addClass("treetable-hide");
			}else{
				$(this).children("div").first().removeClass("treetable-hide");
				$(this).children("div").first().addClass("treetable-show");
			}
			$('.sub1').toggle();
			
			if($('.sub1').is(':hidden')){
				$('.sub2').hide();
			}
			$('.sub1').each(function(i){
				if($(this).is(':hidden')){
					$(this).find("div").first().removeClass("treetable-show");
					$(this).find("div").first().addClass("treetable-hide");
				}else{
					$(this).find("div").first().removeClass("treetable-hide");
					$(this).find("div").first().addClass("treetable-show");
				}
			})
		})
		
		$('.sub1').each(function(i){
			$(this).bind('click',function(){
				$('[index='+i+']').toggle();
				if($(this).find("div").first().hasClass("treetable-show")){
					$(this).find("div").first().removeClass("treetable-show");
					$(this).find("div").first().addClass("treetable-hide");
				}else{
					$(this).find("div").first().removeClass("treetable-hide");
					$(this).find("div").first().addClass("treetable-show");
				}
			})
			
		})
		
		})
		</script>
</head>
<body >
	
		
		<table>
			<tr>
				<td id="proj">	
					<div class="treetable-hide" ></div><div style="padding-left: 20px">项目：<c:out value="${onlineInfo.projName}"></c:out> </div>
				</td>
				<td></td>
         		<td style="padding-left: 50px"><a href="projLocationInfo.jsp?projId=${onlineInfo.projId }&projName=${onlineInfo.projName}">详情</a></td>
			</tr>	
			<c:forEach var="group" items="${onlineInfo.groupList}" varStatus="stat1" >
			<tr class="sub1" >
				<td style="padding-left: 30px"><div class="treetable-hide" ></div><div style="padding-left: 20px"><c:out value="${group.groupName }"></c:out><div></div></td>
				<td></td>
				<td style="padding-left: 50px"><a href="groupLocatoinInfo.jsp?groupId=${group.groupId }">详情</a></td>
			</tr>
			<c:forEach var="sale" items="${group.saleList}" varStatus="stat2" >
			<tr class="sub2" index="${stat1.index }">
				<td style="padding-left: 60px"><c:out value="${sale.userName }"></c:out></td>
				<td style="padding-left: 20px">
					<c:choose>
						<c:when test="${sale.status == 1}"><font color="red">在线</font></c:when>
						
						<c:otherwise>不在线</c:otherwise>
					</c:choose>
				</td>
				<td style="padding-left: 50px"><a href="traceInfo.jsp?userCode=${sale.userCode }">详情</a></td>
			</tr>
			</c:forEach>
			</c:forEach>
		</table>

</body>
</html>