<%@page import="com.ambition.util.common.CommonUtil1"%>
<%@page import="com.ambition.carmfg.entity.BusinessUnit"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.norteksoft.product.api.ApiFactory"%>
<%@page import="com.norteksoft.product.api.entity.Option"%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Calendar calendar = Calendar.getInstance();
	String endDateStr = sdf.format(calendar.getTime());
	calendar.add(Calendar.DATE,-15);
	String startDateStr = sdf.format(calendar.getTime());
	
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM");
	calendar = Calendar.getInstance();
	calendar.set(Calendar.YEAR,2012);
	calendar.set(Calendar.MONTH,0);
	calendar.set(Calendar.DATE,1);
	calendar.set(Calendar.HOUR_OF_DAY,0);
	calendar.set(Calendar.MINUTE,0);
	calendar.set(Calendar.MILLISECOND,0);
	calendar.set(Calendar.SECOND,0);
	String startYearStr = sdf1.format(calendar.getTime());
	
	calendar = Calendar.getInstance();
	calendar.set(Calendar.YEAR,2012);
	calendar.set(Calendar.MONTH,12);
	calendar.set(Calendar.DATE,1);
	calendar.add(Calendar.DATE,-1);
	calendar.set(Calendar.HOUR_OF_DAY,23);
	calendar.set(Calendar.MINUTE,59);
	calendar.set(Calendar.MILLISECOND,59);
	calendar.set(Calendar.SECOND,59);
	String endYearStr = sdf1.format(calendar.getTime());
	
	SimpleDateFormat ymf = new SimpleDateFormat("yyyy-MM");
	calendar = Calendar.getInstance();
	calendar.set(Calendar.YEAR,calendar.get(Calendar.YEAR));
	calendar.set(Calendar.MONTH,0);
	calendar.set(Calendar.DATE,1);
	String startDateStr1 = ymf.format(calendar.getTime());
	calendar = Calendar.getInstance();
	calendar.set(Calendar.YEAR,calendar.get(Calendar.YEAR));
	calendar.set(Calendar.MONTH,12);
	calendar.set(Calendar.DATE,1);
	calendar.add(Calendar.DATE,-1);
	String endDateStr1 = ymf.format(calendar.getTime());
	
%>
<script type="text/javascript">
<!--
	$(document).ready(function(){
		if($("#workshopSelect").val()){
			$("#workshopSelect").attr("disabled","disabled");
		}
	});
	function typeTimeSelect(objVal){
		if(objVal=='month'){
			$('#datepicker1').datepicker('option',{"dateFormat":'yy-mm',changeMonth:true,changeYear:true});
			$('#datepicker2').datepicker('option',{"dateFormat":'yy-mm',changeMonth:true,changeYear:true});
			$('#datepicker1').val("<%=startDateStr1%>");
			$('#datepicker2').val("<%=endDateStr1%>");
			$('#datepicker1').attr("name","params\.yearAndMonth_ge_int");
			$('#datepicker2').attr("name","params\.yearAndMonth_le_int");
		}else{
			$('#datepicker1').datepicker('option',{"dateFormat":'yy-mm-dd',changeMonth:true,changeYear:true});
			$('#datepicker2').datepicker('option',{"dateFormat":'yy-mm-dd',changeMonth:true,changeYear:true});
			$('#datepicker1').val("<%=startDateStr%>");
			$('#datepicker2').val("<%=endDateStr%>");
			$('#datepicker1').attr("name","params\.startDate_ge_date");
			$('#datepicker2').attr("name","params\.endDate_le_date");
			
		}
	}
//-->
</script>
<div class="opt-body" style="overflow-y:auto;">
	<form onsubmit="return false;">
	<div class="opt-btn" id="btnDiv">
	<span style="margin-left:4px;color:red;" id="message"></span>
	</div>
	 <div id="customerSearchDiv" style="display:block;padding:4px;">
<!-- 			<input type="hidden" name="params.myType" value="date"/> -->
			<table class="form-table-outside-border" style="width:100%;display:block;" id="curstomerSearchTable">
				<tr>
					<td style="padding-left:6px;padding-bottom:4px;"> 
						<ul id="searchUl">
					 		<li>
					 			<span style="margin:0px;padding:0px;float: left;">
					 			<select style="width:70px;height:21px;line-height:21px;margin:0px;padding:0px;" name="params.myType" onchange='typeTimeSelect(this.value);'>
					 				<option value="date" selected="selected">检验日期</option>
					 				<option value="month">检验月份</option>
					 			</select>&nbsp;
								</span>
								<input id="datepicker1" type="text" readonly="readonly" style="width:70px;" class="line" name="params.startDate_ge_date" value="<%=startDateStr%>"/>至
					    		<input id="datepicker2" type="text" readonly="readonly" style="width:70px;" class="line" name="params.endDate_le_date" value="<%=endDateStr%>"/>
					 		</li>
<!-- 					 		<li> -->
					 			
					 			
<%-- 					 			<input id="datepicker3" type="text" readonly="readonly" style="width:72px;" class="line" name="params.startDate_ge_date" value="<%=startDateStr1 %>"/> --%>
<%-- 					 		        至<input id="datepicker4"type="text" readonly="readonly" style="width:72px;" class="line" name="params.endDate_le_date" value="<%=endDateStr1 %>"/> --%>
<!-- 					 		</li> -->
					 		<li>
					 			<span>车间</span>
					 			<s:select list="workshops" 
								  theme="simple"
								  listKey="name" 
								  listValue="name" 
								  name="params.workshop_equals"
								  labelSeparator=""
								  value="workshop"
								  id="workshopSelect"
								  emptyOption="true"></s:select>
					 		</li>
					 		<li>
					 			<span>生产线</span>
					 			<s:select list="productionLines" 
								  theme="simple"
								  listKey="name" 
								  listValue="name" 
								  name="params.productionLine_equals"
								  labelSeparator=""
								  emptyOption="true"></s:select>
					 		</li>
					 		<li>
					 			<span>工段</span>
					 			<s:select list="sections" 
								  theme="simple"
								  listKey="value" 
								  listValue="name" 
								  name="params.section_equals"
								  labelSeparator=""
								  emptyOption="true"></s:select>
					 		</li>
					 		<li>
					 			<span>班别</span>
					 			<s:select list="workGroupTypes" 
								  theme="simple"
								  listKey="name" 
								  listValue="name" 
								  name="params.workGroupType_equals"
								  labelSeparator=""
								  emptyOption="true"></s:select>
					 		</li>
					 		<li>
					 			<span>产品型号</span>
					 			<input class="input" type="text"  name="params.modelSpecification_equals"/>
					 		</li>
					 		<li>
					 			<span>物料级别</span>
								<input id=materialLevels name="materialLevels" onclick="showAllMateriel();"/>
								<input type="hidden" id="params.checkBomMaterialLevels" name="params.checkBomMaterialLevels"/>
					 		</li>
					 		<li>
					 			<span>工序</span>
								<s:select list="workProcedures" 
								  theme="simple"
								  listKey="name" 
								  listValue="name" 
								  name="params.workProcedure_equals"
								  labelSeparator=""
								  emptyOption="true"></s:select>					 		
					 		</li> 
					 	</ul>
					 </td>
				</tr>
			</table>
			<table class="form-table-outside-border" style="width:100%" id="typeTable">
				<caption style="font-weight: bold;text-align: left;margin:4px;">统计对象</caption>
				<tr>
					<td><input type="radio" id="type_inspection" name="params.type" checked="checked" value="inspection" onclick="typeSelect(this,'inspection_select')" id="inspection_select_radio"/>
						<label for="type_inspection">检验&nbsp;&nbsp;&nbsp;&nbsp;
						检验采集点</label>
					<s:select id="inspection_select" cssClass="typeSelect" 
								  list="inspectionSpectionPoints" 
								  theme="simple"
								  listKey="inspectionPointName" 
								  listValue="inspectionPointName"
								  emptyOption="true"
								  name="params.inspectionPoint_equals"></s:select>
					</td>
					<td><input type="radio" id="type_check" name="params.type" value="check" onclick="typeSelect(this,'check_select')"/>
						<label for="type_check">检查&nbsp;&nbsp;&nbsp;&nbsp;
						检查采集点</label>
					<s:select id="check_select" cssClass="typeSelect"
								  disabled="true" 
								  list="checkSpectionPoints" 
								  theme="simple"
								  listKey="inspectionPointName" 
								  listValue="inspectionPointName" 
								  emptyOption="true"
								  name="params.inspectionPoint_equals"></s:select>
					</td>
				</tr>
				<tr>
				<td colspan="2" style="text-align:right;">
					<button  class='btn' type="button" onclick="search();"><span><span><b class="btn-icons btn-icons-stata"></b>统计</span></span></button>					
					<button  class='btn' type="button" onclick="reset();formReset();"><span><span><b class="btn-icons btn-icons-redo"></b>重置</span></span></button>
					<button  class='btn' type="button" onclick="exportChart();"><span><span><b class="btn-icons btn-icons-export"></b>导出</span></span></button>
					<button  class='btn' type="button" onclick="sendChart();"><span><span><b class="btn-icons btn-icons-email"></b>发送邮件</span></span></button>
					<button  class='btn' onclick="toggleSearchTable(this);" type="button"><span><span><b class="btn-icons btn-icons-search"></b>隐藏查询</span></span></button>&nbsp; 
				</td>
				</tr>
			</table>
	</div>
	</form>	
	<div>
		<table style="width:100%;">
			<tr>
				<td id="reportDiv_parent">
					<div id='reportDiv'></div>
				</td>
			</tr>
			<tr>
				<td id="detailTableDiv_parent">
					<table id="detailTable"></table>
				</td>
			</tr>
		</table>
	</div>
</div>
