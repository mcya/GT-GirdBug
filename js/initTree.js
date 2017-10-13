/**
 * 
 */

var zTreeSearch;
var selectedNode;
var toolbar;
function getQueryFlag(){
	return zTreeSearch.getQueryFlag();
}

var zTree;
/* 初始化树 */
function initTree(rootId){
	if(rootId == undefined){
		rootId = '';
	}
	$.ajaxSetup({
		cache : false
	});
	var setting = {
			async : {
				enable : true,
				dateType : "json",
				url : path+"/servlet/structure.action?method=structure&rootId="+rootId,
				autoParam:["id", "name", "orgLevel","nodeCode","busiCode","type"],
				otherParam:{"showCat":"true"}
			},
			view : {
				dblClickExpand : true,// 双击自动展开
				showLine : true,
				selectedMulti : false,
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
					$('#orgId').val(treeNode.id);
					$('#orgName').val(treeNode.name);
					$('#orgCode').val(treeNode.nodeCode);
					//$('#orgType').val(treeNode.type);
					selectedNode = treeNode;
					query(true);
				},
				beforeClick:function(treeId, treeNode, clickFlag){
					if(treeNode.type == "_CAT_"){
						return false;
					}
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
							// $('#'+node.tId+"_a").click();
							if (node.isParent) {
								zTree.expandNode(node, true, false, false); // 展开根结点
							} else {
								//第一个节点无子节点，直接隐藏树
								//hideLeftTree();
							}
							$('#orgId').val(node.id);
							$('#orgName').val(node.name);
							//$('#orgType').val(treeNode.type);
							$('#orgCode').val(node.nodeCode);
						}
					}
				}
			}
		};
		zTree = $.fn.zTree.init($("#tree"), setting);
		zTreeSearch = $.zTreeSearch(zTree, "search_str", "请输入机构名称", function() {
			if (selectedNode) {
				var node = zTree.getNodeByParam("orgCode", selectedNode.nodeCode);
				if (node) {
					document.getElementById(node.tId + "_a").click();
				}
			}
		});
		zTreeSearch.setEnterKeyDown(doSearch);
}

function doSearch(){
	showSearch();
	zTreeSearch.search(selectedNode);
}

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
function refreshBrothers(organ){
	var parent=organ.getParentNode();
	zTree.reAsyncChildNodes(parent, "refresh");//清空再加载
}

function loadNodeSucCallback(parentNode){	
	zTreeSearch.loadSucCallback(parentNode);
}


/**
=======================================================================================
**/

function initToolbar(){
	toolbar = new dhtmlXToolbarObject("mgrbtn");
	toolbar.setIconsPath("/eac-core/res/dhtmlx/dhtmlxtoolbar/imgs/");
	if(structure_organ == true)
	{
		toolbar.addButton("add", 1, null, "add.png", "");
		toolbar.setItemToolTip("add", "新增");
		toolbar.addButton("edit", 2, null, "edit.png", "");
		toolbar.setItemToolTip("edit", "修改");
		toolbar.addButton("delete", 3, null, "delete.png", "");
		toolbar.setItemToolTip("delete", "删除");
	}
	toolbar.addButton("reflesh", 4, null, "refresh.png", "");
	toolbar.setItemToolTip("reflesh", "刷新");
	toolbar.addButton("search", 5, null, "search.png", "");
	toolbar.setItemToolTip("search", "搜索");
	if(userCode == 'admin'){
		toolbar.addButton("config", 6, null, "config.png", "");
		toolbar.setItemToolTip("config", "机构类型配置");
	}
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
			case "config":{
				doConfig();
				break;
			}
		}
	});
}
var _show = false;
function showSearch(){
	if(_show){
		$("#searchContanter").slideUp();
	}else{
		
		$("#searchContanter").show();
		$("#search_str").focus()
	}
	_show = !_show;
}
function reflesh(){
	var nodes = zTree.getSelectedNodes();
	if(nodes.length>0){
		var cnode= nodes[0];
		refreshChildren(cnode);
	}
}
function doDelete(){
	var currentId = $("#orgId").val();
	var currentName = $("#orgName").val();
	if(selectedNode.isParent){
		dialogUtil.alert('节点['+currentName+']含有子节点，不可删除！',true);
		return ;
	}
	dialogUtil.confirm("确定要删除选中的机构["+currentName+"]?",function(){
		ajax.remoteCall(path+"/com.open.eac.base.dao.StructureDao:delStructure",[currentId],function(reply){
			var data = reply.getResult();
			dialogUtil.alert(data.msg,function(){
				var nodes = zTree.getSelectedNodes();
				if(nodes.length>0){
					var cnode= nodes[0];
					refreshBrothers(cnode);
				}
				return true;
			});
		});
	},true);
}
function edit(){
	var currentId = $("#orgId").val();
	var currentName = $("#orgName").val();
	var pNode = selectedNode.getParentNode();
	var p_type = "";
	if(pNode){
		p_type = pNode?pNode.type:"";
	}
	var type = selectedNode?selectedNode.type:"";
	dialogUtil.open("structure","修改机构","structureEdit.jsp?oper=edit&pId="+currentId+"&p_type="+p_type+"&type="+type,250,600,function(){
		var nodes = zTree.getSelectedNodes();
		if(nodes.length>0){
			var cnode= nodes[0];
			refreshBrothers(cnode);
		}
	});
}
function doAdd(){
	var currentId = $("#orgId").val();
	var currentName = $("#orgName").val();
	var p_type = selectedNode?selectedNode.type:"";
	dialogUtil.open("structure","添加机构","structureEdit.jsp?oper=add&pId="+currentId+"&p_type="+p_type,250,600,function(){
		var nodes = zTree.getSelectedNodes();
		
		if(nodes.length>0){
			var cnode= nodes[0];
			refreshChildren(cnode);
		}else{
			window.location.reload(true);
		}
	});
}
function doConfig(){
	dialogUtil.open("structureType","机构类型配置","structureType.jsp",250,600,function(){
		var nodes = zTree.getSelectedNodes();
		
		if(nodes.length>0){
			var cnode= nodes[0];
			refreshChildren(cnode);
		}else{
			window.location.reload(true);
		}
	});
}