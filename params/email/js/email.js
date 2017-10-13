//configure.........
var state = {
	'1' : '有效',
	'0' : '无效'
};

// 获取url
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


// 收件人字段
function shoujianren(val, record, columnObj, grid, colNo, rowNo) {
	var needData = record.ORG_ID + ',' + record.USERNAME
	if (val==null || val=='') {
		return '<button name='+needData+' style="margin:5px 10px 0;float:right;" id=sjrButtonIdAdd>修改</button>';
	}
	return '<font color="blue">'
				+val+
			'</font><button name='+needData+' style="margin:5px 10px 0;float:right;" id=sjrButtonId>修改</button>';
}

// 性别字段
function xingbie(val, record, columnObj, grid, colNo, rowNo) {
	if (val=='M') return '<span>男</span>';
	if (val=='F') return '<span>女</span>';
	return '<span></span>'
}


// 收件人查询
function query() {
	var map = Form.formToMap('queryForm');
	var params = parameters;
	for ( var key in map) {
		params[key] = map[key];
	}
	reloadGrid('gridEe', params);
}

// 收件人选择保存
function saveShoujian(){
	var records = getSelectedRecords('gridEe');
	if(records.length == 0){
		dialogUtil.alert('请选择需要操作的记录！',true);
		return false;
	}
	var projidValue = getUrlParam('projids');
	var userids = getUrlParam('userids')
	console.log('gridEe-records', records, projidValue)
	var projidArr = new Array();
	var useridArr = new Array();
	var emailArr = new Array();
	var falgs = 1
	for(var i = 0;i<records.length;i++){
		projidArr.push(records[i].ORG_ID);
		useridArr.push(records[i].USERID);
		emailArr.push(records[i].EMAIL);
		if (records[i].USERID==null || records[i].USERID=='') {
			falgs = 2
			break;
		}
		if (records[i].EMAIL==null || records[i].EMAIL=='') {
			falgs = 3
			break;
		}
	}
	if (falgs==2) {
		dialogUtil.alert('姓名为空，无法保存。请重新选择!', true)
		return
	}
	if (falgs==3) {
		dialogUtil.alert('邮箱为空，无法保存。请重新选择!', true)
		return
	}
	console.log('USERID', useridArr.join(","), useridArr)
	var paramsData = {
		PROJID: projidValue,
		USERID: useridArr.join(","),
		EMAIL: emailArr.join(","),
		USERIDS1: userids,
	}
	ajax.remoteCall(path+
		"/com.pytech.timesgp.web.dao.AttendanceDao:elect",
		[paramsData],
		function(reply){
			// reloadGrid('grid');
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){	
			// 亦可以在此  直接返回
			// window.history.back(-1)
		});
	});
}















function stateRender(value, record, columnObj, grid, colNo, rowNo) {
	return state[value];
}
function topRender(value, record, columnObj, grid, colNo, rowNo) {
	if(value>0){
		return '<img src="../../images/top.png">';
	}
}


function child(val,record){
	var channelId = record.CHANNEL_ID;
	return '<a href="javascript:;"onclick="ChildChannel(\''+channelId+'\')">子频道&nbsp;</a>';
}

//子频道
function ChildChannel(childchannelId){
	dialogUtil.open("subchannel","子频道","email.jsp?oper=edit&CHANNEL_ID="+childchannelId,370,600,function(){
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

/*function editDept(channelId){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择一条记录进行修改！',true);
		return false;
	}
	dialogUtil.open("channel","责任部门调整","deptTree.jsp?CHANNEL_ID="+channelId,350,300,function(){
	},function(){
		var iframe = this.iframe.contentWindow;
    	if (!iframe.document.body) {
        	alert('页面未打开，请稍微！')
        	return false;
        };
        var codes = iframe.getSelectedNodes();
        
        $.ajax({
    		url: path+'/servlet/resource.action?method=saveState',
    		method:'post',
    		dataType:'json',
    		contentType:"application/x-www-form-urlencoded; charset=utf-8",
    		data:{channelId:channelId,resCodes:codes},
    		success:function(data){
    			dialogUtil.alert(data.msg,true);
    		},
    		error:function(req,data){
    			dialogUtil.alert("系统异常！["+req.status+"]",true);
    		}
    	});
        
	});
}*/





/**频道树
=======================================================================================
**/
//操作树工具栏 
/*function initToolbar(){
	toolbar = new dhtmlXToolbarObject("mgrbtn");
	toolbar.setIconsPath("/eac-core/res/dhtmlx/dhtmlxtoolbar/imgs/");
	//增删改查
	toolbar.addButton("add", 1, null, "add.png", "");
	toolbar.setItemToolTip("add", "新增");
	
	toolbar.addButton("edit", 2, null, "edit.png", "");
	toolbar.setItemToolTip("edit", "修改");
	toolbar.addButton("delete", 3, null, "delete.png", "");
	toolbar.setItemToolTip("delete", "删除");
	toolbar.addButton("reflesh", 4, null, "refresh.png", "");
	toolbar.setItemToolTip("reflesh", "刷新");
	toolbar.addButton("search", 5, null, "search.png", "");
	toolbar.setItemToolTip("search", "搜索");
	
	toolbar.attachEvent("onClick", function(itemId) {
		var nodes=zTree.getSelectedNodes();
		switch (itemId) {
		case "add": {
			doAdd();
			break;
		}
		case "edit":{
			edit();
			break;
		}
		case "delete":{
			doDelete();
			break;
		}
		case "reflesh":{
			reflesh();
			break;
		}
		case "search":{
			showSearch();
			break;
			}
		}
	});
}



var zTree;
var zTreeSearch;
var selectedNode;
 初始化树 
function initTree(rootId){
	$.ajaxSetup({
		cache : false
	});
	var setting = {
			async : {
				enable : true,
				dateType : "json",
				url : path+"/servlet/channelTreeServlet.action?method=channelTreetwo",
				autoParam:["id", "name", "orgLevel","orgCode","busiCode","type"]
			},
			view : {
				dblClickExpand : true,// 双击自动展开
				showLine : true,
				selectedMulti : false,
				fontCss : getFontCss,
				expandSpeed : ($.browser.msie && parseInt($.browser.version) <= 6) ? "": "fast"
			},

			data : {
				simpleData : {
					enable : true,
					idKey : "id",
					pIdKey : "pId",
					rootPId : ""
				}
			},
			callback : {
				onClick : function(event, treeId, treeNode) {
					selectedNode = treeNode;
					$("#CHANNEL_ID").val(treeNode.id);
					
					$("#P_CHANNEL_ID").val(treeNode.pId)
					if(treeNode.pId=='pd'){
						$("#P_CHANNEL_ID").val('');
					}
					if(treeNode.pId==''){
						Goto();
						return false;
					}
					
					goTo();
				},
				onAsyncSuccess : function(event, treeId, treeNode, msg) {
					
					if (getQueryFlag()) {
						loadNodeSucCallback(treeNode);
					}
					if (!treeNode) {// 表明第一个节点
						var nodes = zTree.getNodes();
						if (nodes&&nodes.length>0) {
							var node = nodes[0];
							document.getElementById(node.tId + "_a").click();
							//$('#'+node.tId+"_a").click();
							if (node.isParent) {
								zTree.expandNode(node, true, false, false); // 展开根结点
							} 
						}
					}
				}
			}
		};
		zTree = $.fn.zTree.init($("#tree"), setting);
		zTreeSearch = $.zTreeSearch(zTree, "search_str", "请输入机构名称", function() {
			if (selectedNode) {
				var node = zTree.getNodeByParam("orgCode", selectedNode.orgCode);
				if (node) {
					document.getElementById(node.tId + "_a").click();
				}
			}
		});
		zTreeSearch.setEnterKeyDown(doSearch);
}

//刷新子节点
function refreshChildren(organ){
	if(organ.isParent){
		if(organ.open){
			zTree.reAsyncChildNodes(organ, "refresh");//已展开的可刷新再搜索
		}else{
			zTree.expandNode(organ, true, false, false);
		}
	}else{
		organ.isParent=true;
		zTree.updateNode(organ);
		zTree.expandNode(organ, true, false, false);
	}
}
//刷新兄弟节点
function refreshBrothers(organ){
	var parent=organ.getParentNode();
	zTree.reAsyncChildNodes(parent, "refresh");//清空再加载
}

//刷新功能
function reflesh(){
	var nodes = zTree.getSelectedNodes();
	if(nodes.length>0){
		var cnode= nodes[0];
		
		refreshChildren(cnode);
		refreshBrothers(cnode);
	}
}


function loadNodeSucCallback(parentNode){	
	zTreeSearch.loadSucCallback(parentNode);
}

//查找功能
function doSearch(){
	showSearch();
	zTreeSearch.search(selectedNode);
}


function getQueryFlag(){
	return zTreeSearch.getQueryFlag();
}

//更加功能
function doAdd(){
//	var currentId = $("#orgId").val();
//	var currentName = $("#orgName").val();
//	var p_type = selectedNode?selectedNode.type:"";
//	dialogUtil.open("structure","添加机构","structureEdit.jsp?oper=add&pId="+currentId+"&p_type="+p_type,250,600,function(){
//		var nodes = zTree.getSelectedNodes();
//		
//		if(nodes.length>0){
//			var cnode= nodes[0];
//			refreshChildren(cnode);
//		}else{
//			window.location.reload(true);
//		}
//	});
}

//修改功能
function edit(){
//	var currentId = $("#orgId").val();
//	var currentName = $("#orgName").val();
//	var pNode = selectedNode.getParentNode();
//	var p_type = "";
//	if(pNode){
//		p_type = pNode?pNode.type:"";
//	}
//	var type = selectedNode?selectedNode.type:"";
//	dialogUtil.open("structure","修改机构","structureEdit.jsp?oper=edit&pId="+currentId+"&p_type="+p_type+"&type="+type,250,600,function(){
//		var nodes = zTree.getSelectedNodes();
//		if(nodes.length>0){
//			var cnode= nodes[0];
//			refreshBrothers(cnode);
//		}
//	});
}

//删除功能
function doDelete(){
//	var currentId = $("#orgId").val();
//	var currentName = $("#orgName").val();
//	if(selectedNode.isParent){
//		dialogUtil.alert('节点['+currentName+']含有子节点，不可删除！',true);
//		return ;
//	}
//	dialogUtil.confirm("确定要删除选中的机构["+currentName+"]?",function(){
//		ajax.remoteCall(path+"/com.open.eac.base.dao.StructureDao:delStructure",[currentId],function(reply){
//			var data = reply.getResult();
//			dialogUtil.alert(data.msg,function(){
//				var nodes = zTree.getSelectedNodes();
//				if(nodes.length>0){
//					var cnode= nodes[0];
//					refreshBrothers(cnode);
//				}
//				return true;
//			});
//		});
//	},true);
}

var ishow=false;
function showSearch(){
	if(ishow){
		$("#searchContanter").slideUp();
	}else{
		
		$("#searchContanter").show();
		$("#search_str").focus()
	}
	ishow = !ishow;
}
*/
