function toAddNotice(){
	
	window.open("NoticeEdit.jsp?oper=new","新增公告", "height=600, width=920, top=30, left=330,resizable=no,location=no");
	
}
function editNotice(){
	var records = getSelectedRecords('grid');
	var status = records[0].NOTICE_STATUS;
	if(records.length!=1){
		dialogUtil.alert('请选择要修改的记录！',true);
		return false;
	}else{
		if(status=="0"){
			var noticeid=records[0].NOTICE_ID;
			window.open("./NoticeEdit.jsp?NOTICE_ID="+noticeid+"&oper=edit","修改公告", "height=600, width=920, top=30, left=330,resizable=no,location=no");
		}else{
			dialogUtil.alert('已经发送的公告不能修改!',true);
			return false;
		}
	}
	
}

function deleteNotice(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择要删除的记录！',true);
		return false;
	}else{
	var NoticeId=records[0].NOTICE_ID;	
	var Invalidtime=records[0].INVALID_TIME;
		  dialogUtil.confirm('确认要删除这条记录吗？',function(){
				ajax.remoteCall(
						mypath+"/com.pytech.timesgp.web.dao.SenNoticeDao:deleteNotice",
						[NoticeId],
						function(reply){
					var data = reply.getResult();
					dialogUtil.alert(data.msg,function(){
						reloadGrid('grid');
					});
			},function(){});
		
      },function(){});
  }
}
function notitype(value ,record,colObj,grid,colNo,rowNo){
	 if(record.EMERGENCY==1){
		 return "紧急";
	 }else{
		 return "普通";
	 }
}
function isreading(value ,record,colObj,grid,colNo,rowNo){
	 if(record.READ_FLAG==1){
		 return "已读";
	 }else{
		 return "未读";
	 }
}

function caozuo(value ,record,colObj,grid,colNo,rowNo){
	var noticeid=record.NOTICE_ID;
	return '<a href="javascript:;" onclick="doseeNotice(\''+noticeid+'\')">查看</a>';
}
function doseeNotice(noticeid){
	window.open("NoticeSee.jsp?NOTICE_ID="+noticeid+"&oper=view","noticeSee", "height=600, width=900, top=30, left=330,resizable=no,location=no,scrollbars=yes ");
}
function SeeNotice(){
	var records = getSelectedRecords('grid');
	if(records.length!=1){
		dialogUtil.alert('请选择要查看的记录！',true);
		return false;
	}else{
	var NoticeId=records[0].NOTICE_ID;
	window.open("NoticeSee.jsp?NOTICE_ID="+NoticeId+"&oper=view","noticeSee", "height=600, width=900, top=30, left=330,resizable=no,location=no,scrollbars=yes ");

	}
}

function queryGrid(){
	var map = Form.formToMap('queryForm');

	var params = parameters;
	for(var key in map){
		params[key] = map[key];
	}
	reloadGrid('grid',params);
}
function changeScope(obj,val){
	$(obj).siblings(".selected").removeClass("selected");
	$(obj).addClass("selected").addClass("label_active");
	$("#"+$(obj).attr("for")).val(val);
	queryGrid();
}

function quickSearch(obj){
	var val = $(obj).attr("val");
	$("#issen").val(val);
	$(obj).siblings(".selected").removeClass("selected");
	$(obj).addClass("selected");
	queryGrid();
}



function doReset(){
	document.getElementById("queryForm").reset();
	$(".selected").removeClass("selected");
	$("#TYPE").addClass("selected").addClass("label_active");
	$("#STATUS").addClass("selected").addClass("label_active");
	$('#issen').val('2');
	$('#notice_type').val('');
	queryGrid();
}

