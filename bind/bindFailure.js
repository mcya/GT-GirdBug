var sex = {
	'0' : '女',
	'1' : '男'
};

/*var columns = [
{id : "CUST_ID",header:'客户id',headAlign:'center',align : 'center',width:0,isCheckColumn : true,type :'string',exportable : false}, 
{id : "CUST_NAME",header : "姓名",width:100,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:custNameRender},
{id : "CUST_SEX",header : "性别",width:70,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:sexRender},
{id : "CUST_INTENTION",header:"意向",width:70,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "CUST_MOBILE",header : "手机号码",width:110,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "FAIL_REASON",header : "流失原因",width:250,headAlign:'left',align : 'center',type :'string'},
{id : "PUBLIC_STATUS",header : "客户状态",width:100,headAlign:'left',align : 'center',type :'string',renderer:pppppRder,toolTip:true},
{id : "SALE_NAME",header : "所属销售",width:150,headAlign:'left',align : 'center',type :'string'},
{id : "GROUP_NAME",header : "所属销售组",width:150,headAlign:'left',align : 'center',type :'string'},
{id : "PROJECT_NAME",header : "所属项目",width:150,headAlign:'left',align : 'center',type :'string'},
{id : "OPRENDER",header : "操作",width:180,headAlign:'left',align : 'center',type :'string',renderer:oooopRder,toolTip:true}
];*/

//性别
function sexRender(value, record, columnObj, grid, colNo, rowNo) {
	return sex[value];
}

var publicStatus = {
		'1'	: '隐形公客',
		'2' : '未处理公客',
		'3' : '已处理公客',
		'4' : '已处理公客'
	};
function pppppRder(value, record, columnObj, grid, colNo, rowNo) {
	if(value==1 || value=='1') {
		return '隐形公客';
	} else if(value==2 || value=='2') {
		return '未处理公客';
	} else if(value==3 || value=='3' || value==4 || value=='4') {
		return '已处理公客';
	}
}

function custNameRender(value, record, columnObj, grid, colNo, rowNo) {
	var id = record.CUST_ID;
	var name = record.CUST_NAME;
	return '<a href="javaScript:view(\''+id+'\');"> ' + name +  ' </a>';
}

// 公客类型
var publicFlag = {
		'1' : '公客',
		'0' : '已转客户'
	};

function publicFlagRender(value, record, columnObj, grid, colNo, rowNo) {
	return publicFlag[value];
}

//操作
function publicStatusRender(value, record, columnObj, grid, colNo, rowNo){
	var id = record.CUST_ID;
	var name = record.CUST_NAME;
	if(value==1 || value == '1'||value==5 || value == '5'){
		return '<font onclick="freeCust(\''+id+'\');" style="cursor:pointer;color:blue;padding-left:5px;padding-right:5px;">转入公客池</font>|<font style="padding-left:5px;cursor:pointer;color:blue" onclick="adjust(\''+id+'\',\''+name+'\');">指定销售员</font>';
	}else if(value==2 || value == '2'){
		return '<font style="cursor:pointer;padding-left:5px;padding-right:5px;">已转公客池</font>|<font style="padding-left:5px;cursor:pointer;color:blue" onclick="adjust(\''+id+'\',\''+name+'\');">指定销售员</font>';
	}else if(value==3 || value == '3' ||value==4 || value == '4'){
		return '<font style="cursor:pointer;padding-left:5px;padding-right:5px;">已转公客池</font>|<font style="padding-left:5px;cursor:pointer;">跟进中客户</font>';
	}
}

// button methods.......
function gridQuery() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	Form.showWaiting();
	reloadGrid('grid', params);
	Form.hideWaiting();
}

function doReset(){
	document.getElementById("queryForm").reset();
	gridQuery();
}

/*
 * 查看
 */
function view(id){
	window.location.href="clientDetail.jsp?id="+id+"&op=1";;
}

function freeCust(id){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.CustomerDao:changeCustToPublic",[id],function(reply){
		var data = reply.getResult();
		dialogUtil.alert(data.msg,function(){
			reloadGrid('grid');
		});
	});
}

/*
 * 调整销售组
 */
function adjust(id,name){
	dialogUtil.open("client","指定销售人员跟进","client/adjustGroup.jsp?id="+id,300,300,function(){},
	function(){
		var iframe = this.iframe.contentWindow;
		iframe.save();
		return false;
	});
}
