var sex = {
	'0' : '女',
	'1' : '男'
};
//性别
function sexRender(value, record, columnObj, grid, colNo, rowNo) {
	return sex[value];
}

//默认选中  isCheckColumn : true,
function checkRender(value, record, columnObj, grid, colNo, rowNo){
	gridglobal = grid;
	var contain = false;
	var arr = saler.split(',');
	for(i = 0; i < arr.length; i++){
		contain = record.USER_NAME == arr[i] ? true:false ;
		if(contain){
			break;
		}
	}
	if(contain){
		rowNum.push(rowNo);
		return "<input class='gt-f-check' style='margin-left:2px' name='gt_grid1_chk_id' type='checkbox' checked=true ></input>";
	}else{
		return "<input class='gt-f-check' style='margin-left:2px' name='gt_grid1_chk_id' type='checkbox'></input>";
	}
}

//‘选中’操作，关联销售人员到销售组
function relateGroup() {
	var records = getSelectedRecords('grid');
	if(records.length==0){
		dialogUtil.alert('请至少选择一条记录！',true);
		return false;
	}
	if(flg==1&&records.length>1) {
		dialogUtil.alert('请选择一条记录！',true);
		return false;
	}
	var ids = new Array();
	for(var i = 0;i<records.length;i++){
		ids.push("'"+records[i].USER_CODE+"'");
	}
	var idstr = ids.join(",");
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.UserMgrDao:relateGroup",[idstr,groupId,flg],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			artDialog.opener.reloadGrid('grid');
			parent.art.dialog.get("group").close();
		});
	});
}

/*var columns = [
{id : "USER_MOBILE",align : 'center', exportable : false,width:0, renderer:checkRender }, 
{id : "USER_NAME",header : "姓名",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "USER_SEX",header : "性别",width :80,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:sexRender},
{id : "USER_MOBILE",header:"电话",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true}
];*/

var columns = [
{id : "选择",align : 'center',width:0,exportable : false,renderer:checkRender}, 
{id : "USER_NAME",header : "姓名",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "USER_SEX",header : "性别",width :80,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:sexRender},
{id : "USER_MOBILE",header:"电话",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "USER_CODE",header : "账号",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true}
];


function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

/**
 * 弹出添加对话框
 */
function add(){
	dialogUtil.open("user","添加人员","userEdit.jsp",350,600,function(){});
}

/**
 * 弹出修改对话框
 */
function update(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行修改！',true);
		return false;
	}
	var id = records[0].USER_MOBILE;
	dialogUtil.open("user","修改人员信息","userEdit.jsp?oper=edit&USER_MOBILE="+id,350,600,function(){
	});
}

/*
 * 查看
 */
function view(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行查看！',true);
		return false;
	}
	var id = records[0].USER_MOBILE;
	dialogUtil.open("user","查看人员信息","userView.jsp?USER_MOBILE="+id,150,600,function(){});
}

/*
 * 调整销售组
 */
function adjust(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行调整！',true);
		return false;
	}
	var id = records[0].USER_MOBILE;
	var name = records[0].USER_NAME;
	dialogUtil.open("user","调整销售组","adjustGroup.jsp?name="+name+"&USER_MOBILE="+id,300,300,function(){},
	function(){
		var iframe = this.iframe.contentWindow;
		iframe.save();
		return false;
	});
}



/*
 * 删除(根据USER_CODE进行删除)
 */
function deleteEntry(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var ids = new Array();
		for(var i = 0;i<records.length;i++){
			ids.push("'"+records[i].USER_MOBILE+"'");
		}
		
		doDelete(ids.join(","));
	},function(){});
	
}
function doDelete(ids){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.UserMgrDao:relateGroup",[ids, groupId, flg],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			artDialog.opener.reloadGrid('grid');
			parent.art.dialog.get("group").close();
		});
	});
}

