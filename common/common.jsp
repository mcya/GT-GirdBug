<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%request.setAttribute("path", request.getContextPath());%>
<c:set var="path" value="${path}" />
<%request.setAttribute("vesionTime", new Date().getTime());%>
<c:set var="version" value="${vesionTime}" />
