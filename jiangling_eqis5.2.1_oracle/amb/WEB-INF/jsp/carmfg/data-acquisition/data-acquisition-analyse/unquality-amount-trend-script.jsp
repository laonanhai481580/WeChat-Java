<%@page import="com.norteksoft.product.util.PropUtils"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*"%>
<%
	Object params = ActionContext.getContext().getValueStack().findValue("params");
	if(params == null){
		ActionContext.getContext().put("params","{}");
	}
	//目标线
	String goalLine = "4.5";
	try{
		goalLine = com.norteksoft.product.util.PropUtils.getProp("unquality-trend-rate-goal-line");
	}catch(Exception e){}
%>
	<script src="${ctx}/widgets/validation/jquery.validate.js" type="text/javascript"></script>
	<script src="${ctx}/widgets/validation/jquery.metadata.js" type="text/javascript"></script>
	<script src="${ctx}/widgets/validation/dynamic.validate.js" type="text/javascript"></script>
<script type="text/javascript" src="${ctx}/js/common-layout.js"></script>
<script type="text/javascript" src="${ctx}/js/highcharts.js"></script>
<style>
<!--
	#searchUl{
		margin:0px;
		padding:0px;
	}
	#searchUl li{
		float:left;
		width:260px;
		height:24px;
		line-height:24px;
		list-style:none;
	}
	#searchUl li select{
		width:178px;
	}
	#searchUl li input{
		width:170px;
	}
	#searchUl li span{
		float:left;
		width:70px;
		text-align:right;
		padding-right:2px;
	}
	.rate-remark{
		width:120px;
		background:green;
		border:2px solid gray;
		padding:2px;
		zIndex: 1;
		position:absolute;
		word-break:break-all;
		dispaly: block;
		white-space:normal;
		color:white;
		cursor:pointer;
	}
	.rate-remark-line{
		width:2px;
		background:gray;
		zIndex: 1;
		position:absolute;
		word-break:break-all;
	}
-->
</style>
<script type="text/javascript">
		function setFormWidth(){
			var width = _getTableWidth()-16;
			var total = parseInt(width/260);
			var addWidth = parseInt(width/total);
			addWidth = addWidth < 260?260:addWidth;
			$("#searchUl li").width(addWidth);
		}
		function contentResize(){
			if(cacheChartResult != null){
				createReport(cacheChartResult);
			}
			var display = $("#detailTableDiv_parent").css("display");
			if(display == 'block'){
				$("#detail_table").jqGrid('setGridWidth',_getTableWidth());
			}
			setFormWidth();
		}
		var goalLine = '<%=goalLine%>';//目标线
		var chart = null,searchParams = null,cacheChartResult = null,cacheTableResult;
		var initParams = ${params},historyCount = 1;
		$(document).ready(function(){
			$("#datepicker1").click(function(){WdatePicker({dateFmt:'yyyy-MM-dd'});});
			$("#datepicker2").click(function(){WdatePicker({dateFmt:'yyyy-MM-dd'});});
			$("#itemname").attr("readonly","readonly");
			$("#itemname").click(function(){
				var url = '${mfgctx}/common/defection-code-bom.htm';
		 		$.colorbox({href:url,iframe:true, innerWidth:700, innerHeight:400,
		 			overlayClose:false,
		 			title:"选择不良代码"
		 		});
			});
			$("#check_select").each(function(index,obj){
				$($(obj).find("option")[0]).html("全选");
				if($(obj).find("option").length == 1){
					$(obj).width(100);
				}
			});
			$("#inspection_select").each(function(index,obj){
				$($(obj).find("option")[0]).html("全选");
				if($(obj).find("option").length == 1){
					$(obj).width(100);
				}
			});
			createDetailTable();
			setParams(initParams);
			reportByParams(getParams());
			setFormWidth();
		});
		function setDefectionValue(objs){
			$("#itemname").val(objs[0].value);
		}
		function createReport(result){
			if(chart != null){
				try {
					chart.destroy();
					chart = null;
				} catch (e) {
					chart = null;
				}
			}
			var goalLines = [];
			if(result.group == 'rate'){
				var datas = result.series1.data;
				for(var i=0;i<datas.length;i++){
					goalLines.push(parseFloat(goalLine));
				}
			}
			$("#reportDiv").html("图表生成中,请稍候... ...");
			var remarks = [],hasShowGoalLine = false;
			setTimeout(function(){
				chart = new Highcharts.Chart({
					colors: ["red", "#E0B56C", "#DF5353", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
					 		"#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
					exporting : {
						enabled : false
					},
					chart: {
						renderTo: 'reportDiv'
					},
					credits: {
				         enabled: false
					},
					title: {
						text: result.title,
						style : {
							"font-weight":'bold',
							"color": 'black',
							"font-size": '20px'
						}
					},
					subtitle: {
						text: result.subtitle,
						y:33
					},
					plotOptions: {
						line: {
				            shadow : false,
				            lineWidth : 1,
				            dataLabels: {
				               enabled: true,
				               formatter : function(){
				            	   if(result.group == 'rate'){
				            		    if(this.point.remark){
				            		    	remarks.push(this.point);
				            		    }
				            		    return this.y;
								   }else{
										return this.y;
								   }
				               },
				               color:'black'
				            },
				            cursor : 'pointer',
							point : {
				            	events : {
					            	click : function(obj){
					            		if(result.group == 'number'){
					            			loadTableDataByDate(obj.point.date);
					            		}else{
					            			editRemarkByPoint(obj.point);
					            		}
					            	}
					            }
				            }
				        },
				        spline : {
				            shadow : false,
				            dashStyle : 'ShortDot',
				        	dataLabels : {
				        	   enabled: true,
				        	   x:40,
				               formatter : function(){
				            	   if(!hasShowGoalLine){
				            		   hasShowGoalLine = true;
				            		   return "<b>目标线" + this.y + "%</b>";
				            	   }else{
				            		   return '';
				            	   }
				               }
				        	},
				        	color : 'green'
				        }
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
//	 						y : 30,
//	 						x : -16,
//	 						rotation : -45,
							style : {
								"color": 'black'
							}
						}
					}],
					yAxis: [{
						title: {
							text: ""
						},
						gridLineWidth : 1,
						gridLineDashStyle : 'ShortDashDot',
						plotLines: [{
							value: 0,
							width: 1
						}],
						min : 0,
						max : result.group == 'rate'?result.max:null,
						labels : {
							formatter : function(){
								if(result.group == 'rate'){
									if(this.value>100){
										return '';
									}else{
										return this.value.toFixed(1) + "";
									}
								}else{
									return this.value;
								}
							},
							style : {
								"color": 'black'
							}
						}
					},{
						title: {
							text: ""
						},
						gridLineWidth : 1,
						gridLineDashStyle : 'ShortDashDot',
						plotLines: [{
							value: 0,
							width: 1
						}],
						labels : {
							formatter : function(){
								
							},
							style : {
								"color": 'black'
							}
						}
					}],
					tooltip: {
						formatter: function() {
							if(this.point.date){
								if(result.group == 'number'){
									return '<b>' + this.x + ' 不良数:</b>' + this.y;
								}else{
									return '<b>' + this.x + ' 单车缺陷数:</b>' + this.y + "<br/>单击编辑备注";
								}
							}else{
								return '目标线 <b>' + goalLine + "%</b>";
							}
						}
					},
					legend: {
						 align: 'right',
				         verticalAlign : 'top',
				         floating: true,
				         backgroundColor: '#FFFFFF',
				         x : -16,
				         y : 16
					},
					series: [{
						type : 'line',
						name: result.series1.name,
						data: result.series1.data
					},{
						type : 'spline',
						name: '目标线',
						marker: {
			                symbol: 'url(rl.png)'
			            },
						data: goalLines
					}]
				},function(chart){
					for(var i=0;i<remarks.length;i++){
						var point = remarks[i];
						var html = "<b>" + point.date + "</b><br/>" + point.remark;
						var title = point.date + " " + point.remark + "  双击可编辑";
						var left = point.plotX,top = point.plotY;
						var label = chart.renderer.text('', 90,100,true)
						.attr({ 
							zIndex: 1,
							text : '<div class="rate-remark" style="left:'+left+'px;top:'+top+'px;" title="'+title+'" id="'+point.date+'-remark">'+html+'</div>'
						})
						.add();
						var line = chart.renderer.text('', 90,100,true)
						.attr({ 
							zIndex: 1,
							text : '<div class="rate-remark-line" id="'+point.date+'-remark-line">&nbsp;</div>'
						})
						.add();
						$("#" + point.date + "-remark").ready(function(){
							var $obj = $("#" + point.date + "-remark");
							var position = $obj.position();
							if($.browser.msie){
								if($.browser.version==8.0){
									$obj.css("left",(position.left-$obj.width()+17) + "px");
									$obj.css("top",(position.top-85-$obj.height()) + "px");
								}else{
									$obj.css("top",(position.top-$obj.height()) + "px");
									$obj.css("left",(position.left-12) + "px");
								}
							}else{
								$obj.css("top",(position.top-$obj.height()) + "px");
								$obj.css("left",(position.left-12) + "px");
							}
							position = $("#" + point.date + "-remark").position();
							var $lineObj = $("#" + point.date + "-remark-line");
							$lineObj.height(30);
							$lineObj.css("top",position.top+$obj.height()+10);
							$lineObj.css("left",position.left+$obj.width()/2);
							$obj.bind("dblclick",function(){
								var point = chart.get(this.id.split("-remark")[0]);
								if(point){
									editRemarkByPoint(point);
								}
							});
						});
					}
				});
			},10);
		}
		//确定的查询方法
		function search(){
			reportByParams(getParams());
		}
		//根据参数获取数据
		function reportByParams(params){
			$.post("${mfgctx}/data-acquisition/data-acquisition-analyse/unquality-amount-trend-chart-datas.htm",params,function(result){
				if(result.error){
					alert(result.message);
				}else{
					searchParams = params;
					try {
						createReport(result);
					} catch (e) {
						alert(e.message);
					}
					if(result.group == 'rate'){
						$("#detailTableDiv_parent").css("display","none");
					}
					cacheChartResult = result;
					window.location = "#reportDiv";
					historyCount++;
				}
			},'json');
		}
		//显示方法
		function toggleSearchTable(obj){
			var display = $("#searchTable").css("display");
			if(display == 'block'){
				$("#searchTable").css("display","none");
				$(obj).html("<span><span>显示查询</span></span>");
			}else{
				$("#searchTable").css("display","block");
				$(obj).html("<span><span>隐藏查询</span></span>");
				window.location = "#btnDiv";
				historyCount++;
			}
		}
		
		//获取表单的值
		function getParams(){
			var params = {};
			$(":input","#searchDiv").each(function(index,obj){
				var jObj = $(obj);
				if(obj.name&&jObj.val()){
					if(obj.type=="radio"){
						if(obj.checked){
							params[obj.name] = jObj.val();
							if(obj.name=='params.group'&&jObj.attr("title")){
								params['params.groupName'] = jObj.attr("title");
							}
						}
					}else if(obj.type == 'select-one'){
						if(!obj.disabled&&jObj.val()){
							params[obj.name] = jObj.val();
						}
					}else{
						params[obj.name] = jObj.val();
					}
				}
			});
			return params;
		}
		
		function setParams(initParams){
			$(":input","#searchDiv").each(function(index,obj){
				var jObj = $(obj);
				if(obj.name&&initParams[obj.name]){
					if(obj.type=="radio"){
						if(jObj.val() == initParams[obj.name]){
							obj.checked = true;
							typeSelect(obj,jObj.val() + '_select');
						}
					}else if(obj.type == 'select-one'){
						jObj.val(initParams[obj.name]);
					}else{
						jObj.val(initParams[obj.name]);
					}
				}
			});
		}
		//创建表格
		var detailTable = null;
		function createDetailTable(){
			//数据格式
			$("#detail_table").jqGrid({
				mtype: "POST",
				postData : {},
				rownumbers : true,
				width : $("#btnDiv").width(),
				colNames:["生产日期",'制令号','产品型号','车间','采集点','采集时间','操作'], 
				colModel:[ 
	               {name:'produceDate',index:'batchNo',width:80,align:'center'}, 
	               {name:'planNo',index:'productModel',width:60,align:'center'}, 
	               {name:'modelSpecification',index:'modelSpecification',width:90,align:'center'}, 
	               {name:'workshop',index:'workshop',width:70,align:'center'}, 
	               {name:'inspectionPoint',index:'inspectionPoint',width:70,align:'center'}, 
	               {name:'inspectionDate',index:'inspectionDate',width:90,align:'center'}, 
	               {name:'planNo',index:'planNo',width:20,align:'center',formatter:function(cellvalue,options,rowObj){
	            	   var url = "${ascendctx}/load-config/ascend-search.htm?produceNO=" + cellvalue;
	            	   return '<a href="' + url + '" style="cursor:pointer;" title="根据制令号追溯">追溯</a>';
	               }}
		        ],
			    multiselect: false,
			   	autowidth: true,
				forceFit : true,
			   	shrinkToFit: true,
				viewrecords: true, 
				sortorder: "desc",
				gridComplete : function(){}
			});
			window.location = "#detailTableDiv_parent";
			historyCount++;
		}
		//根据时间加载表格数据
		var hisDate = null;
		function loadTableDataByDate(date){
			if(cacheTableResult&&date==hisDate){
				
			}else if(searchParams){
				$("#detailTableDiv_parent").css("display","block");
				$("#detail_table").jqGrid('setGridWidth',_getTableWidth());
				window.location.href = "#detailTableDiv_parent";
				historyCount++;
				searchParams["params.inspectionDate_equals_date"] = date;
				$("#detail_table")[0].p.postData = searchParams;
				$("#detail_table").jqGrid("setGridParam",{url:"${mfgctx}/data-acquisition/data-acquisition-analyse/unquality-trend-table-datas.htm"}).trigger("reloadGrid");
			}else{
				alert("操作失败,查询参数为空!");
			}
		}
		//统计对象改变的方法
		function typeSelect(obj,selectId){
			$(".typeSelect").attr("disabled",true);
			$("#" + selectId).attr("disabled",false);
		}
		//重置查询条件的方法
		function formReset(){
			typeSelect($("#inspection_select_radio")[0],"inspection_select");
		}
		//返回
		function goToBack(){
			window.history.go(-historyCount);
		}
		
		//编辑备注
		var remarkShowInfo = "在此添加备注...";
		function editRemarkByPoint(point){
			window.selPoint = point;
			var html = '<div class="opt-body"><div class="opt-btn" style="width:400px;line-height:30px;"><button class="btn" type="button" onclick="saveRateRemark();"><span><span>保存</span></span></button>&nbsp;&nbsp;<button class="btn" type="button" onclick="javascript:$(\'#inputRemark\').val(\'\').focus();"><span><span>清除</span></span></button></div>';
			html += '<form id="remarkForm"><div style="width:100%;height:100%;padding-top:10px;text-align:center;"><textarea name="remark" class="{maxlength:255}" id="inputRemark" rows=6 style="width:95%;">'+(point.remark?point.remark:'')+'</textarea><input type="hidden" name="targetDate" value="'+point.date+'"/></div></form>';
			html += '</div>';
			$.colorbox({
				title : '编辑'+point.date+'的备注',
				html:html,
				height:200
			});
			$("#remarkForm").ready(function(){
				var val = $("#inputRemark").val();
				if(!val){
					$("#inputRemark").val(remarkShowInfo)
					.css("color","gray");
				}
				$("#inputRemark")
				.bind("focus",function(){
					var val = $(this).val();
					if(val == remarkShowInfo){
						$(this).val("")
						.css("color","");
					}
				}).bind("blur",function(){
					var val = $(this).val();
					if(!val){
						$(this).val(remarkShowInfo)
						.css("color","gray");
					}
				});
				$("#remarkForm").validate({});
			});
		}
		
		function saveRateRemark(){
			if($("#remarkForm").valid()){
				var params={};
				$(":input","#remarkForm").each(function(index,obj){
					params['params.' + obj.name] = $(obj).val();
				});
				if(params["params.remark"] == remarkShowInfo){
					params["params.remark"] = '';
				}
				$.colorbox.close();
				$("#message").html("正在执行操作,请稍候... ...");
				$.post("${mfgctx}/manu-analyse/save-unquality-trend-rate-remark.htm", params, function(result) {
					if(result&&result.error){
						alert(result.message);
					}else{
						var datas = cacheChartResult.series1.data;
						for(var i=0;i<datas.length;i++){
							if(params["params.targetDate"]==datas[i].date){
								datas[i].remark = params["params.remark"];
								break;
							}
						}
						createReport(cacheChartResult);
					}
				},'json');
			}
		}
	</script>