<%@page import="com.ambition.util.common.DateUtil"%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	Calendar calendar = Calendar.getInstance();
	String endDateStr = DateUtil.formateDateStr(calendar.getTime(),"yyyy-MM");
	
	calendar.add(Calendar.MONTH,-12);
	String startDateStr = DateUtil.formateDateStr(calendar.getTime(),"yyyy-MM");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>安必兴—企业管理效率促进专家</title>
	<%@include file="/common/meta.jsp" %>
	<script type="text/javascript" src="${ctx}/js/highcharts.js"></script>
	<script type="text/javascript" src="${ctx}/widgets/highcharts/modules/exporting.js"></script>
	<script type="text/javascript" src="${ctx}/js/hightchartsExport.js"></script>
	<script type="text/javascript">
		var startTime = 0;
		function contentResize(){
			if(cacheResult != null){
				clearTable();
				createReport(cacheResult);
				createDetailTable(cacheResult);
			}
		}
		
		var cacheResult = null;
		var goalLine = null;//目标线
		$(document).ready(function(){
			contentResize();
			$('#datepicker1').datepicker({"dateFormat":'yy-mm',changeMonth:true,changeYear:true});
			$('#datepicker2').datepicker({"dateFormat":'yy-mm',changeMonth:true,changeYear:true});
			search();
		});
		
		var chart = null;
		function createReport(result){
			if(chart != null){
				chart.destroy();
				chart = null;
			}
			var goalLines = [],hasShowGoalLine = false;
			for(var pro in result.categories){
				goalLines.push(result.goalLine);
			}
			var reportDiv = "reportDiv";
			var width = $("#" + reportDiv).width();
			chart = new Highcharts.Chart({
				exporting : {
					enabled : false
				},
				colors : ['red'],
				chart: {
					renderTo: reportDiv,
					spacingRight : 63 
				},
				credits: {
			         enabled: false
				},
				title: {
					style : {
						"font-weight":'bold',
						"color": '#3E576F',
						"font-size": '20px'
					},
					text: result.title
				},
				subtitle: {
					text: result.subtitle,
					y:33,
					x:0 //center
				},
				xAxis: [{
					categories: result.categories,
					labels : {
						style : {
							"color": 'black'
						}
					}
				},{
					labels : {
						enable:false,
						style : {
							"color": 'black'
						}
					}
				}],
				yAxis: [{
					title: {
						text: result.yAxisTitle1,
						stackLabels: {
							enabled: true,
				            style: {
				               fontWeight: 'bold',
				               color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
				            }
						},
						style : {
							'font-weight':'bold',
							fontSize:15,
							color : 'black'
						},
						rotation : 0
					},
					plotLines: [{
						value: 12,
						color: 'black'
					}],
					labels : {
						align : 'right'
					},
					maxPadding : 0,
					gridLineWidth : 1,
					gridLineDashStyle : 'ShortDashDot',
					min: 0,
					max: result.max
				}],
				legend: {
			         align: 'right',
			         verticalAlign : 'top',
			         floating: true,
			         backgroundColor: '#FFFFFF',
			         x : 45,
			         y : 0
			    },
			    plotOptions: {
					line: {
						dataLabels: {
							enabled: true,
							formatter : function(){
					 			if(this.y<=0){
					  				return '';
					 			}else{
					  				return '<font style="color:black;">' + this.y.toFixed(0) + '</font>';
					 			}
							}      
			            },
			            lineWidth : 1,
			            shadow : true,
			            borderWidth:0,
			            pointPadding:0,
			            groupPadding:0.0,
			    		cursor : 'pointer',
	               		events : {
		            		click : function(obj){
// 	            				showDetailByDate(obj.point.type,obj.point.count);
		            		}
		            	}
			        },
			        spline: {
			        	shadow : false,
			            dashStyle : 'shortdot',
			        	dataLabels : {
			        	   enabled: true,
			        	   x:40,
			               formatter : function(){
			            	   if(!hasShowGoalLine){
			            		   hasShowGoalLine = true;
			            		   return "<b>目标线" + this.y + "</b>";
			            	   }else{
			            		   return '';
			            	   }
			               }
			        	},
			        	color : 'green'
			        }
			    },
				tooltip: {
					formatter: function() {
						var s;
						if (this.series.type=="line") { 
							s = this.x+'月'  +':'+ this.y.toFixed(0) +"<br/><span style='font-size:12px;color:blue;'>"+this.x+"月PPM值</span>";
						}else{
							s = '目标线:' + result.goalLine;
						}
						return s;
					}
				},
				series: [{
					type: 'line',
					name: result.series3.name,
					data: result.series3.data
				},{
					type : 'spline',
					name: '目标线',
					marker: {
						radius: 0
		            },
					data: goalLines
				}]
			},function(){
				var endTime = (new Date()).getTime();
			});
		}
		
		//确定的查询方法
		function search(){
			var date1 = $("#datepicker1").val();
			var date2 = $("#datepicker2").val();
			if(date1>date2){
				alert("统计年月前后选择有误，请重新设置！");
				$("#datepicker1").focus();
			}else{
				reportByParams(getParams());
			}
		}	
		
		//根据参数获取数据
		function reportByParams(params){
			$("#message").html("图表生成中,请稍候...");
			startTime = (new Date()).getTime();
			$.post("${iqcctx}/inspection-statistics/ppm-stat-chart-datas.htm",params,function(result){
				$("#message").html("");
				if(result.error){
					alert(result.message);
				}else{
					createDetailTable(result);
					createReport(result);
					cacheResult = result;
				}
			},'json');
		}
		
		//获取表单的值
		function getParams(){
			var params = {};
			$("#search :input[type=text]").each(function(index,obj){
				var jObj = $(obj);
				if(jObj.val()){
					params[obj.name] = jObj.val();
				}
			});
			$("#search input[type=hidden]").each(function(index,obj){
				var jObj = $(obj);
				if(obj.name&&jObj.val()){
					params[obj.name] = jObj.val();
				}
			});
			$("#search select").each(function(index,obj){
				var jObj = $(obj);
				if(obj.name&&jObj.val()&&jObj.val()!=""){
					params[obj.name] = jObj.val();
				}
			});
			return params;
		}
		
		//创建表格
		var detailTable = null;
		function createDetailTable(result){
			clearTable();
			var colModel=[{name:'custom_name',width:80,index:'custom_name',align:'center',label:result.firstColName}],datas = [];
			var tableHeaderList = result.tableHeaderList;
			for(var i=0;i<tableHeaderList.length;i++){
				if(tableHeaderList[i]==1000){
					colModel.push({name:'date'+i,index:'date' + i,width:75,align:'center',label:'合计'});
				}else{
					colModel.push({name:'date'+i,index:'date' + i,width:75,align:'center',label:tableHeaderList[i]});
				}
			}
			//正常检验数
			var p = {id:1,custom_name:result.series1.name};
			var dataCheckList = result.series1.data;
			var sum = 0;
			for(var i=0;i<dataCheckList.length;i++){
				var val = dataCheckList[i].y;
				p['date' + i] = val;
				if(val&&!isNaN(val)){
					sum += parseFloat(val);
				}
			}
			var index = dataCheckList.length;
			p['date' + index] = sum.toFixed(0);
			datas.push(p);
			//免检数
			var p = {id:1,custom_name:result.series4.name};
			var dataCheckList = result.series4.data;
			var sum = 0;
			for(var i=0;i<dataCheckList.length;i++){
				var val = dataCheckList[i].y;
				p['date' + i] = val;
				if(val&&!isNaN(val)){
					sum += parseFloat(val);
				}
			}
			var index = dataCheckList.length;
			p['date' + index] = sum.toFixed(0);
			datas.push(p);
			//不良数
			var p = {id:1,custom_name:result.series2.name};
			var dataCheckList = result.series2.data;
			var sum = 0;
			for(var i=0;i<dataCheckList.length;i++){
				var val = dataCheckList[i].y;
				p['date' + i] = val;
				if(val&&!isNaN(val)){
					sum += parseFloat(val);
				}
			}
			var index = dataCheckList.length;
			p['date' + index] = sum.toFixed(0);
			datas.push(p);
			
			//PPM
			var p = {id:1,custom_name:result.series3.name};
			var dataCheckList = result.series3.data;
			var sum = 0;
			for(var i=0;i<dataCheckList.length;i++){
				var val = dataCheckList[i].y;
				p['date' + i] = val;
				if(val&&!isNaN(val)){
					sum += parseFloat(val);
				}
			}
			var index = dataCheckList.length;
			p['date' + index] = sum.toFixed(2);
			datas.push(p);
			
			var width1 = $(".opt-btn").width();
			detailTable = $("#detail_table").jqGrid({
				datatype: "local",
				localReader : {
					id : 'custom_name'
				},
				data: datas,
				rownumbers: true,
				width: width1,
				height: (datas.length+1)*25,
				colModel: colModel,
			    multiselect: false,
			   	autowidth: true,
				forceFit: true,
				shrinkToFit: false,
				viewrecords: true, 
				sortorder: "desc",
				gridComplete: function(){}
			});
		}
			
		//清除表格
		function clearTable(){
			if(detailTable != null){
				detailTable.GridDestroy();
				detailTable = null;
			}
			$("#detailTableDiv_parent").html("<table id=\"detail_table\"></table>");
		}
		
		//选择供应商
		function selectSupplier(){
			$.colorbox({
				href:"${supplierctx}/archives/select-supplier.htm",
				iframe:true,
				width:$(window).width()<1000?$(window).width()-100:1000,
				height:$(window).height()<600?$(window).height()-100:600,
				overlayClose:false,
				title:"选择供应商"
			});
		}
		
		function setSupplierValue(objs){
			var obj = objs[0];
			$("#params\\.supplierName_equals").val(obj.name);
			$("#params\\.supplierCode_equals").val(obj.code);
		}
		
		//选择零部件
		function selectBom(){
			var url = '${carmfgctx}';
			$.colorbox({href:url+"/common/product-bom-select.htm",iframe:true, 
				width:$(window).width()<900?$(window).width()-100:900, 
				innerHeight:$(window).height()<500?$(window).height()-100:500,
	 			overlayClose:false,
	 			title:"选择零部件"
	 		});
	 	}
		
		function setBomValue(datas){
			$("#params\\.partName_equals").val(datas[0].value);
			$("#params\\.partCode_equals").val(datas[0].key);
	 	}
		
		//查看明细的方法
		function showDetailByDate(typeName,type){
			var params = getParams();
			params['params.iteminspectionType_equals'] = typeName;
			params['params.itemconclusion_equals'] = 'NG';
			var url = '${iqcctx}/inspection-report/inspection-report-detail.htm?a=1';
			for(var pro in params){
				url += "&" + pro + "=" + params[pro];
			}
			$.colorbox({href:encodeURI(url),iframe:true, 
				innerWidth:$(window).width()<900?$(window).width()-50:900, 
				innerHeight:$(window).height()<700?$(window).height()-50:$(window).height(),
	 			overlayClose:false,
	 			title:"台帐明细"
	 		});
		}
		
		function goToNewLocationById(id){
			var url='${iqcctx}';
			$.colorbox({href:url+"/inspection-report/view-info.htm?id="+id,iframe:true, 
				innerWidth:$(window).width()<900?$(window).width()-50:900, 
				innerHeight:$(window).height()<700?$(window).height()-50:$(window).height(),
				overlayClose:false,
				title:"页面详情"
			});
		}
		function exportChart(){
			 $.exportChart({
	    		chart:chart,
	    		grid:$("#detail_table"),
	    		message:$("#message"),
	    		width:$("#reportDiv").width(),
	    		height:$("#reportDiv").height()
	    	}); 
		}
		//发送邮件
		function sendChart(){
			$.sendChart({
				chart:chart,
				grid:$("#detail_table"),
				message:$("#message"),
				width:$("#reportDiv").width(),
				height:$("#reportDiv").height()
			});
		}
		function formReset(){
			$("#params\\.supplierCode_equals").val("");
			$("#params\\.partCode_equals").val("");
		}
	</script>
</head>
<body onclick="$('#sysTableDiv').hide(); $('#styleList').hide();" >
	<script type="text/javascript">
		var secMenu="statAnalyse";
		var thirdMenu="myPpmStatChart";
	</script>
	
	<div id="header" class="ui-north">
		<%@ include file="/menus/header.jsp" %>
	</div>
	<div id="secNav">
		<%@ include file="/menus/iqc-sec-menu.jsp" %>
	</div>
	
	<div class="ui-layout-west">
		<%@ include file="/menus/iqc-statistics-report-menu.jsp" %>
	</div>
	
	<div class="ui-layout-center">
		<div class="opt-body" style="overflow:auto;">
		 	<div class="opt-btn"><span style="margin-left:4px;color:red;" id="message"></span></div>	
			<div id="search" style="display:block;padding: 2px;">
				<form action="" onsubmit="return false;">
					<table class="form-table-outside-border" style="width:100%;">
						<tr>
							<td>
								<span style="float:left;width:70px;text-align:right;padding-right:2px;">统计年月</span>
								<input id="datepicker1" type="text" name="params.startDate_ge_date" readonly="readonly" style="width:72px" class="line" value="<%=startDateStr%>"/>
							        至<input id="datepicker2" type="text" name="params.endDate_le_date" readonly="readonly" style="width:72px" class="line" value="<%=endDateStr%>"/>
						    </td>
						    <td>
						    	<span style="float:left;width:70px;text-align:right;padding-right:2px;">供应商</span>
								<input type="text" name="params.supplierName_equals" id="params.supplierName_equals" style="width:170px;" readonly="readonly" onclick="selectSupplier();"/>
						 		<input type="hidden" name="params.supplierCode_equals" id="params.supplierCode_equals"/>
							</td>
							<td>
								<span style="float:left;width:70px;text-align:right;padding-right:2px;">零部件</span>
								<input type="text" name="params.partName_equals" id="params.partName_equals" style="width:170px;" readonly="readonly" onclick="selectBom();"/>
						 		<input type="hidden" name="params.partCode_equals" id="params.partCode_equals"/>
							</td>
						</tr>
						<tr>
							<%--<td>
								<span style="float:left;width:70px;text-align:right;padding-right:2px;">零件类别</span>
								<s:select list="materialTypeOptions" id="materialType"
										  theme="simple"
										  cssStyle="width:172px;"
										  listKey="value" 
										  listValue="value" 
										  name="params.materialType_equals"
										  labelSeparator=""
										  emptyOption="true">
								</s:select>
							</td>
							<td>
								<span style="float:left;width:70px;text-align:right;padding-right:2px;">车型</span>
								<s:select id="modelSpecification"
									  list="modelSpecifications" 
									  cssStyle="width:172px;"
									  emptyOption="true"
									  name="params.modelSpecification_equals"
									  theme="simple"
									  listKey="value" 
									  listValue="value">
								</s:select>
							</td> --%>
							<td colspan="3" style="text-align: right;">
								<button class='btn' type="button" onclick="search();"><span><span><b class="btn-icons btn-icons-stata"></b>统计</span></span></button>
								<button class='btn' type="button" onclick="exportChart();"><span><span><b class="btn-icons btn-icons-export"></b>导出</span></span></button>
							 	<button class='btn' type="button" onclick="reset();formReset();"><span><span><b class="btn-icons btn-icons-redo"></b>重置</span></span></button>
							 	<security:authorize ifAnyGranted="IQC_INSPECTION-REPORT_CHECK-TYPE-CHART_EMAIL">
							 		<button class='btn' type="button" onclick="sendChart();"><span><span><b class="btn-icons btn-icons-email"></b>发送邮件</span></span></button>&nbsp;
								</security:authorize>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div>
				<table style="width:98.5%;">
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
			<div style="font-size:18px;font-weight:bold;margin-bottom:12px;">
				<div>
					说明:
				</div>
				<div style="padding-left:8px;">
					&nbsp;月份范围:上月26日到本月25日
				</div>
				<div style="padding-left:8px;">
					&nbsp;&nbsp;不良数:来料不良统计数+过程不良+未装车不良+整车零部件不良
				</div>
				<div style="padding-left:8px;">
					&nbsp;不良PPM:不良数/(检验数+免检数)*1000000
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript" src="${resourcesCtx}/widgets/colorbox/jquery.colorbox.js"></script>
<script type="text/javascript" src="${resourcesCtx}/widgets/timepicker/timepicker-all-1.0.js"></script>
</html>