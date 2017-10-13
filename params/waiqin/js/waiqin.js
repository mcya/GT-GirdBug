


function addChannel(){
	window.location.href=path+"/pages/params/waiqin/waiqinAdd.jsp?isUpdate=0"
}

function updateChannel(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	var lnlaAddr = []
	lnlaAddr.push(records[0].LONGITUDE)
	lnlaAddr.push(records[0].LATITUDE)
	lnlaAddr.push(records[0].ADDR)
	records = JSON.stringify(records[0])
	lnlaAddr = JSON.stringify(lnlaAddr)
	window.localStorage.setItem("records", records)
	window.localStorage.setItem("lnlaAddr", lnlaAddr)
	window.location.href=path+"/pages/params/waiqin/waiqinAdd.jsp?isUpdate=1"
}

function deleteChannel(){
	var records = getSelectedRecords('grid');
	records = records[0]
	console.log('records', records)
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的记录吗？',function(){
		var paramsObj = {
			ORGID: records.ORGID,
			PROJID: records.PROJID,
			GROUPID: records.GROUPID,
			USERCODE: records.USERCODE,
		}
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.WqWorkplaceDao:deleteWqWorkplace",[paramsObj],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
	},function(){});
}


// 地图地址数据
var saveInfo = [];
var saveData = '';
var saveName = '';
var xianshiName = '请点击此处选择上班地址';



// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	console.log('map', map)
	var params = {
		ORGID: map.ORG_NAME,
		PROJID: map.PROJNAME,
		GROUPID: map.GROUP_NAME,
		USERCODE: map.USERNAME,
	}
	reloadGrid('grid', params);
}
function colorRender(val, record, columnObj, grid, colNo, rowNo) {
	return '<font color="grey">'+val+'</font>';
}
function readonlyRender(val, record, columnObj, grid, colNo, rowNo) {
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

function exportGroupList(){
	var paramMap = Form.formToMap('queryForm');
	var params = '';
	for(var i in paramMap) {
		params = params + '&' + i + '=' + paramMap[i];
	}
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href = path + "/servlet/group_target.action?fileName=GroupTarget"+dt+params;
}

function getUrlParam(paramName) {
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=") > 1) {
        arrSource = unescape(this.location.search).substring(1, this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound) {
            if (arrSource[i].indexOf("=") > 0) {
                if (arrSource[i].split("=")[0].toLowerCase() == paramName.toLowerCase()) {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                }
            }
            i++;
        }
    }
    return paramValue;
}