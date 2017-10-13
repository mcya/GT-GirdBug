function changeScope(obj,val){
	$(obj).siblings(".selected").removeClass("selected");
	$(obj).addClass("selected").addClass("label_active");
	$("#"+$(obj).attr("for")).val(val);
	query();
}
var state = {
	'1'	: '是',
	'0' : '否'
};
var sexred={
	'0' : '女',
	'1' :  '男'
};
function ispublic(value, record, columnObj, grid, colNo, rowNo) {		
		return state[value];	
}
function issex(value, record, columnObj, grid, colNo, rowNo) {		
	return sexred[value];	
}

function query(){
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('grid', params);
}









