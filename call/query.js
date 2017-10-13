

// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('grid', params);
}

var columns = [{
	id : "ACT_ID",
	headAlign : 'center',
	align : 'center',
	isCheckColumn : true,
	exportable : false
}, {
	id : "ACT_NAME",
	header : "名称",
	width :100,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "ACT_ADDR",
	header : "地点",
	width :100,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "ACT_DATE",
	header : "开始时间",
	width :200,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "ACT_END_DATE",
	header : "结束时间",
	width :200,
	headAlign:'left',
	align : 'center',
	type :'string',
	toolTip:true
},{
	id : "CREATE_USER_NAME",
	header : "创建人",
	align : 'center',
	width :100
}, {
	id : "CREATE_TIME",
	header : "创建时间0",
	align : 'center',
	width :200
}, {
	id : "CREATE_TIME",
	header : "创建时间1",
	align : 'center',
	width :200
}, {
	id : "CREATE_TIME",
	header : "创建时间2",
	align : 'center',
	width :200
}, {
	id : "CREATE_TIME",
	header : "创建时间3",
	align : 'center',
	width :200
}, {
	id : "CREATE_TIME",
	header : "创建时间4",
	align : 'center',
	width :200
}];

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

