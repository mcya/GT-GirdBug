<%@ page import="com.pytech.timesgp.web.dao.SptDao" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String projid= request.getParameter("projid");
    //楼栋下拉框,直接用servlet写法搞定
    SptDao spdao=new SptDao();
    File file=spdao.copySptToWebInf(projid,request);
    //response.reset();
    //response.setCharacterEncoding("UTF-8");
    //response.setContentType("application/vnd.ms-excel");
    //response.setHeader("Content-Disposition", "attachment; filename=\""+ fileName + "\"");

    ServletOutputStream sos = response.getOutputStream();
    BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
    byte[] content = new byte[1024];
    int length;
    while ((length = fin.read(content, 0, content.length)) != -1) {
        sos.write(content, 0, length);
    }
    fin.close();
    sos.close();
//    sos.flush();

//    response.reset();
%>
