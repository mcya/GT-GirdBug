//configure.........
var state = {
	'1' : '有效',
	'0' : '无效'
};

function statusFanyi(val, record, columnObj, grid, colNo, rowNo) {
	if (val==1) {
		return '<span>已审核</span>'
	}
	if (val==0) {
		return '<span>未审核</span>'
	}
	return '<span></span>'
}


















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
	var params = {
		ORG_ID: map.ORG_NAME,
		PROJID: map.PROJNAME,
		USERCODE: map.USERNAME,
		GROUP_ID: map.GROUP_NAME,
	};
	reloadGrid('grid', params);
}

function queryy() {
	var map = Form.formToMap('queryForm');
	if (map.ORG_NAME=='' || map.ORG_NAME==null) {
		dialogUtil.alert("请选择 地区公司")
		return
	}
	if (map.ORG_NAME!='' || map.ORG_NAME!=null) {
		if (map.PROJNAME=='' || map.PROJNAME==null) {
			dialogUtil.alert("请选择 项目")
			return
		}
	}
	var params = {
		ORG_ID: map.ORG_NAME,
		PROJID: map.PROJNAME,
		USERCODE: map.USERNAME,
		GROUP_ID: map.GROUP_NAME,
	};
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