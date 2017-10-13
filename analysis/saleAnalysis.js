

// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	var nodes = zTree.getSelectedNodes();
	params.orgId = nodes[0].id;
	params.YEAR =  $('#YEAR').val();
	params.MONTH = $('#MONTH').val();
	
	reloadGrid('grid', params);
}

var columns = [{
	id : "WEEK_DESC",
	header : "时段描述",
	width :80,
	headAlign:'left',
	align : 'center',
	grouped : true,
	sortable:false,
	renderer:colorRender,frozen : true
},{
	id : "START_DT",
	header : "开始时间",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,frozen : true
},  {
	id : "END_DT",
	header : "结束时间",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,frozen : true
}, {
	id : "EXPAND_CNT",
	header : "拓展数",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,
	editor: { type:"text",validRule:['R','I']  },
	renderer:expandRender,
	beforeEdit:expandEdit
}, {
	id : "EXPAND_SHEET_CNT",
	header : "拓展数-派单",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,
	editor: { type:"text",validRule:['R','I']  },
	renderer:expandSheetRender,
	beforeEdit:expandSheetEdit
}, {
	id : "EXPAND_ABDUCTION_CNT",
	header : "拓展数-外展",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,
	editor: {  type:"text",validRule:['R','I']  },
	renderer:expandAbductionRender,
	beforeEdit:expandAbductionEdit
}, {
	id : "EXPAND_OUTSOURCE_CNT",
	header : "拓展数-外部资源",
	width :120,
	headAlign:'left',
	align : 'center',
	sortable:false,
	editor: { type:"text",validRule:['R','I'] },
	renderer:expandOutsourceRender,
	beforeEdit:expandOutsourceEdit
},{
	id : "EXPAND_BIGCLI_CNT",
	header : "拓展数-大客户",
	align : 'center',
	width :100,
	sortable:false,
	editor: { type:"text",validRule:['R','I'] },
	renderer:expandBigcliRender,
	beforeEdit:expandBigcliEdit
}, {
	id : "EXPAND_INTRO_CNT",
	header : "拓展数-业主活动",
	align : 'center',
	width :120,
	sortable:false,
	editor: { type:"text",validRule:['R','I'] },
	renderer:expandIntroRender,
	beforeEdit:expandIntroEdit
}, {
	id : "VISIT_CNT",
	header : "来访数",
	align : 'center',
	width :100,
	sortable:false,
	editor: { type:"text",validRule:['R','I'] },
	renderer:visitCntRender,
	beforeEdit:visitCntEdit
}, {
	id : "DEAL_MONEY",
	header : "成交金额(万)",
	align : 'center',
	width :100,
	sortable:false,
	editor: { type:"text",validRule:['R','I'] },
	renderer:dealMoneyRender,
	beforeEdit:dealMoneyEdit
}, {
	id : "DEAL_CNT",
	header : "成交套数",
	align : 'center',
	width :100,
	sortable:false,
	editor: { type:"text",validRule:['R','I'] },
	renderer:dealCntRender,
	beforeEdit:dealCntEdit
}];
//到访次数（统计范围）：0次,1-3次,4-6次,6次以上
function expandEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function expandAbductionEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function expandOutsourceEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function expandBigcliEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function expandIntroEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function expandSheetEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function visitCntEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function dealMoneyEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}
function dealCntEdit(value,  record,  col,  grid) {
	if(record.WEEK_DESC=='月总计' || record.WEEK_DESC=='月目标')
		return false;
	return true;
}

function colorRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="grey">'+val+'</font>';
}
function expandRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function expandSheetRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_SHEET_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function expandAbductionRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_ABDUCTION_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function expandOutsourceRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_OUTSOURCE_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function expandBigcliRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_BIGCLI_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function expandIntroRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_INTRO_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function visitCntRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].VISIT_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function dealMoneyRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].DEAL_MONEY;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}
function dealCntRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].DEAL_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return val;
}


function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

function addOp(){
	window.location.href="activity_update.jsp?oper=add";
}

function viewCourse(courseId){
	window.open("../../../public/courseView.jsp?oper=view&COURSE_ID="+courseId);
}

function editOp(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行修改！',true);
		return false;
	}
	window.location.href="activity_update.jsp?oper=edit&ACTIVITY_ID="+records[0].ACT_ID;
}

function deleteOp(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var userids = new Array();
		for(var i = 0;i<records.length;i++){
			userids.push("'"+records[i].ACT_ID+"'");
		}
		doDeleteAct(userids.join(","));
	},function(){});
	
}
function doDeleteAct(acts){
	ajax.remoteCall(path+"/com.pytech.wego.web.dao.ActivityDao:deleteAct",[acts],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}

