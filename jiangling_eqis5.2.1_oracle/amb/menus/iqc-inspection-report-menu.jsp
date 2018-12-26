<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<div style="display: block; height: 10px;"></div>
	<security:authorize ifAnyGranted="iqc-check-group">
		<div id="myInspectionReportInput" class="west-notree" url="${iqcctx }/inspection-report/input.htm?changeview=true" onclick="changeMenu(this);"><span>进货检验报告</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-incominginspectionactionsreport-uncheck">
		<div id="unCheckInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/un-check.htm" onclick="changeMenu(this);"><span>待检验台帐</span></div>
	</security:authorize>
<%-- 	<security:authorize ifAnyGranted="iqc-incominginspectionactionsreport-checked">
		<div id="checkedInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/checked.htm" onclick="changeMenu(this);"><span>检验完成台帐</span></div>
	</security:authorize> --%>
	<security:authorize ifAnyGranted="iqc-incominginspectionactionsreport-recheck">
		<div id="recheckInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/recheck-list.htm" onclick="changeMenu(this);"><span>重检台帐</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-wait-audit-list">
		<div id="waitAuditInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/wait-audit.htm" onclick="changeMenu(this);"><span>待审核台帐</span></div>
	</security:authorize>
 	<security:authorize ifAnyGranted="iqc-wait-last-audit-list">
		<div id="lastWaitAuditInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/last-wait-audit.htm" onclick="changeMenu(this);"><span>待上级审核台帐</span></div>
	</security:authorize> 
	<security:authorize ifAnyGranted="iqc-inspection-report-complete-list">
		<div id="completeInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/complete.htm" onclick="changeMenu(this);"><span>检验已完成台帐</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-inspection-report-oklist">
		<div id="myOkInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/oklist.htm" onclick="changeMenu(this);"><span>审核完成合格台帐</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-inspection-report-unlist">
		<div id="myUnInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/unlist.htm" onclick="changeMenu(this);"><span>审核完成不合格台帐</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-incominginspectionactionsreport-list">
		<div id="myInspectionReport" class="west-notree" url="${iqcctx }/inspection-report/list.htm" onclick="changeMenu(this);"><span>进货检验报告台帐</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-inspection-no-list">
		<div id="inspection_no" class="west-notree" url="${iqcctx }/inspection-report/inspection-no-list.htm" onclick="changeMenu(this);"><span>检验单据查询</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc_incomingInspectionActionsReport_hide">
		<div id="inspection_y" class="west-notree" url="${iqcctx }/inspection-report/list-y.htm" onclick="changeMenu(this);"><span>隐藏数据台帐</span></div>
	</security:authorize>
	<security:authorize ifAnyGranted="iqc-sample-list">
		<div id="sampleTransfer" class="west-notree" url="${iqcctx }/inspection-report/sample-transfer/list.htm" onclick="changeMenu(this);"><span>检验方案变更确认</span></div>
	</security:authorize>
<script type="text/javascript">
$().ready(function(){
	$('#'+thirdMenu).addClass('west-notree-selected');
});
function changeMenu(obj){
	window.location = $(obj).attr('url');
}
</script>