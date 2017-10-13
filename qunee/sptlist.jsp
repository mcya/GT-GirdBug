<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pytech.timesgp.web.dao.SptDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    String projid=request.getParameter("projid");
    SptDao spdao=new SptDao();
    String sptXy=spdao.getSptXy(projid);
//    List<Map<String,Object>> file=spdao.copySptToWebInf(projid,request);
//    String imgPath = basePath +"upload/"+file.get(0).get("ATTACH_NAME").toString();
    System.out.println(sptXy);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10,EmulateIE9" />
    <title>沙盘图设置</title>
    <script type="text/javascript" src="/eac-core/res/jquery/jquery.js"></script>
    <script type="text/javascript" src="<%=basePath%>pages/js/layer/layer.js"></script>
    <script type="text/javascript" src="<%=basePath%>assets/js/bootstrap.min.js?v=1.3"></script>
    <script src="<%=basePath%>pages/qunee/js/qunee-min.js"></script>
    <script src="<%=basePath%>pages/qunee/js/common.js"></script>
    <script type="text/javascript" src="<%=basePath%>pages/js/easyui/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>pages/js/easyui/themes/gray/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>pages/js/easyui/themes/icon.css">
    <link rel="stylesheet" href="<%=basePath%>assets/css/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>pages/js/layer/skin/layer.css">
    <script>
        //楼栋json字符串
        var bldjson='<%=sptXy%>';
        //加载图片
        function loadbackgroundIMg(background){
            background.image = '<%=basePath%>pages/qunee/linkSpt.jsp?projid=<%=projid%>';
        }
        //创建节点
        function createNode(x, y,bldname,bldid) {
            var node = graph.createNode(bldname, x, y);
//            node.image = Q.Shapes.getShape(Q.Consts.SHAPE_CIRCLE, -20, -20, 40, 40);
//            node.putStyles({
//                'shadow.color': '#0FF',
//                'shadow.blur': 5,
//            })
            node.image = "images/home_menu1.png";
            //node.size = {width: 27,hight: 27};
            node.set("bldid",bldid);
            //node.setStyle(Q.Styles.SHAPE_FILL_COLOR, Q.randomColor());
            nodes.push(node);
            return node;
        }
        //加载数据
        function initDatas(){
            //转成json对象
            var bldinfos=JSON.parse(bldjson);
            if(bldinfos != null && bldinfos != undefined && bldinfos != '' && bldinfos != 'null'){
            //楼栋数组
            var blds=bldinfos.data;
            console.log(blds);
                for(var i=0;i<blds.length;i++){
                    //console.log(blds[i]);
                   createNode(Number(blds[i].bldx), Number(blds[i].bldy),blds[i].bldname,blds[i].bldid);
                }
            }
            $($(".Q-Canvas")[1]).hide();
        }
    </script>
    <style>
        #graph_panel {
            height: 100%;
        }
        .tabs-panels .panel-body{
            border-left: solid 1px #DDD;
            border-right: solid 1px #DDD;
        }
        .tree-node {
            height: 20px;
        }
        .q-panel {
            padding-top: 40px;
            position: relative;
        }
        .q-toolbar {
            padding: 5px;
        }
        .q-panel .q-toolbar {
            position: absolute;
            top: 0px;
            height: 40px;
            width: 100%;
            z-index: 1;
        }
        .q-panel .q-content {
            height: 100%;
            background-color: #FFF;
            overflow: hidden;
            border-bottom-left-radius: 4px;
            border-bottom-right-radius: 4px;
            position: relative;
        }
        .q-canvas {
            height: 100%;
        }
        #canvas_panel {
            position: relative;
            overflow: hidden;
        }
        #canvas {
            width: 100%;
            background-color: #FFF;
            outline: none;
            overflow: hidden;
        }
        #toolbar {
            background-color: #F8F8F8;
            border-bottom: solid 1px #DDD;
            padding: 5px;
        }
        #toolbar .btn, #toolbar .btn-group {
            margin-right: 5px;
        }
        #toolbar .btn-group .btn {
            margin-right: 0px;
        }
        #toolbox {
            position: absolute;
            top: 0px;
            background-color: #F8F8F8;
            padding: 5px;
        }
        #toolbox > img, #toolbox > button {
            display: block;
            padding: 8px 7px 0 7px;
            border-radius: 0px;
        }
        .layout-split-west {
            border-right: 5px solid rgba(255, 255, 255, 0);
        }
        #center_panel {
            border: none;
        }
        .panel {
            -webkit-box-shadow: none;
            box-shadow: none;
        }
        #footer {
            text-align: center;
            padding: 8px;
            border-top: solid 1px #DDD;
            background-color: #EEE;
        }
        .node_icon{
            background: url('images/node_icon.png') no-repeat;
            background-size: 18px;
            background-position:center;
        }
        .edge_icon{
            background: url('images/edge_icon.png') no-repeat;
            background-size: 18px;
            background-position:center;
        }
    </style>
    <script src="<%=basePath%>pages/qunee/js/framework.js?v=1.4"></script>

</head>
<body class="easyui-layout">
<!--<div data-options="region:'east',split:true,collapsed:true,title:'East'" style="width:100px;padding:10px;">east region</div>-->
<div id="center_panel" data-options="region:'center'" style="padding-right: 10px;">
    <div class="easyui-tabs" data-options="fit:true,border:false,plain:true">
        <div title="楼栋坐标" id="graph_panel" class="q-panel">
            <div id="toolbar" class="q-toolbar"></div>
            <div id="canvas_panel" class="q-content">
                <div id="canvas" class="q-canvas"></div>
                <div id="toolbox"></div>
                <input type="hidden" id="bldname"/>
                <input type="hidden" id="bldid"/>
                <input type="hidden" id="projid" value="<%=projid%>"/>
            </div>
        </div>
    </div>
</div>
</body>
</html>