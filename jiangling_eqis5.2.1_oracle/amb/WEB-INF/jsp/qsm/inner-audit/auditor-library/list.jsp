<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>企业管理效率促进专家</title>
	<%@include file="/common/meta.jsp" %>
	<script src="${resourcesCtx}/widgets/validation/validate-all-1.0.js" type="text/javascript"></script>
	<script src="${resourcesCtx}/widgets/validation/dynamic.validate.js" type="text/javascript"></script>
	<script type="text/javascript" src="${resourcesCtx}/widgets/colorbox/jquery.colorbox.js"></script>
	<script type="text/javascript" src="${resourcesCtx}/js/search.js"></script>
	<script type="text/javascript">
		function $successfunc(response){
			var result = eval("(" + response.responseText + ")");
			if(result.error){
				alert(result.message);
				return false;
			}else{
				return true;
			}
		}
		function $beforeEditRow(rowId,iRow,iCol,e){
			var isRight = false;
			<security:authorize ifAnyGranted="QSM_AUDITOR_LIBRARY_SAVE">
				isRight =  true;
			</security:authorize>
			return isRight;
		}	
		
		function showPicture(value,options,obj){
			var strs = "";
			strs = "<div style='width:100%;' title='上传附件' ><a class=\"small-button-bg\" onclick=\"attachmentFilesClick('"+obj.id+"');\" href=\"#\"><input type='hidden' id='"+obj.id+"_hiddenFiles' value='"+value+"'/><span id='"+obj.id+"_uploadBtn' class='ui-icon ui-icon-image uploadBtn' style='cursor:pointer;display:none;'></span></a><span style='text-align:left;' id='"+obj.id+"_showFiles'>"+$.getDownloadHtml(value)+"</span><div>";
			return strs;
		}
		function attachmentFilesClick(rowId){
			//上传附件 
			$.upload({   
				showInputId : rowId + "_showFiles",
				hiddenInputId : rowId + "_hiddenFiles",
				title:"上传附件",
				callback:function(files){
					params.attachmentFiles = $("#" + rowId + "_hiddenFiles").val();
				}
			}); 
		}
		function addNew(){
			iMatrix.addRow();
			$("#undefined_uploadBtn").show();
		}
		var params = {};
		function $oneditfunc(rowId){
			selRowId = rowId;
			params.attachmentFiles = $("#" + rowId + "_hiddenFiles").val();
			params.hisAttachmentFiles = params.attachmentFiles;
			$(".uploadBtn").hide();
			$("#undefined_uploadBtn").show();
			$("#" + rowId + "_uploadBtn").show();
			
		}
		function $afterrestorefunc(rowId){
			$("#" + rowId + "_uploadBtn").hide();
		}
		function $processRowData(data){
			for(var pro in params){
				data[pro] = params[pro];
			}
			return data;
		}
		//导入台账数据
		function importDatas(){
			var url = encodeURI('${qsmctx}/inner-audit/auditor-library/import.htm');
			$.colorbox({href:url,iframe:true, innerWidth:350, innerHeight:200,
				overlayClose:false,
				title:"导入台账数据",
				onClosed:function(){
					$("#list").trigger("reloadGrid");
				}
			});
		}
		//导出模版
		function downloadTemplate(){
			window.location = '${qsmctx}/inner-audit/auditor-library/download-template.htm';
		}
	</script>
</head>

<body onclick="$('#sysTableDiv').hide(); $('#styleList').hide();" >
	<script type="text/javascript">
		var secMenu="inner_audit";
		var thirdMenu="_auditor_library_list";
	</script>
	
	<div id="header" class="ui-north">
		<%@ include file="/menus/header.jsp" %>
	</div>
	
	<div id="secNav">
		<%@ include file="/menus/qsm-sec-menu.jsp"%>
	</div>

	<div class="ui-layout-west">
		<%@ include file="/menus/qsm-inner-audit-third-menu.jsp"%>
	</div>
	<div class="ui-layout-center">
		<div class="opt-body">
			<form id="defaultForm" name="defaultForm" method="post" action=""></form>
			<aa:zone name="main">
				<div class="opt-btn">
					<security:authorize ifAnyGranted="QSM_AUDITOR_LIBRARY_SAVE">
						<button class="btn" onclick="iMatrix.addRow();"><span><span><b class="btn-icons btn-icons-add"></b>新建</span></span></button>
					</security:authorize>
					<security:authorize ifAnyGranted="QSM_AUDITOR_LIBRARY_DELETE">
						<button class="btn" onclick="iMatrix.delRow();"><span><span><b class="btn-icons btn-icons-delete"></b>删除</span></span></button>
					</security:authorize>
					<button id="searchBtn" class='btn' onclick="iMatrix.showSearchDIV(this);"><span><span><b class="btn-icons btn-icons-search"></b>查询</span></span></button>
					<security:authorize ifAnyGranted="QSM_AUDITOR_LIBRARY_EXPORT">
						<button class="btn" onclick="iMatrix.export_Data('${qsmctx}/inner-audit/auditor-library/export.htm');"><span><span><b class="btn-icons btn-icons-export"></b>导出</span></span></button>
					</security:authorize>
					<security:authorize ifAnyGranted="QSM_AUDITOR_LIBRARY_IMPORT">
						<button class='btn' onclick="importDatas();" type="button"><span><span><b class="btn-icons btn-icons-import"></b>导入</span></span></button>
						<button class="btn" onclick="downloadTemplate();"><span><span><b class="btn-icons btn-icons-download"></b>下载导入模板</span></span></button>
					</security:authorize>
					<span style="color:red;font-size:18px;" >* <span style="font-family:verdana;color:red;font-size:10px;">双击可编辑,Enter(回车)可保存.</span></span>
				</div>
				<div id="message"><s:actionmessage theme="mytheme" /></div>	
				<script type="text/javascript">setTimeout("$('#message').hide('show');",3000);</script>
				<div id="opt-content" >
					<form id="contentForm" name="contentForm" method="post"  action="">
						<grid:jqGrid gridId="list" url="${qsmctx}/inner-audit/auditor-library/list-datas.htm" submitForm="defaultForm" code="QSM_AUDITOR_LIBRARY" ></grid:jqGrid>
					</form>
				</div>
			</aa:zone>
		</div>
	</div>
	
</body>
</html>