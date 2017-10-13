//configure.........
var state = {
	'5'	: '已发布',
	'0' : '已删除'
};
function status(value, record, columnObj, grid, colNo, rowNo) {
	var sta=record.NEWS_STATUS;
	var newid=record.NEWS_ID;
	if(sta==2){
		return '<a href="javascript:;" onclick="publish(\''+newid+'\')">发布</a>'
	}else{
		return state[value];
	}		
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
function publish(newsid){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.MsgDao:publishNews",[newsid],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('grid', params);
}

function queryy() {
	var map = Form.formToMap('queryForm');
	console.log('map', map, map.ORG_NAME)
	if (map.ORG_NAME==""){console.log('111')}
	else {
		if (map.PROJNAME=="" || map.PROJNAME==null) {
			dialogUtil.alert("请选择项目")
			return;
		}
	}
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	params.PROJID = map.PROJNAME
	reloadGrid('grid', params);
}


function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

function deleteMsg(){
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	if(records[0].NEWS_STATUS==0){
		dialogUtil.confirm('确认要永久删除选择的'+records.length+'条记录吗？',function(){			
			doDeleteMsg(records[0].NEWS_ID,records[0].NEWS_STATUS);
		},function(){});
	}else{
		dialogUtil.confirm('确认要删除选择的'+records.length+'条记录吗？',function(){		
			doDeleteMsg(records[0].NEWS_ID,records[0].NEWS_STATUS);
		},function(){});
	}
}
function doDeleteMsg(newsid,status){
	
		ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.MsgDao:deleteNews",[newsid,status],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
				reloadGrid('grid');
			});
		});
}
