/**
 * 
 */
var zTreeSearch;
var selectedNode;
var toolbar;
var inputorg;

var zTree;
var treeObj;
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
				/*fontCss : getFontCss,*/
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
					$('#orgType').val(treeNode.type);
					var myorgid=treeNode.id;
					var myorgname=treeNode.name;
					var myorgtype=treeNode.type;
					var myorgcode=treeNode.nodeCode;
					
					selectedNode = treeNode;
					query(myorgid,myorgname,myorgtype,myorgcode);
				},
				beforeClick:function(treeId, treeNode, clickFlag){
					if(treeNode.type == "_CAT_"){
						return false;
					}
				},
				onAsyncSuccess : function(event, treeId, treeNode, msg) {
					
					/*if (getQueryFlag()) {
						loadNodeSucCallback(treeNode);
					}*/
					/*if(treeNode.type=='_NONE_'){
						treeNode.icon="../images/hongqi15px.gif";	
					}*/
					
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
							$('#orgCode').val(node.nodeCode);
						}
					}/*else{
						var mychil=zTree.getSelectedNodes();
						if('_NONE_'==mychil.type){
							mychil.icon="../images/hongqi15px.gif";
						}
					}*/
												
				}
			}
		};
	/*var  mytreenode=[
	           	{ name:"市直属机关党组织", icon:"../images/hongqi15px.gif"},             
	            ];*/
		zTree = $.fn.zTree.init($("#tree"), setting);
}


/**
=======================================================================================
**/
var allorg="";
var allgroupid="";
var i=0;
var checktype=true;
var checkclick=true;
function query(myorgid,myorgname,type,myorgcode){
	
		if('PROJECT'==type){								
			$('#heightsel').empty();
			var postData=Form.formToMap('noticeForm');;
			postData["ORG_CODE"]=myorgcode;
			postData["ORG_ID"]=myorgid;
			var serviceUrl=mypath+"/com.pytech.timesgp.web.dao.SenNoticeDao:GetUserGroup";
			ajax.remoteCall(					
					serviceUrl,
					[postData],function(reply){
				var data = reply.getResult();
				var myhtml = '<span id="'+myorgid+'" style="float:left;margin-left: 30px;font-size:18px;font-weight: bold;"><a href="javascript:;" onclick="addorg(\''+ myorgid+ '\',\''+myorgname+'\')">'+ '全选'+ '</a><br></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span id="'+myorgid+'" style="margin-left:20px;font-size:18px;font-weight: bold;"><a href="javascript:;" onclick="toback()">'+ '返回'+ '</a><br></span>';
		       /* var myhtml='<span><ui:Button btnType="add" onClick="javascript:addorg(\''+ myorgid+ '\',\''+myorgname+'\')">'+'全选'+'</ui:Button></span>';*/
				$("#heightsel").append(myhtml);
		        
				document.getElementById("treediv").style.display="none";				
				document.getElementById("heightsel").style.display="";
				for(var i=0;i<data.length;i++){
					var html = '<span id="'+data[i].ROLE_ID+'"><a href="javascript:;" onclick="Attach(\''
					+ data[i].GROUP_ID
					+ '\',\''+data[i].GROUP_NAME+'\',\''+myorgname+'\')">'
					+'<input id="checkbox'+data[i].GROUP_ID+'" name="checkname" type="checkbox"/>'
					+ data[i].GROUP_NAME
					+ '</a><br></span>';
			      $("#heightsel").append(html);
				}			
			});	
						
		}
	
	}
function addorg(myorgid,orgname){
	$('#tagBox1').addTag(orgname,{focus:true,unique:true});
	allorg+=myorgid;
	allorg+=",";
	document.getElementById("treediv").style.display="";				
	document.getElementById("heightsel").style.display="none";
}
function Attach(groupid,rolename,myorgname){
	var objName= document.getElementById("checkbox"+groupid).checked;
/*	var obj=$("#roleid").attr("checked");*/
	if(objName==true){
		$('#tagBox1').addTag(myorgname+'-'+rolename,{focus:true,unique:true});
		allgroupid+=groupid;
		allgroupid+=",";				
	}else{		
		$('#tagBox1').removeTag(myorgname+'-'+rolename);		
		var pattern = groupid;
		/*allroleid=allroleid.substring(0,allroleid.length-1);*/
		allgroupid = allgroupid.replace(new RegExp(pattern), "");
	}
	
}
function toback(){
	document.getElementById("treediv").style.display="";				
	document.getElementById("heightsel").style.display="none";
}




/*
 * 添加公告
 */
 function addNotice(status,oper){
	//则是进入数据库
	/*if(!Form.checkForm('noticeForm')){
		return;
	}*/
	var postData = Form.formToMap('noticeForm');
	
	postData["NOTICE_STATUS"]=status;
	
	if(postData.NOTICE_TITLE==""){
		 dialogUtil.alert('主题不能为空！',true);
			return false;
	}
	postData["NOTICE_CONTENT"] = editor.html(); 
	
	var orgIds = new Array();
	
	if(selector||selector.selectedNode){
		if(selector.selectedNode){//不为空
			for(var i = 0 ;i<selector.selectedNode.length;i++){
				orgIds.push(selector.selectedNode[i].id);
			}
			postData["orgId"]=orgIds.join(",");
		}
	}
	postData["ATTACH_NAME"] = fileNames;
	
	//旧文件
	postData["fileIds"] = fileIds;
	
	var serviceUrl = null;
	if (oper == 'edit') {
		serviceUrl=mypath+"/com.pytech.timesgp.web.dao.SenNoticeDao:updataNotice";
	}else{
		serviceUrl=mypath+"/com.pytech.timesgp.web.dao.SenNoticeDao:addNotice";
	}
	Form.showWaiting();
	ajax.remoteCall(
			serviceUrl,
			[postData],function(reply){
		var data = reply.getResult();
		Form.hideWaiting();
		if(data.success){
			dialogUtil.alert("操作成功!",function(){
				if(opener && opener.queryGrid){
					opener.queryGrid();
				}
				window.close();
			});
		}else{
			dialogUtil.alert(data.msg,function(){});
		}
	});
}

 
 function sendToNotice(){
		var records = getSelectedRecords('grid');
		
		if(records.length!=1){
			dialogUtil.alert('请选择要操作的记录！',true);
			return false;
		}else{
			if(records[0].NOTICE_STATUS=="0"){
				var NoticeId=records[0].NOTICE_ID;	
				dialogUtil.confirm('确认要发送这份公告吗？',
					function(){
						sendNotice(NoticeId,'0');
					},
					function(){});
			}else{
				dialogUtil.alert('已发送的公告不能重复发送！',true);
				return false;
			}
		}
	}
 
 /*
  * 发送公告(id,form:添加页面OR列表页面)
  * 1   : 添加页面
  * 其他 : 列表页面
  */
 function sendNotice(id,form){
 	ajax.remoteCall(mypath+"/com.pytech.timesgp.web.dao.SenNoticeDao:changeNoticeStatus", [id], function(reply) {
 		var data = reply.getResult();
 		if(data.success){
 			dialogUtil.tips("发送成功!");
 			if(form==1){
 				//关闭页面
 				location.href = "NoticeSen.jsp";
 			}else{
 				reloadGrid('grid');
 			}
 		}else{
 			dialogUtil.alert(data.msg,function(){});
 		}
 	});
 }
