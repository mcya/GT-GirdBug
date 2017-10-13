

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
	reloadGrid('grid', params);
}
function colorRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="grey">'+val+'</font>';
}
function readonlyRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="red">'+val+'</font>';
}
function visitFinishCntRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="red">'+val+'</font>';
}
function dealMoneyRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="red">'+val+'</font>';
}
function expandRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="red">'+val+'</font>';
}
function expandFinishRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="red">'+val+'</font>';
}
function preRender(val,record){
	var CourseId = record.COURSE_ID;
	return '<a href="javascript:;" onclick="viewCourse(\''+CourseId+'\')">预览</a>';
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

function exportMonthList(){
	var paramMap = Form.formToMap('queryForm');
	var params = '';
	for(var i in paramMap) {
		params = params + '&' + i + '=' + paramMap[i];
	}
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href = path + "/servlet/month_target.action?fileName=monthTarget"+dt+params;
}
