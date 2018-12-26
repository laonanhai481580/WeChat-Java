<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>纠正预防措施单</title>
	<%@include file="/common/meta.jsp"%>
	<!--上传js-->
	<script type="text/javascript" src="${ctx}/widgets/swfupload/swfupload.js"></script>
	<script type="text/javascript" src="${ctx}/widgets/swfupload/handlers.js"></script>
	<script type="text/javascript" src="${resourcesCtx}/js/staff-tree.js"></script>
	<script type="text/javascript" src="${resourcesCtx}/js/custom.tree.js"> </script>
	<script type="text/javascript" src="${ctx}/widgets/workflowEditor/swfobject.js"></script>
	<script type="text/javascript" src="${ctx}/js/workflowTag.js"></script>
	<!-- 表单和流程常用的方法封装 -->
	<script type="text/javascript" src="${ctx}/js/lcbh.js"></script>
	<script type="text/javascript" src="${ctx}/js/workflow-form-0.9.js"></script>
	<c:set var="actionBaseCtx" value="${supplierctx}/improve"/>
	<script type="text/javascript">
	isUsingComonLayout=false;
	var hasInitHistory = false;
	$(document).ready(function() {
		//初始化表单元素,格式如
		$initForm({
			webBaseUrl:'${ctx}',//后台执行的Action的前缀名,如:http://localhost:8080/amb/qrqc
			actionBaseUrl : '${actionBaseCtx}',//项目的前缀地址,如:http://localhost:8080/amb
			formId:'qrqcForm',//表单ID
			objId:'${id}',//数据库对象的ID
			taskId:'${taskId}',//任务ID
			beforeSaveCallback:function(){
				setAllLogs();
			},
			inputformortaskform:'taskform',//表单类型,taskform:流程办理界面,inputform:普通表单页面
			fieldPermissionStr:'${fieldPermission}'//字符串格式的字段权限
		});
		$( "#tabs" ).tabs({
			show: function(event, ui) {
				if(ui.index==1&&!hasInitHistory){
					changeViewSet("history","${id}");
					hasInitHistory = true;
				}
			}
		});
		setAllLogs();
		setTimeout(function(){
			$("#opt-content").height($(window).height()-70);
		},500);
	});
	</script>
	<jsp:include page="input-script.jsp" />
</head>

<body>
<div class="opt-body">
<aa:zone name="main">
		<aa:zone name="btnZone">
				<div class="opt-btn">
					 <c:if test="${isCurrent==true}">
					    <wf:workflowButtonGroup taskId="${taskId}"></wf:workflowButtonGroup>
					 </c:if>
		 			 <c:if test="${isCurrent==true}">
					 	<button  class='btn' type="button" id="_task_button" onclick="showIdentifiersDiv();"><span><span><b class="btn-icons btn-icons-back"></b>驳回</span></span></button>
					</c:if>	
					<span id="message1" style="color:red;padding-left:4px;font-weight:bold;">${message1}</span>
				</div>
				
					<div id="flag" onmouseover='show_moveiIdentifiersDiv();' onmouseout='hideIdentifiersDiv();'>
						<ul style="width:300px;">
							 <c:if test="${isNewData=='否'}">
								 <s:iterator var="returnTaskName" value="returnableTaskNames">
									 <li onclick="backToTask(this,'${actionBaseCtx}','${taskId}');" style="cursor:pointer;" title="驳回到 ${returnTaskName}" taskName="${returnTaskName}">
									  ${returnTaskName}
									 </li>
								 </s:iterator>
							</c:if>
						</ul>
				    </div>
				<span id="message" style="display: none;"><font class="onSuccess"><nobr>操作成功！</nobr></font></span>
			</aa:zone>
			<div style="display: none;color:red;" id="message">
				<s:actionmessage theme="mytheme" />
			</div>
			<div id="opt-content" class="form-bg">
				<form id="defaultForm1" name="defaultForm1"action="">
					<input type="hidden" name="id" id="id" value="${id}"  />
					<input name="taskId" id="taskId" value="${taskId}" type="hidden"/>
					<input id="selecttacheFlag" type="hidden" value="true"/>
					<input id="isNewData" type="hidden" name="isNewData" value="${isNewData}"/>
				</form>
				<div id="tabs">
					<ul>
						<li><a href="#tabs-1">表单信息</a>
						</li>
						<li><a href="#tabs-2" onclick="changeViewSet('history',${id});">流转历史</a>
						</li>
					</ul>
					<div id="tabs-1" style="background:#ECF7FB;">
						<aa:zone name="viewZone">
							<form id="qrqcForm" name="qrqcForm" method="post">
							     <table class="form-table-without-border" style="width:100%;margin: auto;">
						           <caption><h2>进料异常纠正措施单</h2></caption>
							       <tr>
								      <td style="text-left;padding-bottom:4px;">编号:${formNo}</td>
							       </tr>
					           </table>
								<c:if test="${isNewData=='是'}">
									<jsp:include page="input-form-new.jsp" />
								</c:if>		
								<c:if test="${isNewData=='否'}">
									<jsp:include page="input-form.jsp" />
								</c:if>	
								<security:authorize ifAnyGranted="supplier-improve-conceal">
									<%@ include file="process-form.jsp"%>
								</security:authorize>
							</form>
						</aa:zone>
					</div>
					<div id="tabs-2">
					</div>
				</div>
			</div>
		</aa:zone>
	</div>
</body>
</html>