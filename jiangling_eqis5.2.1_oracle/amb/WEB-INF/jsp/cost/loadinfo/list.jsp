<%@page import="com.ambition.util.common.DateUtil"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.ambition.cost.entity.CostRecord"%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>安必兴—企业管理效率促进专家</title>
	<%@include file="/common/meta.jsp" %>
	<script type="text/javascript" src="${resourcesCtx}/widgets/validation/validate-all-1.0.js"></script>
    <script type="text/javascript" src="${resourcesCtx}/widgets/validation/dynamic.validate.js"></script>
	<script type="text/javascript">
		$(function(){
		});
		function $successfunc(response){
			var result = eval("(" + response.responseText	+ ")");
			if(result.error){
				alert(result.message);
				return false;
			}else{
				return true;
			}
		}
		var myId = null,params = {};
		function $oneditfunc(rowid){
			myId = rowid;
			params={};
			//左右键
			enterKeyToNext("list",rowid,function(){
			});
			if(rowid==0){
				$('#'+rowid+'_occurringMonthStr','#list').val("<%=DateUtil.formateDateStr(new Date(),"yyyy-MM")%>");
			}
			$('#'+rowid+'_occurringMonthStr','#list')
				.datepicker({changeYear:'true',changeMonth:'true',dateFormat:'yy-mm'})
				.blur();
			$('#'+rowid+'_name','#list').attr("readonly","readonly")
			.click(selectComposing);
		}
		function $processRowData(data){
			for(var pro in params){
				data[pro] = params[pro];
			}
			data['sourceType']='<%=CostRecord.SOURCE_TYPE_INPUT%>';
			return data;
		}
		function $beforeEditRow(rowId,iRow,iCol,e){
			var isRight = false;
			<security:authorize ifAnyGranted="cost_cost_record_save">
			  isRight =  true;
			</security:authorize>
			return isRight;
		}
		//选择质量成本
		function selectComposing(){
			var url = '${costctx}/common/composing-select.htm';
	 		$.colorbox({href:url,iframe:true, innerWidth:800, innerHeight:400,
	 			overlayClose:false,
	 			title:"选择质量成本"
	 		});
		}
		function setFullComposingValue(datas){
			$('#'+myId+'_name','#list').val(datas[0].name)
			.closest("td").prev().html(datas[0].code);
			params['code'] = datas[0].code;
			params['levelTwoCode'] = datas[0].levelTwoCode;
			params['levelTwoName'] = datas[0].levelTwoName;
		}
		function onbindClick(){
			var sbtitle1=document.getElementById("search_box");
			if(sbtitle1.style.display=="block"){
				$("#condition_0").datepicker({changeYear:'true',changeMonth:'true',dateFormat:'yy-mm'})
				.blur();
				$("#condition_8").bind("click",customerClick);
				$("#condition_7").bind("click",projectClick);
			};
		}
		function customerClick(){
			var url='${complainctx}/customer-list/list-view.htm';
			$.colorbox({href:url,iframe:true, 
				width:$(window).width()<700?$(window).width()-100:900,
				height:$(window).height()<400?$(window).height()-100:600,
				overlayClose:false,
				title:"<s:text name='complain.message-1'/>"
			});
		}
		function setCustomerValue(objs){
			var obj = objs[0];
			$("#condition_8").val(obj.customerName);
		}  
		function projectClick(){
			var url = '${complainctx}/project-list/list-view.htm';
			$.colorbox({href:url,iframe:true, 
			innerWidth:$(window).width()<900?$(window).width()-50:900, 
			innerHeight:$(window).height()<680?$(window).height()-50:$(window).height(),
				overlayClose:false,
				title:"选择项目"
			});
		}
		function setProjectValue(datas){
			$("#condition_7").val(datas[0].projectName);
		}
	</script>
</head>

<body onclick="$('#sysTableDiv').hide(); $('#styleList').hide();">
	<script type="text/javascript">
		var secMenu="statistical_analysis";
		var thirdMenu="_composing_cost_info";
	</script>
	<div id="header" class="ui-north">
		<%@ include file="/menus/header.jsp" %>
	</div>
	 <div id="secNav">
		<%@ include file="/menus/cost-sec-menu.jsp" %>
	</div>
	
	<div class="ui-layout-west">
		<%@ include file="/menus/cost-statistical-analysis-menu.jsp" %>
	</div> 
	
	<div class="ui-layout-center">
		<div class="opt-body">
		<aa:zone name="main">
			<div class="opt-btn">
				<table cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td valign="middle" style="padding: 0px;width:50%; margin: 0px;" id="btnTd">
							<button class="btn" onclick="iMatrix.showSearchDIV(this);onbindClick();"><span><span><b class="btn-icons btn-icons-search"></b>查询</span></span></button>
							<security:authorize ifAnyGranted="cost_cost_record_export_info">
							<button class="btn" onclick="iMatrix.export_Data('${costctx}/loadinfo/export.htm?sourceType=<%=CostRecord.SOURCE_TYPE_INPUT%>');"><span><span><b class="btn-icons btn-icons-export"></b>导出</span></span></button>
							</security:authorize>
						</td>
					</tr>
				</table>
			</div>
			<div id="opt-content">
				<form id="contentForm" name="contentForm" method="post" action="">
					<%
						ActionContext.getContext().put("sourceType",CostRecord.SOURCE_TYPE_INPUT);
					%>
					<grid:jqGrid gridId="list" url="${costctx}/loadinfo/list-datas.htm" code="QIS_COST_VIEW"></grid:jqGrid>
				</form>
			</div>
		</aa:zone>
		</div>
	</div>
</body>
<script type="text/javascript" src="${resourcesCtx}/widgets/colorbox/jquery.colorbox.js"></script>
<script type="text/javascript" src="${resourcesCtx}/js/search.js"></script>
</html>