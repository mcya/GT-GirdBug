var sex = {
	'0' : '女',
	'1' : '男'
};
var mystate = {'0':'有效','1':'无效'};
function stateRender(value ,record,columnObj,grid,colNo,rowNo){
	var userCode = record.USER_CODE;
	var userStatus = record.USER_STATUS;
	var a1='<a sign="aa" style="color:red" href="javaScript:toggleUserStatus(\''+userCode+'\',\''+userStatus+'\')">【置为无效】</a>';
	var a2='<a sign="aa" href="javaScript:toggleUserStatus(\''+userCode+'\',\''+userStatus+'\')">【置为有效】</a>';
	
	if(value==0){
		return "<span style='color:green'>"+mystate[value]+"</span>"+a1;
	}else{
		return "<span style='color:#dedede'>"+mystate[value]+"</span>"+a2;
	}
}



function openUserDetail(userCode) {
	dialogUtil.open("user","查看人员信息",path+"/pages/module1/userManager/userView.jsp?USER_CODE="+userCode,150,600,function(){});
}

var columns = [
{id : "USER_CODE",headAlign : 'center',align : 'center',width:50,isCheckColumn : true,type :'string',exportable : false}, 
{id : "USER_NAME",header : "姓名",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:userRender},
{id : "USER_SEX",header : "性别",width :80,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:sexRender},
{id : "USER_MOBILE",header:"电话",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:phoneRender},
{id : "WECHAT_NO",header : "微信",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:wxRender},
{id : "GROUP_NAME",header : "所属销售组",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:groupRender},
{id : "USER_STATUS",header : "状态",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:stateRender}
];
/*{id : "USER_PWD",header : "密码",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true},*/

//性别
function sexRender(value, record, columnObj, grid, colNo, rowNo) {
	if('1'==record.USER_STATUS)
		return '<font color="#DADDEE">'+sex[value]+'</font>';
	return sex[value];
}
//用户信息详情
function userRender(value, record, columnObj, grid, colNo, rowNo) {
	if('1'==record.USER_STATUS)
		return '<a href="#" onclick="openUserDetail(\''+record.USER_CODE+'\');"><font color="#DADDEE">'+value+'</font></a>';
	return '<a href="#" onclick="openUserDetail(\''+record.USER_CODE+'\');">'+value+'</a>';
}
function phoneRender(value, record, columnObj, grid, colNo, rowNo) {
	if('1'==record.USER_STATUS)
		return '<font color="#DADDEE">'+value+'</font>';
	return value;
}
function wxRender(value, record, columnObj, grid, colNo, rowNo) {
	if('1'==record.USER_STATUS)
		return '<font color="#DADDEE">'+value+'</font>';
	return value;
}
function groupRender(value, record, columnObj, grid, colNo, rowNo) {
	if('1'==record.USER_STATUS)
		return '<font color="#DADDEE">'+value+'</font>';
	return value;
}
/*function stateRender(value, record, columnObj, grid, colNo, rowNo) {
	return '<a href="javascript:;" onclick="toggleUserStatus(\''+record.USER_CODE+'\',\''+record.USER_STATUS+'\')">['+state[record.USER_STATUS]+']</a>';
}*/
function toggleUserStatus(userCode,userStatus){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.UserMgrDao:toggleUserStatus",[userCode,userStatus],function(reply){
		var result = reply.getResult();
		dialogUtil.alert(result.msg,true);
		if(result.success){
			reloadGrid('grid');
		}
	});
}
function doReset(){
	document.getElementById("queryForm").reset();
	query();
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
	dialogUtil.open("user","查看人员信息",path+"/pages/module1/userManager/userView.jsp?USER_MOBILE="+id,150,600,function(){});
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
	var userCode = records[0].USER_CODE;
	var groupId = records[0].GROUP_ID;
	var name = records[0].USER_NAME;
	var type=records[0].USER_TYPE;
	var gpName = records[0].GROUP_NAME;
	dialogUtil.open("user","调整销售组",path+"/pages/module1/userManager/adjustGroup.jsp?name="+name+"&gpName="+gpName+"&USER_TYPE="+type+"&GROUP_ID="+groupId+"&USER_CODE="+userCode,300,250,function(){},
	function(){
		var iframe = this.iframe.contentWindow;
		iframe.save();
		return false;
	});
}

/*
 * 删除(根据USER_CODE进行删除)
 */
function deleteUser(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var ids = new Array();
		for(var i = 0;i<records.length;i++){
			ids.push("'"+records[i].USER_CODE+"'");
		}
		opsDelete(ids.join(","));
	},function(){});
	
}
function opsDelete(ids){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.UserMgrDao:deleteUser",[ids],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}

