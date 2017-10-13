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
function initTree(){
	$.ajaxSetup({
		cache : false
	});
	var setting = {
			async : {
				enable : true,
				dateType : "json",
				url : path+"/servlet/structure.action?method=structureType",
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
					$('#orgId').val(treeNode.id);
					$('#orgName').val(treeNode.name);
					$('#orgCode').val(treeNode.orgCode);
					selectedNode = treeNode;
					query(true);
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
							$('#orgCode').val(node.orgCode);
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



function reflesh(){
	var nodes = zTree.getSelectedNodes();
	if(nodes.length>0){
		var cnode= nodes[0];
		refreshChildren(cnode);
	}
}
