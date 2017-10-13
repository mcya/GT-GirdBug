
// button methods.......
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	var nodes = zTree.getSelectedNodes();
	params.orgId = nodes[0].id;
	params.orgType = nodes[0].type;
	params.YEAR =  $('#YEAR').val();
	params.MONTH = $('#MONTH').val();
	params.WEEK = $('#WEEK').val();
	
	reloadGrid('grid', params);
	reloadGrid('grid2', params);
}

var columns = [{
	id : "groupName",
	header : "销售团队",
	width :130,
	headAlign:'left',
	align : 'center',
	sortable:false,
	grouped : true,
},{
	id : "saleName",
	header : "销售人员",
	width :130,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "taskCt",
	header : "来访客户任务量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "finishCt",
	header : "来访完成总数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitRate",
	header : "来访客户完成率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitDealCt",
	header : "来访成交数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitDealRate",
	header : "来访成交率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitACt",
	header : "来访A客数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitARate",
	header : "来访A客转化率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitBCt",
	header : "来访B客数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitBRate",
	header : "来访B客转化率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitCCt",
	header : "来访C客数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitCRate",
	header : "来访C客转化率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
}];


var columns2 = [{
	id : "groupName",
	header : "销售团队",
	width :130,
	headAlign:'left',
	align : 'center',
	sortable:false,
	grouped : true,
},{
	id : "saleName",
	header : "销售人员",
	width :130,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "taskCt",
	header : "来访客户任务量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "finishCt",
	header : "来访完成总数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitRate",
	header : "来访客户完成率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitDealCt",
	header : "来访成交数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitDealRate",
	header : "来访成交率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitACt",
	header : "来访A客数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitARate",
	header : "来访A客转化率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitBCt",
	header : "来访B客数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitBRate",
	header : "来访B客转化率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitCCt",
	header : "来访C客数量",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
},{
	id : "visitCRate",
	header : "来访C客转化率",
	width :100,
	headAlign:'left',
	align : 'center',
	sortable:false,renderer : function(value ,record,columnObj,grid,colNo,rowNo){
 		if(record.saleName=='小组总计')
			return "<font color='red'>"+value+"</font>";
		else
			return value;
	}
}];

function doReset(){
	document.getElementById("queryForm").reset();
	query();
}

