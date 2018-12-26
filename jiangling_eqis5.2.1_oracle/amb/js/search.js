//显示/取消查询的DIV区域
var buttonObj;
//为body增加点击事件时 用此属性做标记 (点击查询按钮时不隐藏查询框)
var clickSearchMethod;
function removeSearchBox(initializ){
	if($('#search_shade').length>0){
		$('#search_shade').removeClass('searchOver');
		$('#search_box').removeClass('searchBox');
		$('#search_box').css('display', 'none');		
		contentResize();
		if($("button[onclick^='showSearchDIV'] span span").html()=="取消查询"){
			$("button[onclick^='showSearchDIV'] span span").html("查询");
		}
	}	
}
function showSearchDIV(obj){
	if($("#searchArea").length<1){
		alert("请在列表设置中启用查询功能！");
		return;
	}
	
	clickSearchMethod = "clickSearc";
	var containerSearchId = $("#containerSearchInput").val();
	if(containerSearchId!="false"){//嵌入式
		
		if($($(obj).children().children()).html()=="取消查询"){
			var a1=$($(obj).children().children()).html("查询");
			removeSearchBox();
			return;
		}
		
		var a2=$($(obj).children().children()).html("取消查询");
	
		//消除页面滚动条
	//	$('div.ui-layout-center').css('overflow-y','hidden');
		$('#search_box').css('roll', 'block');
		$('#search_box').css('display', 'block');
		$('#search_header').css('display', 'none');		
		$("#search_box").css("width",$('#opt-content').width()+12);
		$('#opt-content').css('height',$('.opt-body').height()-55);
		$('#search_box').css('min-width', 820);
		fixedToInputWidth();
		if($('#fixedSearchSignInput').val()<=0){$("#searchZoon").css("display", "block");}//没有固定查询时显示高级查询
		if($('#parameter_Table').height()==0){
			contentResizeForAdvanced();
		}else{
			contentResizeForFixed();
		}
	}else{//弹框式
		$('#search_box').addClass('searchBox');
		$('#search_box').css('display', 'block');
		$('#search_header').css('display', 'block');
		$('#search_shade').addClass('searchOver');
		if($('#fixedSearchSignInput').val()<=0){$("#searchZoon").css("display", "block");}//没有固定查询时显示高级查询
		$('#search_box').css('width', $('#opt-content').width()*4/5);
		$('#search_box').css('min-width', 820);
		$('#search_box').css('margin-left', -$("#search_box").width()/2);
		fixedToInputWidth();
	}
}
//固定查询INPUT宽度设定
function fixedToInputWidth(){
	var w = $('#search_box').width()-450;
	$(".searchInputClass").css("width",w/4);
	$(".searchInputClass").css("min-width",84);	
}
//固定查询到自定义查询切换
function fixedToDynamic(){
	$("#fixedSearchZoon").css("display", "none");
	$("#searchZoon").css("display", "block");
	if($("#containerSearchInput").val()!="false"){
		contentResizeForAdvanced();
	}
}
//自定义查询到固定查询切换
function dynamicToFixed(){
	$("#fixedSearchZoon").css("display", "block");
	$("#searchZoon").css("display", "none");
	if($("#containerSearchInput").val()!="false"){
		contentResizeForFixed();
	}
}
//固定查询清除参数
function clearParameter(){
	var parameterDateInputs = $("input[class='searchInputClass hasDatepicker']");
	var parameterInputs = $("input[class='searchInputClass']");
	$.each(parameterInputs,function(i){
		$(parameterInputs[i]).attr("value","");
	});
	$.each(parameterDateInputs,function(i){
		$(parameterDateInputs[i]).attr("value","");
	});
	var parameterSelects = $("select[class='searchInputClass']");
	$.each(parameterSelects,function(i){
		var selectOptions = $(parameterSelects[i]).children();
		$.each(selectOptions,function(i){
			if($(selectOptions[i]).attr("value") == ""){
				$(selectOptions[i]).attr("selected","selected");
			}
		});
	});	
}
//获取并整理固定查询的参数(2011年11月29)
function fixedSearchDealWithParameter(type){
	var parameterInputs = $(".searchInputClass");
	var searchString = "[";
	$.each(parameterInputs,function(i){
		var currentValue = $(parameterInputs[i]).attr("value");
		if(typeof(currentValue) != 'undefined' && currentValue != ""){
			//radio的过滤
			var currentRadio = $(parameterInputs[i]).attr("type");
			var radioChecked = $(parameterInputs[i]).attr("checked");
			if(currentRadio == "radio" && radioChecked != true){
				return true;
			}
			
			var currentDataType = $(parameterInputs[i]).attr("dataType");
			var currentName = $(parameterInputs[i]).attr("name");
			searchString = searchString + '{"leftBracket":"",';
			searchString = searchString + '"propName":"' + currentName + '",';
			if((currentDataType.indexOf('ENUM')>=0)&& currentValue != ""){
					searchString = searchString + '"optSign":"=",';
					searchString = searchString + '"dataType":"' + currentDataType + '",';
					searchString = searchString + '"enumName":"' + $(parameterInputs[i]).attr("enumName")+ '",';
				}else{
					searchString = searchString + '"enumName":"",';
			}
			searchString = searchString + '"propValue":"' + currentValue + '",';
			searchString = searchString + '"rightBracket":"",';
			if(currentDataType.indexOf('STRING')>=0 && currentValue != ""){
				searchString = searchString + '"optSign":"like",';
				searchString = searchString + '"dataType":"' + currentDataType + '",';
			}else if((currentDataType.indexOf('INTEGER')>=0 ||(currentDataType.indexOf('LONG')>=0))&& currentValue != ""){
				searchString = searchString + '"optSign":"=",';
				searchString = searchString + '"dataType":"' + currentDataType + '",';
			}else if((currentDataType.indexOf('DOUBLE')>=0 ||(currentDataType.indexOf('NUMBER')>=0) ||(currentDataType.indexOf('AMOUNT')>=0))&& currentValue != ""){
				searchString = searchString + '"optSign":"=",';
				searchString = searchString + '"dataType":"' + currentDataType + '",';
			}else if((currentDataType.indexOf('BOOLEAN')>=0 )&& currentValue != ""){
				searchString = searchString + '"optSign":"=",';
				searchString = searchString + '"dataType":"' + currentDataType + '",';
			}else if((currentDataType.indexOf('TIME')>=0 || currentDataType.indexOf('DATE')>=0) && currentDataType.split("-")[1] == "first" && currentValue != ""){
				searchString = searchString + '"optSign":">=",';
				searchString = searchString + '"dataType":"' + currentDataType.split('-')[0] + '",';
			}else if((currentDataType.indexOf('TIME')>=0 || currentDataType.indexOf('DATE')>=0) && currentDataType.split("-")[1] == "second" && currentValue != ""){
				searchString = searchString + '"optSign":"<=",';
				searchString = searchString + '"dataType":"' + currentDataType.split('-')[0] + '",';
			}
			searchString = searchString + '"joinSign":"and"}';
			if(i != parameterInputs.length) searchString = searchString + ',';
		 }
		});
	searchString = searchString + "]";
	if(searchString.length == 2 ){
		$("#search_Parameters").attr("value","");
	}else{
		$("#search_Parameters").attr("value", searchString.substring(0, searchString.lastIndexOf("}")+1)+"]");
	} 
}
//固定查询提交
function fixedSearchSubmit(id, url){ 
	var submitForm = getSubmitFormId();
	$('#__search_parameters').remove();//移除上一个页面的input以保障不影响当前页面查询后返回状态不变
	fixedSearchDealWithParameter();
	var searchParameters = $("#search_Parameters").val();
	var parameterChild = $("#"+submitForm).children();
	$.each(parameterChild, function(i){
		if(typeof($(parameterChild[i]).attr("name")) != 'undefined' && $(parameterChild[i]).attr("name").toLowerCase().indexOf("pageno") != -1){
			$(parameterChild[i]).attr("value", 1);
		}
	});
	creatSearchParametersInput(submitForm,searchParameters);
	
	var body = getBodyByTableId(id);
	var stateForm = getStateForm(body, id);
	var children = $(stateForm).children();
	if(children.length > 0){
		$.each(children, function(i){
			if($(children[i]).attr("id") == "__search_parameters"){
				$(children[i]).attr("value", searchParameters);
			}else if($(children[i]).attr("id") != "__search_parameters"){	
				$(stateForm).append("<input type='hidden' id='__search_parameters' searchType='fixed_search' value='"+searchParameters+"'/>");
			}
		});
	}else{
		$(stateForm).append("<input type='hidden' id='__search_parameters' searchType='fixed_search' value='"+searchParameters+"'/>");
	}
	//获得form中的input值
	var obj = getValueFromForm(submitForm);
	jQuery("#"+id).jqGrid('setGridParam',{url:encodeURI(url),mtype:'post',postData:obj,page:1}).trigger("reloadGrid");
	//removeSearchBox();
}
function fixedSearchCallBack(){
	
}
function _optChange(obj){
	var value = $(obj).attr('value');
	if("is null" == value || "is not null" == value){
		$("#condition").attr("value", "");
		$("#condition").attr("disabled", "disabled");
		$("#condition").css('background-color', '#f5f5f5');
		
	}else{
		$("#condition").attr("disabled", "");
		$("#condition").css('background-color', '');
	}
}
//根据类型来确定运算符及输入框
function changeField(){
	var searchParameters = $("#search_name").val().split("-");
	if(searchParameters.length > 1){
		if(searchParameters[0] == 'STRING'){
			$.each(jsonFields, function(i){
				if(jsonFields[i].enName == searchParameters[1]){
					var defaultValues = jsonFields[i].defaultValues;
					if(defaultValues!=null&&defaultValues.length>0){
						var options = "";
						$.each(defaultValues, function(i){
							options = options + "<option value=\"" + defaultValues[i].value + "\">" + defaultValues[i].name + "</option>";
						});
						$("#num_sign").html('<option value="like">包含</option>');
						$("#search_value").html('<select id="condition">' + options + '</select>');
					}else{
						$("#num_sign").html('<option value="=">等于</option><option value="like">包含</option><option value="not like">不包含</option><option value="is null">为空</option><option value="is not null">不为空</option>');
						$("#search_value").html('<input id="condition" type="text" onkeyup="validateString(this);" style="width:160px"/>');
					}
				}
			});
		}else if(searchParameters[0] == 'ENUM' || searchParameters[0] == 'BOOLEAN'){
			$.each(jsonFields, function(i){
				if(jsonFields[i].enName == searchParameters[1]){
					var defaultValues = jsonFields[i].defaultValues;
					var options = "";
					$.each(defaultValues, function(i){
						options = options + "<option value=\"" + defaultValues[i].value + "\">" + defaultValues[i].name + "</option>";
					});
					$("#num_sign").html('<option value="=">等于</option><option value="is null">为空</option><option value="is not null">不为空</option>');
					$("#search_value").html('<select id="condition"><option value=\"\"></option>' + options + '</select>');
				}
			});
		}else if(searchParameters[0] == 'NUMBER' || searchParameters[0] == 'AMOUNT' || searchParameters[0] == 'DOUBLE'){
			$.each(jsonFields, function(i){
				if(jsonFields[i].enName == searchParameters[1]){
					var defaultValues = jsonFields[i].defaultValues;
					if(defaultValues!=null&&defaultValues.length > 0){
						var options = "";
						$.each(defaultValues, function(i){
							options = options + "<option value=\"" + defaultValues[i].value + "\">" + defaultValues[i].name + "</option>";
						});
						$("#num_sign").html('<option value="=">等于</option>');
						$("#search_value").html('<select id="condition">' + options + '</select>');
					}else{
						$("#num_sign").html('<option value="=">等于</option><option value=">">大于</option><option value="<">小于</option><option value=">=">大于等于</option><option value="<=">小于等于</option><option value="<>">不等于</option><option value="is null">为空</option><option value="is not null">不为空</option>');
						$("#search_value").html('<input id="condition" type="text" onkeyup="value=value.replace(/[^0-9\.]/g,\'\');" style="width:160px"/>');
					}
				}
			});
		}else if(searchParameters[0] == 'INTEGER' || searchParameters[0] == 'LONG'){
			$.each(jsonFields, function(i){
				if(jsonFields[i].enName == searchParameters[1]){
					var defaultValues = jsonFields[i].defaultValues;
					if(defaultValues!=null&&defaultValues.length > 0){
						var options = "";
						$.each(defaultValues, function(i){
							options = options + "<option value=\"" + defaultValues[i].value + "\">" + defaultValues[i].name + "</option>";
						});
						$("#num_sign").html('<option value="=">等于</option>');
						$("#search_value").html('<select id="condition">' + options + '</select>');
					}else{
						$("#num_sign").html('<option value="=">等于</option><option value=">">大于</option><option value="<">小于</option><option value=">=">大于等于</option><option value="<=">小于等于</option><option value="<>">不等于</option><option value="is null">为空</option><option value="is not null">不为空</option>');
						$("#search_value").html('<input id="condition" type="text" onkeyup="value=value.replace(/[^0-9]/g,\'\');" style="width:160px"/>');
					}
				}
			});
		}else if(searchParameters[0] == 'DATE'){
			$.each(jsonFields, function(i){
				if(jsonFields[i].enName == searchParameters[1]){
					var defaultValues = jsonFields[i].defaultValues;
					if(defaultValues != null && defaultValues.length > 0){
						var options = "";
						$.each(defaultValues, function(i){
							options = options + "<option value=\"" + defaultValues[i].value + "\">" + defaultValues[i].name + "</option>";
						});
						$("#num_sign").html('<option value="=">等于</option>');
						$("#search_value").html('<select id="condition">' + options + '</select>');
					}else{
						$("#num_sign").html('<option value="=">等于</option><option value=">">大于</option><option value="<">小于</option><option value=">=">大于等于</option><option value="<=">小于等于</option><option value="is null">为空</option><option value="is not null">不为空</option>');
						var html='<input id="condition" type="text" readonly="readonly"/>';
						html=html+'<script type="text/javascript">'
							           +'$("#condition").datepicker({'
									    +'  changeMonth:true,'
									     +' changeYear:true'
							           +'});'                                       
					                +'</script>';
						$("#search_value").html(html);
					}
				}
			});
		}else if(searchParameters[0] == 'TIME'){
			$.each(jsonFields, function(i){
				if(jsonFields[i].enName == searchParameters[1]){
					var defaultValues = jsonFields[i].defaultValues;
					if(defaultValues != null && defaultValues.length > 0){
						var options = "";
						$.each(defaultValues, function(i){
							options = options + "<option value=\"" + defaultValues[i].value + "\">" + defaultValues[i].name + "</option>";
						});
						$("#num_sign").html('<option value="=">等于</option>');
						$("#search_value").html('<select id="condition">' + options + '</select>');
					}else{
						$("#num_sign").html('<option value="=">等于</option><option value=">">大于</option><option value="<">小于</option><option value=">=">大于等于</option><option value="<=">小于等于</option><option value="is null">为空</option><option value="is not null">不为空</option>');
						var html='<input id="condition" type="text" readonly="readonly"/>';
						html=html+'<script type="text/javascript">'
							           +'$("#condition").datetimepicker({'
									    +'"dateFormat":"yy-mm-dd",'
										 +'      changeMonth:true,'
										  +'     changeYear:true,'
										  +'     showSecond: false,'
											+'	showMillisec: false,'
											+'	"timeFormat": "hh:mm"'
							           +'});'
                                       +'</script>';
						$("#search_value").html(html);
					}
				}
			});
		}
	}else{
		var lBracket = $("#left_bracket").children();
		for(var i = 0; i < lBracket.length; i++){
			if($(lBracket[i]).val() == ""){
				$(lBracket[i]).attr("selected","selected");
				break;
			}
		}
		var rBracket = $("#right_bracket").children();
		for(var i = 0; i < rBracket.length; i++){
			if($(rBracket[i]).val() == ""){
				$(rBracket[i]).attr("selected","selected");
				break;
			}
		}
		var relSign = $("#rel_sign").children();
		for(var i = 0; i < relSign.length; i++){
			if($(relSign[i]).val() == ""){
				$(relSign[i]).attr("selected","selected");
				break;
			}
		}
		$("#num_sign").html('');
    	var searchValueInput = "<input type='text' style='width:160px' />";
	    $("#search_value").html(searchValueInput);
	}
}
//添加参数=================================================================================1
function addParameter(){
	if(typeof($('#condition').attr('value')) == 'undefined' || $('#condition').attr('value') == ''){
		var value = $('#num_sign').attr('value');
		if("is null" == value || "is not null" == value){
		}else{
			_showMessage("_query_smessage", "请输入条件");
			return;
		}
	}
	var tr = '<tr class="str">'
		+'<td >'+ getHiddenInput('leftBrackets', $('#left_bracket').val()) + $('#left_bracket option:selected').text() +'</td>'
		+'<td >'+ getHiddenInput('searchNames', $('#search_name').val()) + $('#search_name option:selected').text() +'</td>'
		+'<td >'+ getHiddenInput('numSigns', $('#num_sign').val()) + $('#num_sign option:selected').text() +'</td>';
	if($('#search_name').val().indexOf("ENUM-")==0 ||
			$('#search_name').val().indexOf("BOOLEAN-")==0){
		tr = tr +'<td >'+ getHiddenInput('searchValues', $('#condition').val()) + getEsc($('#condition  option:selected').text()) +'</td>';
	}else{
		if(getEsc($('#condition  option:selected').text()) != ""){//键值对  选项组  接口
			tr = tr +'<td >'+ getHiddenInput('searchValues', $('#condition').val()) + getEsc($('#condition  option:selected').text()) +'</td>';
		}else{
			tr = tr +'<td >'+ getHiddenInput('searchValues', $('#condition').val()) + getEsc($('#condition').attr('value')) +'</td>';
		}
	}
	tr = tr +'<td >'+ getHiddenInput('rightBrackets', $('#right_bracket').val()) + $('#right_bracket option:selected').text() +'</td>'
		+'<td >'+ getHiddenInput('relSigns', $('#rel_sign').val()) + $('#rel_sign option:selected').text() +'</td>'
		+'<td ><a name="deleteA" class="delete" href="#">删除&nbsp;&nbsp;</a></td>'
		+'<tr>';
	
	$(tr).insertAfter($("#search_Table tbody tr:first-child")).find(".delete").click(function(){
		$(this).parent().parent().remove();
	});
	var lBracket = $("#left_bracket").children();
	for(var i = 0; i < lBracket.length; i++){
		if($(lBracket[i]).val() == ""){
			$(lBracket[i]).attr("selected","selected");
			break;
		}
	}
	var rBracket = $("#right_bracket").children();
	for(var i = 0; i < rBracket.length; i++){
		if($(rBracket[i]).val() == ""){
			$(rBracket[i]).attr("selected","selected");
			break;
		}
	}
	var relSign = $("#rel_sign").children();
	for(var i = 0; i < relSign.length; i++){
		if($(relSign[i]).val() == ""){
			$(relSign[i]).attr("selected","selected");
			break;
		}
	}
}
//清空查询参数==============================================================================
function resetParameter(){
	//清除记录
	var trs = $("#search_Table").children().children();
	for(var i = 0; i < trs.length; i++){
		if(typeof($(trs[i]).find(".delete")) != 'undefined'&&$(trs[i]).find(".delete").length>0){
			if($(trs[i]).find(".delete").text() == $($("a[name='deleteA']")[0]).text()){
				$(trs[i]).remove();
			}
		}
	}
	//还原状态
	var sName = $("#search_name").children();
	for(var i = 0; i < sName.length; i++){
		if($(sName[i]).val() == ""){
			$(sName[i]).attr("selected","selected");
			break;
		}
	}
	var lBracket = $("#left_bracket").children();
	for(var i = 0; i < lBracket.length; i++){
		if($(lBracket[i]).val() == ""){
			$(lBracket[i]).attr("selected","selected");
			break;
		}
	}
	var rBracket = $("#right_bracket").children();
	for(var i = 0; i < rBracket.length; i++){
		if($(rBracket[i]).val() == ""){
			$(rBracket[i]).attr("selected","selected");
			break;
		}
	}
	var relSign = $("#rel_sign").children();
	for(var i = 0; i < relSign.length; i++){
		if($(relSign[i]).val() == ""){
			$(relSign[i]).attr("selected","selected");
			break;
		}
	}
	$("#num_sign").html('');
	 var searchValueInput = "<input type='text' style='width:160px' />";
	 $("#search_value").html(searchValueInput);
}
//----------------------------------------------以上没有逻辑问题----------------------------------------------
/*执行查询======================================================================================*/
function doSearch(id, url){
	var submitForm = getSubmitFormId();
	$('#__search_parameters').remove();//移除上一个页面的input以保障不影响当前页面查询后返回状态不变
	submitParameter();
	//TODO 可能需要对查询条件的格式检查
	var searchParameters = $("#search_Parameters").val();
	var parameterChild = $("#"+submitForm).children();
	$.each(parameterChild, function(i){
		if(typeof($(parameterChild[i]).attr("name")) != 'undefined' && $(parameterChild[i]).attr("name").toLowerCase().indexOf("pageno") != -1){
			$(parameterChild[i]).attr("value", 1);
		}
	});
	
	//查询点击确定按钮后页面上若有id=___searchParameters的input,则只替换value值,否则追加一个id=___searchParameters的input
	if($("#___searchParameters").val()==undefined){
		$("#"+submitForm).append("<input type='hidden' name='searchParameters' value='"+searchParameters+"' id='___searchParameters'/>");
	}else{
		$("#___searchParameters").attr("value",searchParameters);
	}
	
	
	
	//var body = getBodyByTableId(id);
	//var stateForm = getStateForm(body, id);
	//var children = $(stateForm).children();
	//if(children.length > 0){
	//	$.each(children, function(i){
	//		if($(children[i]).attr("id") == "__search_parameters"){
	//			$(children[i]).attr("value", searchParameters);
	//		}else if($(children[i]).attr("id") != "__search_parameters"){
	//			creatSearchParametersInput(submitForm,searchParameters);
	//		}
	//	});
	//}else{
	//	creatSearchParametersInput(submitForm,searchParameters);
	//}
	//获得form中的input值
	var obj = getValueFromForm(submitForm);
	
	jQuery("#"+id).jqGrid('setGridParam',{url:encodeURI(url),mtype:'post',postData:obj,page:1}).trigger("reloadGrid"); 
	var containerSearchId = $("#containerSearchInput").val();
	if(containerSearchId=="false"){//弹出式
	 removeSearchBox();
	}	
}
/*---------------------------------------------------------
						辅助的JS方法
  ---------------------------------------------------------*/
//验证字符参数
function validateString(obj){
	var value = $(obj).val().replace(' ', '');
	if(value.length<=0 || value.length>20){
		_showMessage("_query_smessage", "条件不能为空且长度不大20");
		$(obj).attr("value", value.substring(0,20));
	}else{
		var b;
		if((b=value.indexOf("{"))>=0 || (b=value.indexOf("}"))>=0 || (b=value.indexOf("\'"))>=0 || (b=value.indexOf("\""))>=0){
			_showMessage("_query_smessage", "条件不能包含空格、单引号、双引号和大括号");
			$(obj).attr("value", value.substring(0, b));
		}
	}
}
//生成隐藏的值存放域
function getHiddenInput(name,value){
	return '<input type="hidden" name="'+name+'" value="'+value+'"/>';
}
//boolean和enum生成隐藏的input
function _createInput(id,type,name,value,enumName){
	var index = id.substring(10,id.length);
	$("#hideInput_"+index).html('<input class="searchInputClass" type="hidden" id="'+id+'" dataType= "'+type+'" name="'+name+'" enumName="'+enumName+'" value="'+value+'"/>');
}

//替换关键字
function getEsc(str){
	for(var i=0;i<str.length ;i++){
		str = str.replace("<","&lt;");
		str = str.replace(">","&gt;");
		str = str.replace("'","&apos;");
		str = str.replace('"',"&quot;");
	}
	return str;
}
//提交查询参数
function submitParameter(){
	var lbs = $("input[name='leftBrackets']");
	var sns = $("input[name='searchNames']");
	var nss = $("input[name='numSigns']");
	var svs = $("input[name='searchValues']");
	var rbs = $("input[name='rightBrackets']");
	var rss = $("input[name='relSigns']");
	var searchString = "[";
	for(var i=0; i<sns.length; i++){
		if(i != 0) searchString = searchString + ',';
		searchString = searchString + '{"leftBracket":"' + $(lbs[i]).val() + '",';
		searchString = searchString + '"propName":"' + $(sns[i]).val().split('-')[1]+ '",';
		searchString = searchString + '"enumName":"' + $(sns[i]).val().split('-')[2]+ '",';
		searchString = searchString + '"optSign":"' + $(nss[i]).val() + '",';
		searchString = searchString + '"propValue":"' + $(svs[i]).val() + '",';
		searchString = searchString + '"rightBracket":"' + $(rbs[i]).val() + '",';
		searchString = searchString + '"joinSign":"' + $(rss[i]).val() + '",';
		searchString = searchString + '"dataType":"' + $(sns[i]).val().split('-')[0]+ '"}';
	}
	searchString = searchString + "]";
	if(searchString.length == 2) searchString = "";
	$("#search_Parameters").attr("value", searchString);
}
//通用ajaxAnywhere提交
function ajaxSubmit(form, url, zoons, ajaxCallback){
	var formId = "#"+form;
	if(url != ""){
		$(formId).attr("action", url);
	}
	ajaxAnywhere.formName = form;
	ajaxAnywhere.getZonesToReload = function() {
		return zoons;
	};
	ajaxAnywhere.onAfterResponseProcessing = function () {
		if(typeof(ajaxCallback) == "function"){
			ajaxCallback();
		}
	};
	ajaxAnywhere.submitAJAX();
}
//通用消息提示
function _showMessage(id, msg){
	if(msg != ""){
		$("#"+id).html(msg);
	}
	$("#"+id).show("show");
	//setTimeout('$("#'+id+'").html("");',3000);
	setTimeout('$("#'+id+'").hide("show");',3000);
}
//工具方法1
function getBodyByTableId(id){
	var node = document.getElementById(id);
    var found = false;
    while (!found) {
        if (node.nodeName == 'BODY') {
            found = true;
            return node;
        }
        node = node.parentNode;
    }
    return null;
}
//工具方法2
function getStateForm(body, id){
	var stateForm = $("form[name='" + id + "_state_form']");
	if(stateForm.length == 0){
		$(body).append("<form id =\"" + id + "_state_form\" name=\"" + id + "_state_form\"></form>");
		stateForm = $("form[name='" + id + "_state_form']");
	}
	return stateForm;
}
//页面解析后台返回的json格式的field集合
var jsonFields;
function parseFieldJson(){
	jsonFields = eval($("#field_list").val());
	var optionsStr = "<option value=\"\" selected=\"selected\">请选择</option>";
	$.each(jsonFields, function(i){
		optionsStr = optionsStr + "<option value=\"" + jsonFields[i].propertyType+ "-" + jsonFields[i].enName+"-" + jsonFields[i].enumName + "\">" + jsonFields[i].chName + "</option>";
	});
	$("#search_name").html(optionsStr);
	 var searchValueInput = "<input type='text' style='width:160px' />";
	$("#search_value").html(searchValueInput);
}
/*---------------------------------------------------------
				       调用删除前获得查询参数
  ---------------------------------------------------------*/

//自定义查询
function customSearch(id, submitForm, url){
	$('body').append("<input type='hidden' id='search_Parameters' />");
	fixedSearchDealWithParameter('customSearch');
	var searchParameters = $("#search_Parameters").val();
	var parameterChild = $("#"+submitForm).children();
	$.each(parameterChild, function(i){
		if(typeof($(parameterChild[i]).attr("name")) != 'undefined' && $(parameterChild[i]).attr("name").toLowerCase().indexOf("pageno") != -1){
			$(parameterChild[i]).attr("value", 1);
		}
	});
	$("#"+submitForm).append("<input type='hidden' name='searchParameters' value='"+searchParameters+"'/>");
	var body = getBodyByTableId(id);
	var stateForm = getStateForm(body, id);
	var children = $(stateForm).children();
	if(children.length > 0){
		$.each(children, function(i){
			if($(children[i]).attr("id") == "__search_parameters"){
				$(children[i]).attr("value", searchParameters);
			}else if($(children[i]).attr("id") != "__search_parameters"){	//添加searchType属性避免高级查询查询后生成的input状态被固定查询获取
				$(stateForm).append("<input type='hidden' id='__search_parameters' searchType='fixed_search' value='"+searchParameters+"'/>");
			}
		});
	}else{
		//添加searchType属性避免高级查询查询后生成的input状态被固定查询获取 使固定查询保存上一次查询状态出错
		$(stateForm).append("<input type='hidden' id='__search_parameters' searchType='fixed_search' value='"+searchParameters+"'/>");
	}
	jQuery("#"+id).jqGrid('setGridParam',{url:encodeURI(url+"?searchParameters="+searchParameters),page:1}).trigger("reloadGrid");
}
//自定义查询
function customSearchGetJson(){
	$('body').append("<input type='hidden' id='search_Parameters' />");
	fixedSearchDealWithParameter('customSearch');
	var searchParameters = $("#search_Parameters").val();
	return searchParameters;
}
//获得form中的input值
function getValueFromForm(submitForm){
	var object = {};
	var elements = $("#"+submitForm).children('input');
	var lengt = elements.length;
	for(var i=0; i<lengt; i++){
		var name = $(elements[i]).attr("name");
		var value =  $(elements[i]).attr("value");
		object[name] = value;
	}
	return object;
}
//给searchParameters赋值
function creatSearchParametersInput(submitForm,searchParameters){
	if($("#___searchParameters").val()==undefined){
		$("#"+submitForm).append("<input type='hidden' id='___searchParameters' name='searchParameters' value='"+searchParameters+"'/>");
	}else{
		$("#___searchParameters").attr("value",searchParameters);
	}
}
//获得formId
function getSubmitFormId(){
	var submitFormIdfromTag = $("#submitForm").val(); 
	if(submitFormIdfromTag==null||submitFormIdfromTag==""||submitFormIdfromTag==undefined){
		var submitFormIdFromPage = $($("#searchArea").parent('form')).attr("id");
		return submitFormIdFromPage;
	}
	return submitFormIdfromTag;
}
//移动查询
function moveSearc(){
	var windowHeigth = $(window).height();
	//事件源 为除查询外的其它按钮添加事件来隐藏查询框
	$(".opt-body").click(function(event){
		var e = event||window.event;
		if(e.target.className=="btn"&&clickSearchMethod!="clickSearc"){
			removeSearchBox();
		}
		//$(".opt-body").css("height",windowHeigth);//IFRAME内容区高度
		//$("#opt-content").css("height",windowHeigth);
		clickSearchMethod="";
	});
	var body = $("body");
		changePosition();
}
//改变查询框的位置
function changePosition(){
	if($("#containerSearchInput").val()!="false"&&$("#containerSearchInput").val()!=undefined){//嵌入式
		var searchInformationDiv=$('#search_box');
		//if($(parent.$('body').find('iframe')).attr("id")=="myIFrame"){
		//	searchInformationDiv.css('left',0);
		//	searchInformationDiv.css('top',35);
			
		//}else{
			//var searchDiv=$('div.ui-layout-center');
			//var targetPositionLeft = searchDiv.css('left');
			//var targetPositionTop = searchDiv.css('top');
			//if(typeof(targetPositionLeft)=='undefined'||typeof(targetPositionTop)=='undefined'){
			//	return;
			//}
			//targetPositionLeft = parseInt(targetPositionLeft);
			//targetPositionTop = parseInt(targetPositionTop.substring(0,targetPositionTop.length-2))+35;
			//searchInformationDiv.css('left',targetPositionLeft);
			//searchInformationDiv.css('top',targetPositionTop);
			if(typeof(targetPositionLeft)=='undefined'||typeof(targetPositionTop)=='undefined'){
				searchInformationDiv.css('left',0);
				searchInformationDiv.css('top',35);
			}else{
			var searchDiv=$('div.ui-layout-center');
			var targetPositionLeft = searchDiv.css('left');
			var targetPositionTop = searchDiv.css('top');
			targetPositionLeft = parseInt(targetPositionLeft);
			targetPositionTop = parseInt(targetPositionTop)+35;
			searchInformationDiv.css('left',targetPositionLeft);
			searchInformationDiv.css('top',targetPositionTop);
		}
		searchInformationDiv.css('position','absolute');
		searchInformationDiv.css('z-index','2');
	}
}
function becomeNode(searchContent){
	var body = $("body");
	searchContent = searchContent.replace("&lt;", "<");
	searchContent = searchContent.replace("&gt;", ">");
	body.append(searchContent);
}
$(document).ready(function(){
	if($("#searchArea").length<1)return;//没有启用查询
	var searchContent = $("#searchArea");
	if(searchContent.length<1)return;//没有启用查询
	becomeNode(searchContent.val());
	parseFieldJson();
	//moveSearc();
	
});

function initSearch(){
	var body= $("body");
	if(body.find("div[id='search_shade']").length>0){
		$("#search_shade").remove();
		$("#search_box").remove();
	}
	var searchContent = $("#searchArea");
	if(searchContent.length<1)return;//没有启用查询
	becomeNode(searchContent.val());
	parseFieldJson();
	//moveSearc();
}