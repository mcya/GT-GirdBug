<%@ page import="com.pytech.timesgp.web.dao.SptDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    String projid= request.getParameter("projid");
    //楼栋下拉框,直接用servlet写法搞定
    SptDao spdao=new SptDao();
    List<Map<String,Object>> list=spdao.queryBldinfos(projid);
%>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>楼栋属性设置</title>
    <script type="text/javascript" src="/eac-core/res/jquery/jquery.js"></script>
    <script type="text/javascript" src="<%=basePath%>pages/js/layer/layer.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>pages/js/layer/skin/layer.css">
</head>
<style>
    body {
        padding: 10px;
        font-size: 14px;
        background: #fff;
        width: 95%;
        margin: 0 auto;
        font-size: 14px;
        line-height: 20px;
        overflow: hidden;
    }

    p {
        margin-bottom: 10px;
    }

    button, input {
        border: 1px solid #999;
        padding: 5px 10px;
        margin: 0 10px 10px 0;
    }

    button {
        cursor: pointer;
    }
</style>
<body>
    <table>
        <tr>
            <td>选择楼栋:</td>
            <td>
                <select id="bldid">
                    <%
                        if(list.size()==0){//楼栋下拉框,直接用servlet写法搞定 %>
                            <option value="">查询不到楼栋信息!</option>
                    <% }else{
                            for(int i=0;i<list.size();i++){
                                Map<String,Object> map=list.get(i);%>
                                <option value="<%=map.get("BLDID")%>"><%=map.get("BLDNAME")%></option>
                          <%}
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td><button id="transmit">保存</button><button id="cannot">取消</button></td>
        </tr>
    </table>
</div>
</body>
<script type="text/javascript">
    var index = parent.layer.getFrameIndex(window.name);
    $('#transmit').on('click', function(){
        //楼栋id
        var bldid=$("#bldid").val();
        //楼栋名称
        var bldname=$("#bldid").find("option:selected").text();
        //console.log(bldname+"|"+bldid);
        //设置父页面表单的值
        parent.$('#bldname').val(bldname);
        parent.$('#bldid').val(bldid);
        parent.layer.close(index);
    });
    $('#cannot').on('click', function(){
        parent.layer.close(index);
    });
</script>
</html>

