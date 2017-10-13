

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
function colorRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="grey">'+val+'</font>';
}
function readonlyRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="red">'+val+'</font>';
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
	//return '<font color="red">'+val+'</font>';
	return val;
}
function expandFinishRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_FINISH_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return '<font color="red">'+val+'</font>';
}
function expandCallRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].EXPAND_CALL_CNT;
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
function visitFinishCntRender(val, record, columnObj, grid, colNo, rowNo) {
	if(record.WEEK_DESC=='月目标') 
		return '<font color="blue">'+val+'</font>';
	if(record.WEEK_DESC=='月总计') {
		var data = grid.dataset.data;
		var total = 0;
		for(var i in data) {
			if(data[i].WEEK_DESC=='月目标')
				continue;
			total = total + data[i].VISIT_FINISH_CNT;
		}
		return '<font color="red">'+total+'</font>';
	}
	return '<font color="red">'+val+'</font>';
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
	return '<font color="red">'+val+'</font>';
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

/**
 * 当销售组新添加人员时，重新分配周目标
 */
function reAllocate() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	var nodes = zTree.getSelectedNodes();
	params.orgId = nodes[0].id;
	params.YEAR =  $('#YEAR').val();
	params.MONTH = $('#MONTH').val();
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.PurposeDao:reAllocateWeek",params,function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}

function exportWeekList(){
	var paramMap = Form.formToMap('queryForm');
	var params = '';
	for(var i in paramMap) {
		params = params + '&' + i + '=' + paramMap[i];
	}
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href = path + "/servlet/week_target.action?fileName=WeekTarget"+dt+params;
}
