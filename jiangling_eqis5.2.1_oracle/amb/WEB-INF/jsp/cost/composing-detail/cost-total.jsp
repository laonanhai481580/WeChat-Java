<%@page import="com.norteksoft.product.util.PropUtils"%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>安必兴—企业管理效率促进专家</title>
	<%@include file="/common/meta.jsp" %>
	<script type="text/javascript" src="${ctx}/js/common-layout.js"></script>
	<script type="text/javascript">
		$(function(){
			totalReport();
		});
		function totalReport(){
			var totalYear = $("#totalYear").val();
			$("#opt-content").html("数据加载中,请稍候... ...");
			var url = "${costctx}/composing-detail/cost-total-table.htm";
			$("#opt-content").load(url,{totalYear:totalYear});
		}
	</script>
</head>

<body onclick="$('#sysTableDiv').hide(); $('#styleList').hide();" >
	<script type="text/javascript">
		var secMenu="composing_detail";
		var thirdMenu="_composing_cost_total";
	</script>
	
	<div id="header" class="ui-north">
		<%@ include file="/menus/header.jsp" %>
	</div>
	<div id="secNav">
		<%@ include file="/menus/cost-sec-menu.jsp" %>
	</div>
	
	<div class="ui-layout-west">
		<%@ include file="/menus/cost-composing-detail-menu.jsp" %>
	</div>
	
	<div class="ui-layout-center">
		<div class="opt-body">
			<div class="opt-btn" style="line-height:33px;">
				统计年份<s:select list="totalYears"
					listKey="value"
					listValue="name"
					value="totalYear"
					cssStyle="width:80px;"
					id="totalYear"
					onchange="totalReport()"></s:select>
			 </div>	
			<div id="opt-content" style="text-align: center;">
				
			</div>
		</div>
	</div>
	
</body>
</html>