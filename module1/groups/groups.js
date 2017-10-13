// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	//map.ORG_CODE = $("#orgId").val();
	var nodes = zTree.getSelectedNodes();
  	var orgId = nodes[0].id;
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	params['ORG_ID'] = orgId;
	reloadGrid('grid', params);
}

var columns = [
               
{id : "GROUP_ID",headAlign : 'center',align : 'center',isCheckColumn : true,exportable : false}, 
{id : "GROUP_NAME",header : "分组名称",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "GROUP_LEADER",header : "组长",renderer:leaderRender,sortable:false,width :100,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "GROUP_SALER",header : "组员",renderer:salerRender,width :400,headAlign:'left',sortable:false,type :'string',toolTip:true},
{id : "GROUP_DESC",header : "分组描述",width :150,headAlign:'left',type :'string',toolTip:true},
{id : "GROUP_ORG_NAME",header:"所属项目",width :100,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "GROUP_STATE",header:"操作",width :150,headAlign:'left',align : 'center',type :'string',toolTip:true ,renderer:handleRender}
];
var mystate = {'1':'有效','0':'无效'};
function handleRender(value ,record,columnObj,grid,colNo,rowNo){
	var id = record.GROUP_ID;
	var userStatus = record.GROUP_STATE;
	var a1='<a sign="aa" style="color:red" href="javaScript:toggleUserStatus(\''+id+'\',\''+userStatus+'\')">【置为有效】</a>';
	var a2='<a sign="aa" href="javaScript:toggleUserStatus(\''+id+'\',\''+userStatus+'\')">【置为无效】</a>';
	
	if(value==1){
		return "<span style='color:green'>"+mystate[value]+"</span>"+a2;
	}else{
		return "<span style='color:#777777'>"+mystate[value]+"</span>"+a1;
	}
}
function toggleUserStatus(userCode,userStatus){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.GroupDao:toggleUserStatus",[userCode,userStatus],function(reply){
		var result = reply.getResult();
		dialogUtil.alert(result.msg,true);
		if(result.success){
			reloadGrid('grid');
		}
	});
}

//添加组长
function leaderRender(value, record, columnObj, grid, colNo, rowNo) {
	return "<img style='float:left' title='修改组长' onclick='addLeader(\""+record.GROUP_ID+"\", \"" + record.GROUP_LEADER+ "\")' src='/eac-core/res/css/img/edit.png'></img>"+value;
}

//添加组员
function salerRender(value, record, columnObj, grid, colNo, rowNo) {
	return "<img style='float:left;' title='修改组员' onclick='addSaler(\""+record.GROUP_ID+ "\", \"" + record.GROUP_SALER+ "\")' src='/eac-core/res/css/img/edit.png'></img>"+value;
}

function addLeader(groupId, saler) {
	var nodes = zTree.getSelectedNodes();
  	var orgId = nodes[0].id;
	dialogUtil.open("group","选择销售组长",path+"/pages/module1/groups/selectSaler.jsp?flg=1&groupId="+groupId+"&saler="+saler+"&orgId="+orgId,500,800,function(){});
}


function addSaler(groupId, saler) {
	var nodes = zTree.getSelectedNodes();
  	var orgId = nodes[0].id;
	dialogUtil.open("group","选择销售人员",path+"/pages/module1/groups/copySaler.jsp?flg=2&groupId="+groupId+"&saler="+saler+"&orgId="+orgId,460,1000,function(){});
}

function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

/**
 * 弹出添加对话框
 */
function add(){
	var nodes = zTree.getSelectedNodes();
  	var orgId = nodes[0].id;
	dialogUtil.open("group","添加分组",path+"/pages/module1/groups/groupEdit.jsp?orgId="+orgId,220,500,function(){});
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
	var nodes = zTree.getSelectedNodes();
  	var orgId = nodes[0].id;
	var id = records[0].GROUP_ID;
	dialogUtil.open("group","修改分组信息",path+"/pages/module1/groups/groupEdit.jsp?oper=edit&GROUP_ID="+id,250,600,function(){
	});
}

/*
 * 查看
 */
/*function view(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行查看！',true);
		return false;
	}
	var id = records[0].group_MOBILE;
	dialogUtil.open("group","查看分组信息","groupView.jsp?group_MOBILE="+id,150,600,function(){});
	
}*/



/*
 * 删除(根据GROUP_ID进行删除)
 */
function deleteGroup(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var ids = new Array();
		for(var i = 0;i<records.length;i++){
			ids.push(records[i].GROUP_ID);
		}
		deleteG(ids.join(","));
	},function(){});
	
}
function deleteG(ids){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.GroupDao:deleteGroupDao",[ids],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}

