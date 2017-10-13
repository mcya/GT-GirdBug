# GT-Grid入坑经验 #


### (1) UI控件的引入
```
<ui:Include tags="artDialog,Select,FileUpload,zTree"></ui:Include>

<ui:FileUpload width="196px" onUploadSuccess="finish"  path="${savePath}" id="myFile" fileTypeExts="*.jpg" fileSizeLimit="10240"></ui:FileUpload>

```
*******************************
### (2) Button按钮的标，btnType属性控制
```

<ui:Button btnType="query" onClick="query()">查询</ui:Button>
<ui:Button btnType="add" onClick="javascript:addChannel()">新增</ui:Button>
<ui:Button btnType="edit" onClick="javascript:updateChannel();">修改</ui:Button>
<ui:Button btnType="delete" onClick="javascript:deleteChannel()">删除</ui:Button>
<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>

```

********************************
### (3) artDialog弹出层（open+alert+confirm+取消/关闭）
```
// 1.引入
<ui:Include tags="artDialog"></ui:Include>


// 2.1 在函数中使用-- dialogUtil.open 弹出一个jsp页面
function(){
    dialogUtil.open(
		"shangchuan", //窗口的名字，用于取消或者关闭该窗口
		"项目介绍图片上传", //弹出层的标题
		"/times-web/pages/params/shangchuan.jsp?isZuzhi=0&projid="+records[0].PROJID, //路径
		150,400, //宽高
		function(){ //执行的函数，函数内容可为空
            reloadGrid('grid');
        }
    );
}


// 2.2 在函数中使用-- dialogUtil.alert 弹出一个提示信息框(仅提示)
function(){
    var records = getSelectedRecords('grid'); //获取选中的数据
    if(records.length!=1){
        dialogUtil.alert('只能选择一条记录进行设置！',true);
        return false;
    }
}

// 2.3 在函数中使用-- dialogUtil.confirm 弹出一个询问提示框(确定+取消)
dialogUtil.confirm(
	'确认要删除选择的记录吗？',
	function(){
		// 确认函数
	},
	function(){
		// 取消
	}
);


// 3.点击取消关闭弹窗
<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>

<script>
// shangchuan 为open的时候所定义的
function closeDialog(){
	parent.art.dialog.get("shangchuan").close();
}
</script>
```

********************************
### (4) ajax请求

```
function() {
    var saveParams = {
		IMG_NAME: postData.IMG_NAME,
		type: 'proj',
		projid: treeSeleted[1]
	}
	var serviceUrl = "${path}/com.pytech.timesgp.web.dao.AttachDao:uploadProjAttach"
	ajax.remoteCall(
	    serviceUrl, //api
	    [saveParams], //参数
	    function(reply){ //成功执行的函数
		    var data = reply.getResult(); //返回值
		    dialogUtil.alert(data.msg, function() {
    			if (data.success == true) {
    				closeDialog();
    			}
    		});
	    }
	);
}
```

*****************************
### (5) table表格（一）--纯JS渲染
```
// 1.HTML结构
<div id="grid"></div>

// 2.JS
// 2.1 表格列表参数
var columns = [{
	id: 'R_R', //id 即是接收api请求到的数据的参数名
	header: 'id', //列表名
	width: 50, //列表宽
	align : 'center', //文字位置
	isCheckColumn: true //是否作为勾选框，默认为false
}, {
	id : "USERNAME",
	header: "收件人",
	width:200,
	align : 'center',
	type :'string',
	toolTip:true,
	renderer:shoujianren, //编辑表格内容，shoujianren是个函数名，函数也可以直接在这里写
}, {
	id : "EMAIL",
	header : "邮箱",
	width :300,
	editor: { type:"text",validRule:['R','email'] }, //直接编辑表格,email是数据类型
	align : 'center',
	type :'string',
	toolTip:true
}];



// 2.2 渲染函数配置
loadGrid(
    'grid', //div的id
	path+'/com.pytech.timesgp.web.query.EmailQuery', //查询api
	columns, //定义的列表参数
	parameters, //查询的参数
	{
		singleSelect: true, //是否可多选
		autoLoad:true, //加载
		toolbarContent:false, //是否显示分页
		afterEdit: function(value, oldValue, record, col, grid) {
			// 直接编辑表格的函数(注：编辑完成后触发)
			var paramsData = {
				projid: record.ORG_ID,
				userids: record.USERID,
				emails: record.EMAIL
			}
			// 编辑完成后触发的api
			ajax.remoteCall(
			    path+"/com.pytech.timesgp.web.dao.AttendanceDao:updateEmail",
				[paramsData],
				function(reply){
					reloadGrid('grid');
					var data = reply.getResult();
					dialogUtil.alert(data.msg,function(){
				});
			}); 
		}
	}
);

```

**********************************
### (5) table表格（一）--纯HTML渲染
```
<div id="box">
    <ui:Grid
        id="grid"
        dataProvider="${path}/com.pytech.timesgp.web.query.ParameterMenuQuery"
        parameters="{issen:1,TYPE:'org'}"
        singleSelect="true"
        style=""
    >
    <%-- 
        <ui:Grid>:
            id //id
            dataProvider //路径
            parameters //参数
            ...
            等等参数，和纯js渲染数据一样
    --%>
        <ui:GridField id="GROUPID" width="50"  header="id" checkColumn="true" align="center"></ui:GridField>
        <ui:GridField id="GROUPNAME" width="450" header="参数名称" toolTip="true" align="center"/>
        <ui:GridField id="GROUPBELONG" width="450" header="参数范围" toolTip="true" align="center"/>
        <%-- 
        <ui:GridField />:
            id //即是接收api请求到的数据的参数名
            width //宽度
            ...
            等等参数，和纯js渲染数据一样
         --%>
    </ui:Grid>

</div>
```