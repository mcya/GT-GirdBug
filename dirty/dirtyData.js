function changeScope(obj,val){
	$(obj).siblings(".selected").removeClass("selected");
	$(obj).addClass("selected").addClass("label_active");
	$("#"+$(obj).attr("for")).val(val);
	query();
}
var state = {
	'1'	: '<font color="red">未来访</font>',
	'2' : '<font color="blue">已来访</font>',
	'3' : '<font color="gree">已成交</font>'
};
var sexred={
	'0' : '女',
	'1' :  '男'
};
var mystate = {'1':'公客','0':'非公客'};
function ispublic(value, record, columnObj, grid, colNo, rowNo) {		
		if(!value)
			value = 1;
		return state[value];	
}
function issex(value, record, columnObj, grid, colNo, rowNo) {
	return sexred[value];	
}
var columns = [
{id : "CUST_ID",header:'客户id',headAlign:'center',align : 'center',width:0,isCheckColumn : true,type :'string',exportable : false}, 
{id : "CUST_NAME",header : "姓名",width:100,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:custRender},
{id : "CUST_SEX",header : "性别",width:50,headAlign:'left',align : 'center',type :'string',toolTip:true,renderer:issex},
{id : "CUST_INTENTION",header:"意向",width:50,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "CUST_MOBILE",header : "手机号码",width:120,headAlign:'left',align : 'center',type :'string',toolTip:true},
{id : "CUST_SOURCE",header : "客户来源",width:130,headAlign:'left',align : 'center',type :'string'},
{id : "CUST_SALE_STATUS",header : "销售状态",width:80,headAlign:'left',align : 'center',type :'string',renderer:ispublic},
{id : "USER_NAME",header : "所属销售",width:100,headAlign:'left',align : 'center',type :'string'},
{id : "GROUP_NAME",header : "所属销售组",width:150,headAlign:'left',align : 'center',type :'string'},
{id : "OP_FLAG",header : "公客属性",width:70,headAlign:'left',align : 'center',type :'string',exportable:false,renderer:opRender},
{id : "PUBLIC_FLAG",header : "操作",width:220,headAlign:'left',align : 'center',type :'string',exportable:false,renderer:handleRender},
{id : "CREATE_TIME",header : "录入时间",width:200,headAlign:'left',align : 'center',type :'string'}
];
function exportSelectedList(){
	//exportExcel("grid","客户基础信息");
	var records = getSelectedRecords('grid');
	if(records.length == 0){
		dialogUtil.alert('请至少选择一条记录导出！',true);
		return false;
	}
	var ids = new Array();
	for(var i = 0;i<records.length;i++)
		ids.push("'"+records[i].CUST_ID+"'");
	//ids.join(",")
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href = path + "/servlet/excel_selected.action?fileName=selectedinfo"+dt+'&custIds=' + ids.join(",");
}
function exportSimpleList(){
	//exportExcel("grid","客户基础信息");
	var paramMap = Form.formToMap('queryForm');
	var params = '';
	for(var i in paramMap) {
		params = params + '&' + i + '=' + paramMap[i];
	}
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href = path + "/servlet/excel_simple.action?fileName=simpleinfo"+dt+params;
}
function exportDetailList(){
	var paramMap = Form.formToMap('queryForm');
	var params = '';
	for(var i in paramMap) {
		params = params + '&' + i + '=' + paramMap[i];
	}
	var date = new Date();
	var dt = date.getFullYear() + '-' + (date.getMonth()+1) + '-' + date.getDate();
	location.href=path+"/servlet/excel_all.action?fileName=allinfo"+dt+params;
}
function query(){
	var map = Form.formToMap('queryForm');
	map.DICT_NAME=$("#DICT_ID").find("option:selected").text();/*
	map.WORK_AREA=$("#WORK_AREA").find("option:selected").text();*/
	map.CUST_INDUST=$("#CUST_INDUST").find("option:selected").text();
	
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	Form.showWaiting();
	reloadGrid('grid', params);
	Form.hideWaiting();
}
//操作
function opRender(value, record, columnObj, grid, colNo, rowNo){
	if(value==1){
		return "<span style='color:green'>"+mystate[value]+"</span>";
	}else{
		return "<span style='color:#777777'>"+mystate[value]+"</span>";
	}
}
function handleRender(value ,record,columnObj,grid,colNo,rowNo){
	var id = record.CUST_ID;
	var userStatus = record.PUBLIC_FLAG;
	var a1='<a sign="aa" style="color:red;" href="javaScript:toggleUserStatus(\''+id+'\',\''+userStatus+'\')">【置为非公客】</a>|<a style="padding-left:5px" href="javaScript:adjust(\''+id+'\');">调整销售人员</a>';
	var a2='<a sign="aa" style="padding-right:12px;" href="javaScript:toggleUserStatus(\''+id+'\',\''+userStatus+'\')">【置为公客】</a>|<a style="padding-left:5px" href="javaScript:adjust(\''+id+'\');">调整销售人员</a>';
	
	if(value==1)
		return a1;
	else
		return a2;
}
function custRender(value ,record,columnObj,grid,colNo,rowNo){
	var id = record.CUST_ID;
	return '<a href="javaScript:void(0)" onclick="view(\''+id+'\');">'+value+'</a>';
}
function toggleUserStatus(userCode,userStatus){
	ajax.remoteCall(path+"/com.pytech.timesgp.web.dao.CustomerDao:toggleUserStatus",[userCode,userStatus],function(reply){
		var result = reply.getResult();
		dialogUtil.alert(result.msg,true);
		if(result.success){
			reloadGrid('grid');
		}
	});
}
/*
 * 调整销人员
 */
function adjust(id){
	dialogUtil.open("adjustCust","销售经理跟进","client/mgrselect/adjustSaler.jsp?id="+id,200,300,function(){},
	function(){
		var iframe = this.iframe.contentWindow;
		iframe.save();
		return false;
	});
}
/*
 * 查看
 */
function view(id){
	window.location.href="followDetail.jsp?id="+id;
}
function doReset(){
	document.getElementById("queryForm").reset();
	//重置自定义条件
	$(".selected").removeClass("selected");
	$("#TYPE").addClass("selected").addClass("label_active");
	$("#FROM").addClass("selected").addClass("label_active");
	$("#COM").addClass("selected").addClass("label_active");
	$("#INTE").addClass("selected").addClass("label_active");
	$("#TAG").addClass("selected").addClass("label_active");
	$("#INDUST").addClass("selected").addClass("label_active");
	$("#WAY").addClass("selected").addClass("label_active");
	$("#PAYWAY").addClass("selected").addClass("label_active");
	$("#VISIT").addClass("selected").addClass("label_active");
	
	$('#CUTO_TYPE').val('');
	$('#CUTO_FROM').val('');
	$('#CUTO_INTE').val('');
	$('#CUTO_COM').val('');
	$('#CUTO_TAG').val('');
	$('#CUTO_INDUST').val('');
	$('#CUTO_WAY').val('');
	$('#CUTO_PAYWAY').val('');
	$('#CUTO_VISIT').val('');
	query();
}

