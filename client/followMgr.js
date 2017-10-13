var sex = {
	'0' : '女',
	'1' : '男'
};
//性别
function sexRender(value, record, columnObj, grid, colNo, rowNo) {
	return sex[value];
}
var laif = {
		'0' : '否',
		'1' : '是'
	};
	//性别
	function lfRender(value, record, columnObj, grid, colNo, rowNo) {
		return  laif[value];
	}





	//操作
	function handleRender(value, record, columnObj, grid, colNo, rowNo){
		
		var id = record.CUST_ID;
		var name = record.CUST_NAME;
		return '<a href="javaScript:view(\''+id+'\');">查看</a>';
		
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
	window.location.href="followDetail.jsp?id="+id;
}





