//configure.........
var state = {
	'1' : '有效',
	'0' : '无效'
};

function statusFanyi(val, record, columnObj, grid, colNo, rowNo) {
	if (val==1) {
		return '<span>已上传签名</span>'
	}
	if (val==2) {
		return '<span>已审核</span>'
	}
	if (val==0) {
		return '<span>未审核</span>'
	}
	return '<span></span>'
}


// 审核函数
function shenhe() {
	var records = getSelectedRecords('grid');
	console.log('records', records)
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	var flagss = 1
	var names
	var idsArr = new Array;
	var custidArr = new Array;
	for(var i = 0;i<records.length;i++){
		idsArr.push(records[i].ORDERID);
		custidArr.push(records[i].CUST_ID);
		if (records[i].STATUS==2) {
			flagss = 2;
			names = records[i].ATTACH_NAME
			break;
		}
	}
	if (flagss==2) {
		dialogUtil.alert('附件名称为【'+names+'】已审核！<br />请重新选择！')
		return
	}
	// sid销售员id
	var paramsData = {
		orderid: idsArr.join(","),
		cust_id: custidArr.join(','),
		sid: 'C03E38D98DAF477DA4098EE914B9D34F'
	}
	ajax.remoteCall(path+
		"/com.pytech.timesgp.web.dao.AttendanceDao:pdfOpertion",
		[paramsData],
		function(reply){
			reloadGrid('grid');
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
		});
	});
}
// 预览
function yulan(value ,record,columnObj,grid,colNo,rowNo){
	var pathValue = record.ATTACH_PATH
	return '<a href="javascript:;" name='+'"'+pathValue+'"'+' id=yulanButton>[预览]</a>';
}


// 下载
function xiazai(value ,record,columnObj,grid,colNo,rowNo){
	var needData = ''+record.ATTACH_NAME+','+record.ATTACH_PATH+','+record.STATUS
	return '<a href="javascript:;" name='+needData+' id=xiazaiButton>[下载]</a>';
}


// function operReander(value ,record,columnObj,grid,colNo,rowNo){
// 	return '<a href="javascript:;" onclick = "roleConfig(\''+value+'\')">[拥有权限]</a>';
// }








function stateRender(value, record, columnObj, grid, colNo, rowNo) {
	return state[value];
}
function topRender(value, record, columnObj, grid, colNo, rowNo) {
	if(value>0){
		return '<img src="../../images/top.png">';
	}
}
// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('grid', params);
}

function child(val,record){
	var channelId = record.CHANNEL_ID;
	return '<a href="javascript:;"onclick="ChildChannel(\''+channelId+'\')">子频道&nbsp;</a>';
}

//子频道
function ChildChannel(childchannelId){
	dialogUtil.open("subchannel","子频道","waiqin.jsp?oper=edit&CHANNEL_ID="+childchannelId,370,600,function(){
	});
}

function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

function deleteChannel(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var channelids = new Array();
		for(var i = 0;i<records.length;i++){
			channelids.push(records[i].CHANNEL_ID);
		}
		doDeleteChannel(channelids.join("','"));
	},function(){});
	
}
function doDeleteChannel(channelids){
	channelids = "'"+channelids+"'";
	
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.ChannelDao:getNewsNums",[channelids],function(reply){
		var data = reply.getResult();
		if(0 != data.COUNT){
			alert('频道下存在'+data.COUNT+'篇文章，不可删除！');
			return false;
		}
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.ChannelDao:deleteChannel",[channelids],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
				reloadGrid('grid');
			});
		});
	});
	
}