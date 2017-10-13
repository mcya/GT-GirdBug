

// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('grid', params);
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


/*
 * 删除
 */
function deleteOp(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var ids = new Array();
		for(var i = 0;i<records.length;i++){
			ids.push("'"+records[i].CALLEE_ID+"'");
		}
		doDeleteAct(ids.join(","));
	},function(){});
	
}
function doDeleteAct(ids){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.CalleeDao:deleteEntryDao",[ids],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}


/*
 * call客导入
 */
function importCall(){
	
	dialogUtil.open("call","导入call客","importAdd.jsp",200,350,function(){});
	
	
}

