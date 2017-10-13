
var columns = [{
	id : "MONTH",
	header : "月份",
	width :80,
	headAlign:'left',
	align : 'center',
	grouped : true,
	sortable:false
},{
	id : "TYPE",
	header : "类别",
	width :130,
	headAlign:'left',
	align : 'center',
	sortable:false
},  {
	id : "MONTH_D1",
	header : "1",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D2",
	header : "2",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D3",
	header : "3",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D4",
	header : "4",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D5",
	header : "5",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D6",
	header : "6",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D7",
	header : "7",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D8",
	header : "8",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D9",
	header : "9",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D10",
	header : "10",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}

, {
	id : "MONTH_D11",
	header : "11",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D12",
	header : "12",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D13",
	header : "13",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D14",
	header : "14",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D15",
	header : "15",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D16",
	header : "16",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D17",
	header : "17",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D18",
	header : "18",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D19",
	header : "19",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D20",
	header : "20",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},

{
	id : "MONTH_D21",
	header : "21",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D22",
	header : "22",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D23",
	header : "23",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D24",
	header : "24",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D25",
	header : "25",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D26",
	header : "26",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D27",
	header : "27",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D28",
	header : "28",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}, {
	id : "MONTH_D29",
	header : "29",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D30",
	header : "30",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
},{
	id : "MONTH_D31",
	header : "31",
	width :80,
	headAlign:'left',
	align : 'center',
	sortable:false
}
];

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

