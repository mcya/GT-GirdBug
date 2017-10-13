<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <li>
     <a href="javascript:void(0);" caption="首页" url="pages/module1/table.jsp" onclick="toPage(this);" target="framePage">
         <i class="icon-dashboard"></i>
         <span>首页</span>
     </a>
 </li>

 <li class="sub-menu">
     <a href="javascript:;">
         <i class="icon-cogs"></i>
         <span>系统管理</span>
     </a>
     <ul class="sub">
     	<li><a href="javascript:void(0);" caption="参考页面" url="${path }/pages/module1/activity_list.jsp" onclick="toPage(this);" target="framePage">参考页面</a></li>
         <li><a href="javascript:void(0);" caption="组织架构管理" url="/eac-base/pages/organ.jsp" onclick="toPage(this);" target="framePage">组织架构管理</a></li>
         <li><a href="javascript:void(0);" caption="用户管理" url="/eac-base/pages/structure.jsp" onclick="toPage(this);" target="framePage">用户管理</a></li>
         <li><a href="javascript:void(0);" caption="工作组管理" url="/eac-base/pages/WorkGroup.jsp" onclick="toPage(this);" target="framePage">工作组管理</a></li>
         <li><a href="javascript:void(0);" caption="角色管理" url="/eac-base/pages/roleConfig.jsp" onclick="toPage(this);" target="framePage">角色管理</a></li>
         <li><a href="javascript:void(0);" caption="系统公告" url="system/notice/NoticeSen.jsp" onclick="toPage(this);" target="framePage">系统公告</a></li>
         <li><a href="javascript:void(0);" caption="规则配置" url="pages/module1/page3.jsp" onclick="toPage(this);" target="framePage">规则配置</a></li>
         <li><a href="javascript:void(0);" caption="字典管理" url="/eac-base/pages/Dictionary.jsp" onclick="toPage(this);" target="framePage">字典管理</a></li>
     </ul>
 </li>

 <li class="sub-menu">
     <a href="javascript:;">
         <i class="icon-group"></i>
         <span>客户管理</span>
     </a>
     <ul class="sub">
         <li><a href="javascript:void(0);" caption="客户信息查询" url="${path }/pages/client/infoQuery.jsp" onclick="toPage(this);" target="framePage">客户信息查询</a></li>
         <li><a href="javascript:void(0);" caption="公客管理" url="${path }/pages/client/publicMgr.jsp" onclick="toPage(this);" target="framePage">公客管理</a></li>
         <li><a href="javascript:void(0);" caption="销售关系管理" url="${path }/pages/client/saleRelation.jsp" onclick="toPage(this);" target="framePage">销售关系管理</a></li>
         <li><a href="javascript:void(0);" caption="客户跟进管理" url="${path }/pages/client/followMgr.jsp" onclick="toPage(this);" target="framePage">客户跟进管理</a></li>
         <li><a href="javascript:void(0);" caption="贵客管理" url="${path }/pages/client/bigCliMgr.jsp" onclick="toPage(this);" target="framePage">贵客管理</a></li>
     </ul>
 </li>
 <li class="sub-menu">
     <a href="javascript:;">
         <i class="icon-user"></i>
         <span>Call客管理</span>
     </a>
     <ul class="sub">
         <li><a href="javascript:void(0);" caption="Call客导入" url="${path }/pages/call/import.jsp" onclick="toPage(this);" target="framePage">Call客导入</a></li>
         <li><a href="javascript:void(0);" caption="Call客分配" url="${path }/pages/call/allocate.jsp" onclick="toPage(this);" target="framePage">Call客分配</a></li>
         <li><a href="javascript:void(0);" caption="Call客查询" url="${path }/pages/call/query.jsp" onclick="toPage(this);" target="framePage">Call客查询</a></li>
     </ul>
 </li>
 <li class="sub-menu">
     <a href="javascript:;">
         <i class="icon-flag-checkered"></i>
         <span>目标管理</span>
     </a>
     <ul class="sub">
         <li><a href="javascript:void(0);" caption="目标任务查询" url="${path }/pages/purpose/taskQuery.jsp" onclick="toPage(this);" target="framePage">目标任务查询</a></li>
         <li><a href="javascript:void(0);" caption="目标任务分配" url="${path }/pages/purpose/taskAllocate.jsp" onclick="toPage(this);" target="framePage">目标任务分配</a></li>
     </ul>
 </li>
 <li class="sub-menu">
      <a href="javascript:;">
          <i class="icon-book"></i>
          <span>销售宝典</span>
      </a>
      <ul class="sub">
          <li><a href="javascript:void(0);" caption="栏目管理" url="${path }/pages/sale/programMgr.jsp" onclick="toPage(this);" target="framePage">栏目管理</a></li>
          <li><a href="javascript:void(0);" caption="消息管理" url="${path }/pages/sale/msgMgr.jsp" onclick="toPage(this);" target="framePage">消息管理</a></li>
          <li><a href="javascript:void(0);" caption="消息发布" url="${path }/pages/sale/msgPublish.jsp" onclick="toPage(this);" target="framePage">消息发布</a></li>
      </ul>
  </li>
  <li class="sub-menu">
      <a href="javascript:;" >
          <i class="icon-bar-chart"></i>
          <span>数据分析</span>
      </a>
      <ul class="sub">
          <li><a href="javascript:void(0);" caption="销售统计" url="${path }/pages/analysis/saleAnalysis.jsp" onclick="toPage(this);" target="framePage">销售统计</a></li>
          <li><a href="javascript:void(0);" caption="Call客统计" url="${path }/pages/analysis/saleAnalysis.jsp" onclick="toPage(this);" target="framePage">Call客统计</a></li>
          <li><a href="javascript:void(0);" caption="客户统计" url="${path }/pages/analysis/clientAnalysis.jsp" onclick="toPage(this);" target="framePage">客户统计</a></li>
      </ul>
  </li> 