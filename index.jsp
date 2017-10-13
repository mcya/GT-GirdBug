<%@page import="com.open.eac.core.structure.User"%>
<%@page import="com.open.eac.core.app.AppHandle"%>
<%@page import="com.pytech.timesgp.web.helper.CommonUtil"%>
<%@page import="com.pytech.timesgp.web.service.HomeService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="ui" uri="http://www.open.com/eac/core/tag"%>
<%@ include file="/pages/common/common.jsp" %>
<%
	User user = AppHandle.getCurrentUser(request);
	pageContext.setAttribute("htmls", new HomeService().getMenuDesc(user));
	pageContext.setAttribute("taskCount", new HomeService().getTaskCount(user));
	pageContext.setAttribute("taskListInfo", new HomeService().getTaskList(user));
	pageContext.setAttribute("tipsCount", new HomeService().getTipsCount(user));
	pageContext.setAttribute("tipsListInfo", new HomeService().getTipsList(user));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="Mosaddek">
    <meta name="keyword" content="FlatLab, Dashboard, Bootstrap, Admin, Template, Theme, Responsive, Fluid, Retina">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" /> 
    <link rel="shortcut icon" href="${path }/assets/img/favicon.png">

    <title>哈哈哈 GitHub的项目而已，不会留名字啦啦</title>
	<jsp:include page="/pages/common/head.jsp"/>
    <style type="text/css">
	    a.logo {
		    font-size: 21px;
		    color: #000000;
		    float: left;
		    margin-top: 15px;
		    font-weight: 1000;
		    text-transform: uppercase;
		}
    	a.logo span {
		    color: #CC0001;
		    font-weight: 1000;
		    font: bold arial,sans-serif;
		}
		#sidebar::-webkit-scrollbar{
		    width: 9px;
		    height: 16px;
		    background-color: #f5f5f5;
		}
		#sidebar::-webkit-scrollbar-track{
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
		    border-radius: 20px;
		    background-color: #f1f2f7;
		}
		#sidebar::-webkit-scrollbar-thumb{
		    height: 20px;
		    border-radius: 20px;
		    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
		    background-color: #2a3542;
		}
		/* .dropdown-menu.extended {
		    max-width: 600px !important;
		    min-width: 160px !important;
		    top: 42px;
		    width: 450px !important;
		    padding: 0;
		    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.176) !important;
		    border: none !important;
		    border-radius: 4px;
		    -webkit-border-radius: 4px;
		} */
		/* .dropdown-menu.extended li a {
		    padding: 15px 10px !important;
		    max-width: 600px !important;
		    min-width: 160px !important;
		    width: 450px !important;
		    display: inline-block;
		} */
    </style>
    <ui:Include tags="artDialog"></ui:Include>
  </head>

  <body style="overflow: hidden;">

	  <section id="container" class="" style="overflow: hidden;">
	      <!--header start-->
	      <header class="header white-bg">
	          <div class="sidebar-toggle-box">
	              <div data-original-title="切换导航" data-placement="right" class="icon-reorder tooltips"></div>
	          </div>
	          <!--logo start-->
	          <a href="${path }/pages/index.jsp" class="logo" >Times<span>Group</span></a>
	          <!--logo end-->
	          <div class="nav notify-row" id="top_menu">
	            <!--  notification start -->
	            <ul class="nav top-menu">
	              <!-- settings start -->
	              <%-- <li class="dropdown">
	                  <a data-toggle="dropdown" class="dropdown-toggle" href="#">
	                      <i class="icon-tasks"></i>
	                      <span class="badge bg-success">${tipsCount}</span>
	                  </a>
	                  <ul class="dropdown-menu extended tasks-bar">
	                      <div class="notify-arrow notify-arrow-green"></div>
	                      <li>
	                          <p class="green">你有${tipsCount}个待执行的任务</p>
	                      </li>
	                      <li class="external">
	                        ${tipsListInfo} 
	                      </li>
	                  </ul>
	              </li> --%>
	              <!-- settings end -->
	              <!-- inbox dropdown start-->
	              <!-- <li id="header_inbox_bar" class="dropdown">
	                  <a data-toggle="dropdown" class="dropdown-toggle" href="#">
	                      <i class="icon-envelope-alt"></i>
	                      <span class="badge bg-important">0</span>
	                  </a>
	                  <ul class="dropdown-menu extended inbox">
	                      <div class="notify-arrow notify-arrow-red"></div>
	                      <li>
	                          <p class="red">你有0条新消息</p>
	                      </li>
	                      <li>
	                          <a href="#">显示所有消息</a>
	                      </li>
	                  </ul>
	              </li> -->
	              <!-- inbox dropdown end -->
	              <!-- notification dropdown start-->
	              <li id="header_notification_bar" class="dropdown">
	                  <a data-toggle="dropdown" class="dropdown-toggle" href="#">
	
	                      <i class="icon-bell-alt"></i>
	                      <span class="badge bg-warning">${taskCount}</span>
	                  </a>
	                  <ul class="dropdown-menu extended notification" style="max-width: 600px !important; min-width: 160px !important; top: 42px; width: 450px !important; padding: 0; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.176) !important;border: none !important; border-radius: 4px; -webkit-border-radius: 4px;">
	                      <div class="notify-arrow notify-arrow-yellow"></div>
	                      <li>
	                          <p class="yellow">你有${taskCount}个提醒</p>
	                      </li>
	                      <li class="external">
	                          ${taskListInfo}
	                      </li>
	                  </ul>
	              </li>
	              <!-- notification dropdown end -->
	          </ul>
	          </div>
	          <div class="top-nav ">
	              <ul class="nav pull-right top-menu">
	                  <li>
	                      <!-- <input type="text" class="form-control search" placeholder="搜索"> -->
	                  </li>
	                  <!-- user login dropdown start-->
	                  <li class="dropdown">
	                      <a data-toggle="dropdown" class="dropdown-toggle" href="#">
	                          <img alt="" src="${path }/assets/img/avatar1_small.jpg">
	                          <span class="username">
                         		<%
									String userName = CommonUtil.toEmpty(AppHandle.getCurrentUser(request).getUserName());
									byte[] userNmBt = userName.getBytes();
									String userNm = new String(userNmBt, "UTF-8");
									out.print(userNm);
								%>
	                          </span>
	                          <b class="caret"></b>
	                      </a>
	                      <ul class="dropdown-menu extended logout" style="width: 100px !important;">
	                          <div style="background-color:#A9D96C" class="log-arrow-up"></div>
	                          <li style="width:100%;background-color:#A9D96C"><a href="#" onclick="modifyPwd()"><i class=" icon-cog"></i><font color="white"> 修改密码</font></a></li>
	                          <!-- <li><a href="#"><i class="icon-cog"></i> 设置</a></li> -->
	                          <!-- <li><a href="#"><i class="icon-bell-alt"></i> 通知</a></li> -->
	                          <!-- <li style="width:100%;background-color:#A9D96C"><a href="/eac-appcenter?logout=true"><i class="icon-key"></i><font color="white"> 注销登录</font></a></li> -->
	                      </ul>
	                  </li>
	                  <!-- user login dropdown end -->
	              </ul>
	          </div>
	      </header>
	      <!--header end-->
	      <!--sidebar start-->
	      <aside>
	          <div id="sidebar" style="overflow-y:scroll;" class="nav-collapse ">
	              <!-- sidebar menu start-->
	              <ul class="sidebar-menu" id="nav-accordion">
	              	${htmls }
	              </ul>
	              <!-- sidebar menu end-->
	          </div>
	      </aside>
	      <!--sidebar end-->
	      <!--main content start-->
	      <section id="main-content" style="overflow: hidden;">
	          <iframe id="framePage" style="border:0px solid red;background:white;overflow:auto;margin-top:62px;margin-left:2px;" name="framePage" frameborder="0" scrolling="no" src="${path }/static/404.jsp" width="100%"></iframe>
	      </section>
    </section>
	<jsp:include page="/pages/common/foot.jsp"/>
	<script type="text/javascript">
		$(function(){
			$("#framePage").height($(window).height()-$('header').height());
			//$("#framePage").width($(window).width()-214);
			$(window).resize(function(){
				$("#framePage").height($(window).height()-$('header').height());
				//$("#framePage").width($(window).width()-214);
			});
			if(!$('ul.sub li.active a').attr("url"))
				document.getElementById('framePage').src='/times-web/pages/portal_content.jsp';
			else
				document.getElementById('framePage').src=$('ul.sub li.active a').attr("url");
		});
		function modifyPwd() {
			dialogUtil.open("modifyPwd","修改密码","modifyPwd.jsp",350,300,function(){});
		}
	   	function toPage(obj){
		   $(".nav-list li").removeClass("active");
		   $(obj).parents("li").siblings().removeClass("active");
		   $(obj).parents("li").addClass("active");
		   document.getElementById('framePage').src=$(obj).attr("url");
		   return false;
	   	}
	   	function toBindPage(tipId) {
	   		var heit = $(window).height()-$('header').height();
	   		dialogUtil.open("dealInfo","绑定成交信息","bindDealInfo.jsp?tipId=" + tipId,heit,1000,function(){
	   			var iframe = this.iframe.contentWindow;
	   			iframe.isCloseTip();
	   			return true;
	   		});
	   	}
	</script>
  </body>
</html>
