function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('grid', params);
}

/*var columns = [{
	id : "ORG_ID",
	header : "项目编码",
	headAlign : 'center',
	align : 'center',
	isCheckColumn : false,
	exportable : false
}, {
	id : "ORG_NAME",
	header : "项目名称",
	width :250,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "A_DAYS",
	header : "A客保护期天数",
	width :100,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "B_DAYS",
	header : "B客保护期天数",
	width :100,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "C_DAYS",
	header : "C客保护期天数",
	width :100,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "PROJECT_DAYS",
	header : "客户保护期天数",
	width :200,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true,
	editor: { type:"text",validRule:['R','I'] },
},{
	id : "CREATE_ORG_NAME",
	header : "创建人",
	align : 'center',
	width :150
}, {
	id : "CREATE_TIME",
	header : "创建时间",
	align : 'center',
	width :150
}];*/

function addOp(){
	dialogUtil.open("protect","添加项目保护期",path+"/pages/protect/protect_update.jsp?oper=add",300,300,function(){
	});

}
function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

function editOp(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行修改！',true);
		return false;
	}
	dialogUtil.open("protect","修改项目保护期",path+"/pages/protect/protect_update.jsp?oper=edit&PK_ID="+records[0].PK_ID,300,300,function(){
	});
	//window.location.href="protect_update.jsp?oper=edit&PK_ID="+records[0].PK_ID;
}

function deleteOp(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var projProtectids = new Array();
		for(var i = 0;i<records.length;i++){
			projProtectids.push("'"+records[i].PK_ID+"'");
		}
		doDeleteAct(projProtectids.join(","));
	},function(){});
	
}
function doDeleteAct(ids){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.ProjectProtectDao:deleteProjectProtect",[ids],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}
