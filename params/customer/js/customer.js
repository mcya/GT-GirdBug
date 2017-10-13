//configure.........
var state = {
	'1' : '有效',
	'0' : '无效'
};

var columns = [{
	id: 'GROUPID',
	header: 'id',
	width: 50,
	align : 'center',
	isCheckColumn: true
}, {
	id : "GROUPNAME",
	header : "参数名称",
	width :500,
	align : 'center',
	type :'string',
	toolTip:true
}];
var columnss = [{
	id: 'DICTID',
	header: 'id',
	width: 50,
	align : 'center',
	isCheckColumn: true
}, {
	id : "DICTNAME",
	header : "参数名称",
	width :300,
	align : 'center',
	type :'string',
	toolTip:true
}, {
	id : "GROUPBELONG",
	header : "参数范围",
	width :300,
	align : 'center',
	type :'string',
	toolTip:true
}];
var columnsss = [{
	id: 'DICTID',
	header: 'id',
	width: 50,
	align : 'center',
	isCheckColumn: true
}, {
	id : "DICTNAME",
	header : "子集参数名称",
	width :500,
	align : 'center',
	type :'string',
	toolTip:true
}];
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
	params.TYPE = 'org'
	reloadGrid('grid', params);
}

function queryy() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	params.TYPE = $('div#quickSearch span.selected').attr('val')
	reloadGrid('grid', params);
}

function child(val,record){
	var channelId = record.CHANNEL_ID;
	return '<a href="javascript:;"onclick="ChildChannel(\''+channelId+'\')">子频道&nbsp;</a>';
}

//子频道
function ChildChannel(childchannelId){
	dialogUtil.open("subchannel","子频道","customer.jsp?oper=edit&CHANNEL_ID="+childchannelId,370,600,function(){
	});
}

function quickSearch(obj){
	var val = $(obj).attr("val");
	$(obj).siblings(".selected").removeClass("selected");
	$(obj).addClass("selected");
	queryy();
}

function doReset(){
	document.getElementById("queryForm").reset();
	query();
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

// 删除--1
function deleteChannel(){
	var records = getSelectedRecords('gridEe');
	console.log('records', records)
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var beloidArr = new Array();
		var gropidArr = new Array();
		var dictidArr = new Array();
		for(var i = 0;i<records.length;i++){
			beloidArr.push(records[i].BELONGID);
			gropidArr.push(records[i].GROUPID);
			dictidArr.push(records[i].DICTID);
		}
		var paramsObj = {
			BELONGID: beloidArr.join(","),
			GROUPID: gropidArr.join(","),
			DICTID: dictidArr.join(","),
		}
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.ParametersDao:deleteParameter",[paramsObj],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
			reloadGrid('gridEe');
		});
	});
	},function(){});

}


// 新增---里一层
	function addChannel(){
		var urlGroupid = getUrlParam('groupids')
		var trLength = $("#gridEe table tr").length - 1
		// console.log('点击新增', $("#gridEe table"), columns, $("#gridEe table tr"), $("#gridEe table tr td"))
		dialogUtil.open("addChannel","添加客户参数",path+"/pages/params/customer/customerEdit.jsp?oper=add&urlGroupids="+urlGroupid+"&trLength="+trLength,360,580,
			function(){
				reloadGrid('gridEe');
			});
	}

// 修改---里一层
	function editChannel(){
		var records = getSelectedRecords('gridEe');
		var urlGroupid = getUrlParam('groupids')
		var trLength = $("#gridEe table tr").length - 1
		if(records.length!=1){
			dialogUtil.alert('请选择一条记录进行修改！',true);
			return false;
		}
		var paramsss = [records[0].DICTID, records[0].GROUPID, records[0].BELONGID]
		//window.location.href="channelEdit.jsp?oper=edit&CHANNEL_ID="+records[0].CHANNEL_ID;
		dialogUtil.open("editChannel","修改系统参数",path+"/pages/params/customer/customerEdit.jsp?oper=edit&urlGroupids="+urlGroupid+"&trLength="+trLength+"&CHANNEL_ID="+paramsss+"&dctids="+records[0].DICTID+"&belongids="+records[0].BELONGID+"",360,580,function(){
			reloadGrid('gridEe');
		});
	}


// 新增---里2层
	function addChanneel(){
		var urlGroupid = getUrlParam('groupids')
		var trLength = $("#gridTwo table tr").length - 1;
		var dctids = getUrlParam("dictids");
		console.log('点击新增', $("#gridTwo table"), columns, $("#gridTwo table tr"), $("#gridTwo table tr td"))
		dialogUtil.open("addChannel","添加客户参数",path+"/pages/params/customer/customerEedit.jsp?oper=add&urlGroupids="+urlGroupid+"&trLength="+trLength+"&dctids="+dctids,360,580,
			function(){
				reloadGrid('gridTwo');
			});
	}

// 修改---里2层
	function editChanneel(){
		var records = getSelectedRecords('gridTwo');
		var urlGroupid = getUrlParam('groupids')
		var trLength = $("#gridTwo table tr").length - 1
		if(records.length!=1){
			dialogUtil.alert('请选择一条记录进行修改！',true);
			return false;
		}
		var paramsss = [records[0].DICTID, records[0].GROUPID, records[0].BELONGID]
		//window.location.href="channelEdit.jsp?oper=edit&CHANNEL_ID="+records[0].CHANNEL_ID;
		dialogUtil.open("editChannel","修改系统参数",path+"/pages/params/customer/customerEedit.jsp?oper=edit&urlGroupids="+urlGroupid+"&trLength="+trLength+"&CHANNEL_ID="+paramsss+"&dctids="+records[0].DICTID+"&belongids="+records[0].BELONGID+"",360,580,function(){
			reloadGrid('gridTwo');
		});
	}


// 删除--2
function deleteChanneel(){
	var records = getSelectedRecords('gridTwo');
	console.log('records', records)
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){
		var beloidArr = new Array();
		var gropidArr = new Array();
		var dictidArr = new Array();
		for(var i = 0;i<records.length;i++){
			beloidArr.push(records[i].BELONGID);
			gropidArr.push(records[i].GROUPID);
			dictidArr.push(records[i].DICTID);
		}
		var paramsObj = {
			BELONGID: beloidArr.join(","),
			GROUPID: gropidArr.join(","),
			DICTID: dictidArr.join(","),
		}
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.ParametersDao:deleteParameter",[paramsObj],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('gridTwo');
		});
	});
	},function(){});

}





// 双击打开--里一层
function openNewTab() {
	var records = getSelectedRecords('grid')
	if(records.length == 0 || records.length > 1){
		return false;
	}
	window.localStorage.setItem('jtOxm', records[0].GROUPBELONG)
	window.location.href=path+'/pages/params/customer/customerSearch.jsp?groupids='+records[0].GROUPID;
}

// 双击打开--里二层
function openTabLiTwo() {
	var records = getSelectedRecords('gridEe')
	console.log('records', records)
	if(records.length == 0 || records.length > 1){
		return false;
	}
	if (records && records.length==1) {
		if (records[0].CANADD==1) {
			window.localStorage.setItem('jtOoxm', records[0].GROUPBELONG)
			window.location.href=path+'/pages/params/customer/customerSearchTwo.jsp?groupids='+records[0].GROUPID+'&dictids='+records[0].DICTID+'&belongids='+records[0].BELONGID;
		}
	}
}