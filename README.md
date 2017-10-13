# GT-Grid入坑经验 #


### （1）UI控件的引入
```
<ui:Include tags="artDialog,Select,FileUpload,zTree"></ui:Include>

<ui:FileUpload width="196px" onUploadSuccess="finish"  path="${savePath}" id="myFile" fileTypeExts="*.jpg" fileSizeLimit="10240"></ui:FileUpload>

```
*******************************
### （2）Button按钮的标，btnType属性控制
```

<ui:Button btnType="query" onClick="query()">查询</ui:Button>
<ui:Button btnType="add" onClick="javascript:addChannel()">新增</ui:Button>
<ui:Button btnType="edit" onClick="javascript:updateChannel();">修改</ui:Button>
<ui:Button btnType="delete" onClick="javascript:deleteChannel()">删除</ui:Button>
<ui:Button btnType="save" onClick="saveOrUpdate();">保存</ui:Button>
<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>

```

********************************
### （3）artDialog弹出层（open+alert+取消/关闭）
```
// 1.引入
<ui:Include tags="artDialog"></ui:Include>


// 2.1 在函数中使用--dialogUtil.open弹出一个jsp页面
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


// 2.2 在函数中使用--dialogUtil.alert弹出一个提示框
function(){
    var records = getSelectedRecords('grid'); //获取选中的数据
    if(records.length!=1){
        dialogUtil.alert('只能选择一条记录进行设置！',true);
        return false;
    }
}


// 3.点击取消关闭弹窗
<ui:Button btnType="cancel" onClick="closeDialog();">取消</ui:Button>

<script>
// shangchuan 为open的时候所定义的
function closeDialog(){
	parent.art.dialog.get("shangchuan").close();
}
</script>
```