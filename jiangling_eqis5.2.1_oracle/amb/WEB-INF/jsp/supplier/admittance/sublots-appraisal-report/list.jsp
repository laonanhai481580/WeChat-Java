<%@page import="com.ambition.supplier.entity.AppraisalReport"%>
<%@page import="com.norteksoft.product.util.PropUtils"%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>安必兴—企业管理效率促进专家</title>
	<%@include file="/common/meta.jsp" %>
	<script type="text/javascript">
		//重写保存后的方法
		function $successfunc(response){
			var result = eval("(" + response.responseText + ")");
			if(result.error){
				alert(result.message);
				return false;
			}else{
				return true;
			}
		}
		//重写编辑后的方法
		function $oneditfunc(rowId){
			
		}
		//导出
		function exports(){
			$("#contentForm").attr("action","${supplierctx}/admittance/sublots-appraisal-report/export.htm");
			$("#contentForm").submit();
		}
		function viewDetailInfo(value){
			var url='${supplierctx}/admittance/sublots-appraisal-report/view1.htm?id='+value;
	 		$.colorbox({href:url,iframe:true, innerWidth:1000, innerHeight:600,
	 			overlayClose:false,
	 			title:"查看小批鉴定详情",
	 			onClosed:function(){
	 			}
	 		});
		}
		//继续小批
		function startSublotsAppraisal(id){
			$("button").attr("disabled",true);
			$(".small-button-bg").attr("disabled",true);
			$("#opt-content").attr("disabled",true);
	 		$("#message").html("正在转到小批鉴定的表单页面,请稍候... ...");
			window.location = "${supplierctx}/admittance/sublots-appraisal-report/input.htm?appraisalReportId=" + id;
		}
		function editAppraisal(id){
			$("button").attr("disabled",true);
			$(".small-button-bg").attr("disabled",true);
			$("#opt-content").attr("disabled",true);
	 		$("#message").html("正在转到表单编辑页面,请稍候... ...");
	 		window.location = '${supplierctx}/admittance/sublots-appraisal-report/input.htm?id=' + id;
		}
		function operateFormatter(value,o,rowObj){
			var operations = "<div style='text-align:center;'>";
			operations += "<a class=\"small-button-bg\" href=\"javascript:editAppraisal("+value+");\" title='编辑小批鉴定报告'><span class=\"ui-icon ui-icon-note\" style='cursor:pointer;'></span></a>&nbsp;"; 
			operations += "<a class=\"small-button-bg\" href=\"javascript:void(0);viewDetailInfo("+value+");\" title='查看详细信息'><span class=\"ui-icon ui-icon-info\" style='cursor:pointer;'></span></a>";
			if(rowObj.appraisalState == '<%=AppraisalReport.STATE_PASS%>'||rowObj.appraisalState == '<%=AppraisalReport.STATE_FAIL%>'){
				operations += "&nbsp;<a class=\"small-button-bg\" href=\"javascript:void(0);startSublotsAppraisal("+value+");\" title='继续小批鉴定'><span class=\"ui-icon ui-icon-triangle-1-e\" style='cursor:pointer;'></span></a>";
			}
			operations += "</div>";
			return operations;
		}
		function appraisalFormatter(value){
			return "第" + value + "次小批鉴定";
		}
		function improveOperateFormatter(value){
			return "<div style='text-align:center;' title='发起改进'><a class=\"small-button-bg\" onclick='submitImprove("+value+");'><span class=\"ui-icon ui-icon-info\" style='cursor:pointer;'></span></a></div>";
		}
		function submitImprove(id){
	 		var url='${improvectx}/correction-precaution/called-input.htm?sublotsAppraisalId='+id;
	 		$.colorbox({href:url,iframe:true, innerWidth:1000, innerHeight:600,
	 			overlayClose:false,
	 			title:"改进页面",
	 			onClosed:function(){
	 			}
	 		});
	 	}
		function admittance(id){
			if(confirm("确定要允许供应商的该物料准入吗?")){
				$(".opt-btn").attr("disabled",true);
				$("#opt-content").attr("disabled",true);
				$("#message").html("正在执行操作,请稍候... ...");
				var url = "${supplierctx}/admittance/sublots-appraisal-report/admittance.htm";
				$.post(url,{sublotsAppraisalReportId:id},function(result){
					$(".opt-btn").attr("disabled",false);
					$("#opt-content").attr("disabled",false);
					$("#message").html(result.message);
					if(result.error){
						alert(result.message);
					}
					setTimeout(function(){
						$("#message").html("");
					}, 3000);
					$("#appraisalReportList").trigger("reloadGrid");
				},'json');
			}
		}
		function cancelAdmittance(id){
			if(confirm("确定要取消该供应商的准入物料吗?")){
				$(".opt-btn").attr("disabled",true);
				$("#opt-content").attr("disabled",true);
				$("#message").html("正在执行操作,请稍候... ...");
				var url = "${supplierctx}/admittance/sublots-appraisal-report/cancel-admittance.htm";
				$.post(url,{sublotsAppraisalReportId:id},function(result){
					$(".opt-btn").attr("disabled",false);
					$("#opt-content").attr("disabled",false);
					$("#message").html(result.message);
					if(result.error){
						alert(result.message);
					}
					setTimeout(function(){
						$("#message").html("");
					}, 3000);
					$("#appraisalReportList").trigger("reloadGrid");
				},'json');
			}
		}
		function admittanceFormatter(value,o,rowObj){
			if(rowObj.admittance){
				if(rowObj.admittance=='ok'){//代表可以准入
					return "&nbsp;";
				}else{
					return "&nbsp;" + rowObj.admittance;					
				}
			}else{
				return "&nbsp;";
			}
		}
		function addFormatter(value,o,rowObj){
			if(rowObj.admittance){
				if(rowObj.admittance=='ok'){//代表可以准入
					return "<a style='float:left;margin-left:15px;' class=\"small-button-bg\" href=\"javascript:void(0);admittance("+rowObj.id+");\" title='同意该物料准入'><span class=\"ui-icon ui-icon-check\" style='cursor:pointer;'></span></a>";
				}else{
					return "<a style='float:left;margin-left:15px;' class=\"small-button-bg\" href=\"javascript:void(0);cancelAdmittance("+rowObj.id+");\" title='取消该物料的准入'><span class=\"ui-icon ui-icon-closethick\" style='cursor:pointer;'></span></a>";					
				}
			}else{
				return "&nbsp;";
			}
		}
		function addNew(){
			$("button").attr("disabled",true);
			$(".small-button-bg").attr("disabled",true);
			$("#opt-content").attr("disabled",true);
			$("#message").html("正在转到小批鉴定表单编辑页面,请稍候...");
			window.location='${supplierctx}/admittance/sublots-appraisal-report/input.htm';
		}
	</script>
</head>

<body onclick="$('#sysTableDiv').hide(); $('#styleList').hide();">
	<script type="text/javascript">
		var secMenu="admittance";
		var thirdMenu="_sublots_appraisal";
	</script>
	
	<div id="header" class="ui-north">
		<%@ include file="/menus/header.jsp" %>
	</div>
	<div id="secNav">
		<%@ include file="/menus/supplier-sec-menu.jsp" %>
	</div>
	
	<div class="ui-layout-west">
		<%@ include file="/menus/supplier-admittance-menu.jsp" %>
	</div>
	
	<div class="ui-layout-center">
			<table cellpadding="0" cellspacing="0"></table>
			<div class="opt-body">
				<div class="opt-btn">
					<security:authorize ifAnyGranted="admittance-batch-appraisal-input">
					<button class="btn" onclick="addNew();"><span><span><b class="btn-icons btn-icons-add"></b>新建</span></span></button>
					</security:authorize>				
					<security:authorize ifAnyGranted="admittance-batch-appraisal-delete">
					<button class="btn" onclick="iMatrix.delRow();"><span><span><b class="btn-icons btn-icons-delete"></b>删除</span></span></button> 
					</security:authorize>				
					<security:authorize ifAnyGranted="admittance-batch-appraisal-datas">
					<button class="btn" onclick="iMatrix.showSearchDIV(this);"><span><span><b class="btn-icons btn-icons-search"></b>查询</span></span></button>	
					</security:authorize>				
					<security:authorize ifAnyGranted="admittance-batch-appraisal-export">
					<button class="btn" onclick="exports();"><span><span><b class="btn-icons btn-icons-export"></b>导出</span></span></button>
					</security:authorize>
					<span id="message" style="color:red;"></span>
				</div>
				<div id="opt-content">
					<form id="contentForm" name="contentForm" method="post"  action="">
						<grid:jqGrid gridId="appraisalReportList" url="${supplierctx}/admittance/sublots-appraisal-report/list-datas.htm" code="SUBLOTS_APPRAISAL_REPORT" dynamicColumn="${dynamicColumnDefinitions}"></grid:jqGrid>
					</form>
				</div>
			</div>
	</div>
</body>
</html>