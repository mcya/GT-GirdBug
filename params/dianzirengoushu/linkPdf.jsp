<%@ page language="java" import="java.util.*,java.io.*"
pageEncoding="UTF-8"%>
<%
	String filepath = request.getParameter("filepath");
	//String filepath ="E:\\workspace\\times-web\\WebContent\\pages\\params\\dianzirengoushu\\1.pdf";
    //response.reset();
    //response.setCharacterEncoding("UTF-8");
    //response.setContentType("application/vnd.ms-excel");
    if(filepath!=null && !"".equals(filepath)){
    	UUID id=UUID.randomUUID();
        String filename=id+filepath.substring(filepath.lastIndexOf("."),filepath.length());
        response.setHeader("Content-Disposition", "attachment; filename="+filename); 
     	out.clear();
       	out = pageContext.pushBody();
       	response.setContentType("application/pdf");
       	DataOutputStream temps = new DataOutputStream(response.getOutputStream());
        DataInputStream in = new DataInputStream(new FileInputStream(filepath));
        byte[] b = new byte[2048];
        while ((in.read(b)) != -1) {
          temps.write(b);
          temps.flush();
         }

         in.close();
         temps.close();
    }
//    sos.flush();

//    response.reset();
%>
