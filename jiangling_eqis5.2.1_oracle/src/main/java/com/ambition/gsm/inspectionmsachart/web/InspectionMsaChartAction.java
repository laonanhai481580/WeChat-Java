package com.ambition.gsm.inspectionmsachart.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.beans.factory.annotation.Autowired;

import com.ambition.gsm.entity.GsmEquipment;
import com.ambition.gsm.entity.InspectionMsaplan;
import com.ambition.gsm.equipment.service.GsmEquipmentManager;
import com.ambition.gsm.inspectionmsachart.service.InspectionMsaChartManager;
import com.ambition.gsm.inspectionmsaplan.service.InspectionMsaplanManager;
import com.ambition.util.common.CommonUtil1;
import com.norteksoft.product.api.entity.Option;
import com.norteksoft.product.orm.Page;
import com.norteksoft.product.util.ContextUtils;
import com.norteksoft.product.util.PageUtils;
import com.norteksoft.product.web.struts2.CrudActionSupport;
import com.opensymphony.xwork2.ActionContext;

/**
 * 
 * 类名: InspectionMsaChartAction
 * <p>
 * amb
 * </p>
 * <p>
 * 厦门安必兴信息科技有限公司
 * </p>
 * <p>
 * 功能说明：检定三率表格ACTION
 * </p>
 * 
 * @author  张顺志
 * @version
 */

@Namespace("/gsm/inspectionMsa-chart")
@ParentPackage("default")
@Results({ @Result(name = CrudActionSupport.RELOAD, location = "inspectionMsa-chart", type = "redirectAction") })
public class InspectionMsaChartAction extends CrudActionSupport<InspectionMsaplan> { 
	private static final long serialVersionUID = 1L;
	private Long id;
	private String deleteIds;
	private JSONObject params;
	private Integer totalYear;
	private Integer beginMonth;
	private Integer endMonth;
	private InspectionMsaplan inspectionMsaplan;
	@Autowired
	private InspectionMsaChartManager inspectionMsachartManager;
	@Autowired
	private InspectionMsaplanManager inspectionMsaplanManager;
	@Autowired
	private GsmEquipmentManager gsmEquipmentManager;
	private Page<InspectionMsaplan> page;
	private Page<GsmEquipment> gsmPage;

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setPage(Page<InspectionMsaplan> page) {
		this.page = page;
	}

	public Page<InspectionMsaplan> getPage() {
		return page;
	}

	public Page<GsmEquipment> getGsmPage() {
		return gsmPage;
	}

	public void setGsmPage(Page<GsmEquipment> gsmPage) {
		this.gsmPage = gsmPage;
	}

	public String getDeleteIds() {
		return deleteIds;
	}

	public void setDeleteIds(String deleteIds) {
		this.deleteIds = deleteIds;
	}

	public JSONObject getParams() {
		return params;
	}

	public void setParams(JSONObject params) {
		this.params = params;
	}

	public Integer getTotalYear() {
		return totalYear;
	}

	public void setTotalYear(Integer totalYear) {
		this.totalYear = totalYear;
	}

	public Integer getBeginMonth() {
		return beginMonth;
	}

	public void setBeginMonth(Integer beginMonth) {
		this.beginMonth = beginMonth;
	}

	public Integer getEndMonth() {
		return endMonth;
	}

	public void setEndMonth(Integer endMonth) {
		this.endMonth = endMonth;
	}
	@Override
	public InspectionMsaplan getModel() { 
		return inspectionMsaplan;
	}
	@Override
	protected void prepareModel() throws Exception {
		if (id == null) {
			inspectionMsaplan = new InspectionMsaplan();
			inspectionMsaplan.setCompanyId(ContextUtils.getCompanyId());
			inspectionMsaplan.setCreatedTime(new Date());
			inspectionMsaplan.setCreator(ContextUtils.getUserName());
			inspectionMsaplan.setModifiedTime(new Date());
			inspectionMsaplan.setModifier(ContextUtils.getUserName());
			inspectionMsaplan.setBusinessUnitName(ContextUtils.getSubCompanyName());
			inspectionMsaplan.setBusinessUnitCode(CommonUtil1.getBusinessUnitCode(ContextUtils.getCompanyName()));
		} else {
			inspectionMsaplan = inspectionMsachartManager.getInspectionPlan(id);
		}
	}

	@Action("input")
	@Override
	public String input() throws Exception {
		return SUCCESS;
	}

	@Action("save")
	@Override
	public String save() throws Exception {
		return null;
	}

	@Action("delete")
	@Override
	public String delete() throws Exception {
		return null;
	}
	
	/**
	 * 校验完成率页面
	 */
	@Action("inspectionMsaplan-check-chart")
	public String inspectchartlist() throws Exception {
		Calendar calendar = Calendar.getInstance();
		Integer currentYear = calendar.get(Calendar.YEAR);
		if (totalYear == null) {
			totalYear = currentYear;
		}
		List<Option> options = new ArrayList<Option>();
		for (int i = currentYear; i > currentYear - 5; i--) {
			Option option = new Option();
			option.setName(String.valueOf(i));
			option.setValue(String.valueOf(i));
			options.add(option);
		}
		ActionContext.getContext().put("totalYears", options);
		if (beginMonth == null || endMonth == null) {
			beginMonth = 1;
			endMonth = 12;
		}
		options = new ArrayList<Option>();
		for (int i = 1; i < 13; i++) {
			Option option = new Option();
			option.setName(String.valueOf(i));
			option.setValue(String.valueOf(i));
			options.add(option);
		}
		ActionContext.getContext().put("totalMonths", options);
		return SUCCESS;
	} 

	/**
	 * 校验完成率数据
	 */
	@Action("check-chart-datas")
	public String charlistdatas() throws Exception {
		params = convertJsonObject(params);
		String beginyear = "", beginmoth = "", endyear = "", endmoth = "";
		if (params.get("startDate_ge_date") != null	&& params.get("endDate_le_date") != null) {
			beginyear = params.get("startDate_ge_date").toString().substring(0, 4);
			beginmoth = params.get("startDate_ge_date").toString().substring(5, 7);
			endyear = params.get("endDate_le_date").toString().substring(0, 4);
			endmoth = params.get("endDate_le_date").toString().substring(5, 7);
		}
		String begindate = "";
		String enddate = "";
		begindate = beginmoth + "/" + "01" + "/" + beginyear;
		enddate = endmoth + "/" + "31" + "/" + endyear;
		Date startDate = new Date();
		Date endDate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		startDate = sdf.parse(begindate);
		endDate = sdf.parse(enddate);
		// 获取月数
		Calendar startCal = Calendar.getInstance();
		Calendar endCal = Calendar.getInstance();
		startCal.setTime(startDate);
		endCal.setTime(endDate);
		int mothCount = (endCal.get(Calendar.YEAR) - startCal.get(Calendar.YEAR))* 12+ endCal.get(Calendar.MONTH)- startCal.get(Calendar.MONTH) + 1;
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("title", "校验三率——按时完成率统计分析图");
		result.put("subtitle", "(" + beginyear + "年" + beginmoth + "月" + "-"+ endyear + "年" + endmoth + "月" + ")");
		List<Integer> categories = new ArrayList<Integer>(); 
		result.put("categories", categories);
		result.put("yAxisTitle1", "数<br/>量<br/>");
		result.put("yAxisTitle2", "完<br/>成<br/>率");
		// 应送检定数
		Map<String, Object> series1 = new HashMap<String, Object>();
		series1.put("name", "应送检定数");
		List<Integer> data = new ArrayList<Integer>();
		List<Map<String, Object>> data5 = new ArrayList<Map<String, Object>>();
		Calendar startCal1 = Calendar.getInstance();
		startCal1.setTime(startDate); 
		for (int i = 0; i < mothCount; i++) {
			Date startdate = startCal1.getTime();
			// 横坐标天数的参数
			categories.add(startCal1.get(Calendar.MONTH) + 1);
			startCal1.add(Calendar.MONTH, 1);
			Date enddate1 = startCal1.getTime();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("startdate", sdf.format(startdate));
			map.put("enddate", sdf.format(enddate1));
			List<InspectionMsaplan> inspectionPlanList = inspectionMsachartManager.listPlan(startdate, enddate1);
			map.put("name", "应送检定数");
			map.put("y", inspectionPlanList.size());
			data5.add(map);
			data.add(inspectionPlanList.size());
		}

		ActionContext.getContext().put("categorieslist", categories);
		result.put("tableHeaderList", categories);
		List<Integer> data1 = data;
		series1.put("data", data5);
		result.put("series1", series1);
		// 实际送检数
		Map<String, Object> series2 = new HashMap<String, Object>();
		series2.put("name", "实际送检数");
		Calendar startCal2 = Calendar.getInstance();
		startCal2.setTime(startDate);
		data = new ArrayList<Integer>();
		List<Map<String, Object>> data6 = new ArrayList<Map<String, Object>>();
		int j = 0;
		for (int i = 0; i < mothCount; i++) {
			Date startdate = startCal2.getTime();
			// 横坐标天数的参数
			startCal2.add(Calendar.MONTH, 1);
			Date enddate2 = startCal2.getTime();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("startdate", sdf.format(startdate));
			map.put("enddate", sdf.format(enddate2));
			List<InspectionMsaplan> inspectionPlanList = inspectionMsachartManager.listActual(startdate, enddate2);
			map.put("name", "实际送检数");
			map.put("y", inspectionPlanList.size());
			data6.add(map);
			data.add(inspectionPlanList.size());
			j++;
		}
		List<Integer> data2 = data;
		series2.put("data", data6);
		result.put("series2", series2);
		// 批次合格率
		Map<String, Object> series3 = new HashMap<String, Object>();
		series3.put("name", "受检率");
		List<Double> data3 = new ArrayList<Double>();
		for (int i = 0; i < j; i++) {
			double jianyan = data1.get(i);
			double hege = data2.get(i);
			double rate = 0;
			if (jianyan != 0) {
				rate = (hege / jianyan) * 100;
			}
			data3.add(rate);
		}
		series3.put("data", data3);
		result.put("series3", series3);

		result.put("max", 100);
		renderText(JSONObject.fromObject(result).toString());
		return null;
	}

	/**
	 * 校验完成率详情页面
	 */
	@Action("check-chart-detail")
	public String getCheckChartDetail() throws Exception {
		params = convertJsonObject(params);
		return SUCCESS;
	}

	/**
	 * 受检率详情页面数据
	 */
	@Action("check-chart-detail-datas")
	public String getCheckChartDetailDatas() throws Exception {
		params = convertJsonObject(params);
		String name = (String) params.get("name");
		String StartDate = (String) params.get("StartDate");
		String EndDate = (String) params.get("EndDate");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		Date startDate = sdf.parse(StartDate);
		Date endDate = sdf.parse(EndDate);
		if (name.equals("应送检定数")) {
			page = inspectionMsachartManager.listPlan(page, startDate, endDate);
		}
		if (name.equals("实际送检数")) {
			page = inspectionMsachartManager.listActual(page, startDate, endDate);
		} 
		renderText(PageUtils.pageToJson(page));
		return null;
	} 
	
	/**
	 * 合格率页面
	 */
	@Action("inspectionMsaQualified-check-chart")
	public String inspectqualifiedlist() throws Exception {
		Calendar calendar = Calendar.getInstance();
		Integer currentYear = calendar.get(Calendar.YEAR);
		if (totalYear == null) {
			totalYear = currentYear;
		}
		List<Option> options = new ArrayList<Option>();
		for (int i = currentYear; i > currentYear - 5; i--) {
			Option option = new Option();
			option.setName(String.valueOf(i));
			option.setValue(String.valueOf(i));
			options.add(option);
		}
		ActionContext.getContext().put("totalYears", options);
		if (beginMonth == null || endMonth == null) {
			beginMonth = 1;
			endMonth = 12;
		}
		options = new ArrayList<Option>();
		for (int i = 1; i < 13; i++) {
			Option option = new Option();
			option.setName(String.valueOf(i));
			option.setValue(String.valueOf(i));
			options.add(option);
		}
		ActionContext.getContext().put("totalMonths", options);
		return SUCCESS;
	} 
	 
	/**
	 * 校验合格页面数据
	 */
	@Action("qualified-chart-datas")
	public String inspectcharlistdatas() throws Exception {
		params = convertJsonObject(params);
		String beginyear = "", beginmoth = "", endyear = "", endmoth = "";
		if (params.get("startDate_ge_date") != null	&& params.get("endDate_le_date") != null) {
			beginyear = params.get("startDate_ge_date").toString().substring(0, 4);
			beginmoth = params.get("startDate_ge_date").toString().substring(5, 7);
			endyear = params.get("endDate_le_date").toString().substring(0, 4);
			endmoth = params.get("endDate_le_date").toString().substring(5, 7);
		}
		String begindate = beginmoth + "/" + "01" + "/" + beginyear;
		String enddate = endmoth + "/" + "31" + "/" + endyear;
		Date startDate = new Date();
		Date endDate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		startDate = sdf.parse(begindate);
		endDate = sdf.parse(enddate);
		// 获取月数
		Calendar startCal = Calendar.getInstance();
		Calendar endCal = Calendar.getInstance();
		startCal.setTime(startDate);
		endCal.setTime(endDate);
		int mothCount = (endCal.get(Calendar.YEAR) - startCal.get(Calendar.YEAR)) * 12 + endCal.get(Calendar.MONTH)	- startCal.get(Calendar.MONTH) + 1;
  		Map<String, Object> result = new HashMap<String, Object>();
		result.put("title", "校验三率——校验合格率统计分析图");
		result.put("subtitle", "(" + beginyear + "年" + beginmoth + "月" + "-" + endyear + "年" + endmoth + "月" + ")");
		List<Integer> categories = new ArrayList<Integer>();
		result.put("categories", categories);
		result.put("yAxisTitle1", "数<br/>量<br/>");
		result.put("yAxisTitle2", "合<br/>格<br/>率");
		// 校验数
		Map<String, Object> series1 = new HashMap<String, Object>();
		series1.put("name", "校验数");
		List<Integer> data = new ArrayList<Integer>();
		List<Map<String, Object>> data5 = new ArrayList<Map<String, Object>>();
		Calendar startCal1 = Calendar.getInstance();
		startCal1.setTime(startDate); 
		for (int i = 0; i < mothCount; i++) {
			Date startdate = startCal1.getTime();
			// 横坐标天数的参数
			categories.add(startCal1.get(Calendar.MONTH) + 1);
			startCal1.add(Calendar.MONTH, 1);
			Date enddate1 = startCal1.getTime();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("startdate", sdf.format(startdate));
			map.put("enddate", sdf.format(enddate1));
			List<InspectionMsaplan> inspectionPlanList = inspectionMsachartManager.listActual(startdate, enddate1);
			map.put("name", "校验数");
			map.put("y", inspectionPlanList.size());
			data5.add(map);
			data.add(inspectionPlanList.size());
		} 
		ActionContext.getContext().put("categorieslist", categories);
		result.put("tableHeaderList", categories);
		List<Integer> data1 = data;
		series1.put("data", data5);
		result.put("series1", series1);
		// 检定合格数
		Map<String, Object> series2 = new HashMap<String, Object>();
		series2.put("name", "校验合格数");
		Calendar startCal2 = Calendar.getInstance();
		startCal2.setTime(startDate);
		data = new ArrayList<Integer>();
		List<Map<String, Object>> data6 = new ArrayList<Map<String, Object>>();
		int j = 0;
		for (int i = 0; i < mothCount; i++) {
			Date startdate = startCal2.getTime();
			// 横坐标天数的参数
			// categories.add(startCal1.get(Calendar.MONTH)+1);
			startCal2.add(Calendar.MONTH, 1);
			Date enddate2 = startCal2.getTime();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("startdate", sdf.format(startdate));
			map.put("enddate", sdf.format(enddate2));
			List<InspectionMsaplan> inspectionPlanList = inspectionMsachartManager.listQualifiedActual(startdate, enddate2);
			map.put("name", "校验合格数");
			map.put("y", inspectionPlanList.size());
			data6.add(map);
			data.add(inspectionPlanList.size());
			j++;
		}
		List<Integer> data2 = data;
		series2.put("data", data6);
		result.put("series2", series2);
		// 完成率
		Map<String, Object> series3 = new HashMap<String, Object>();
		series3.put("name", "合格率");
		List<Double> data3 = new ArrayList<Double>();
		for (int i = 0; i < j; i++) {
			double jianyan = data1.get(i);
			double hege = data2.get(i);
			double rate = 0;
			if (jianyan != 0) {
				rate = (hege / jianyan) * 100;
			}
			data3.add(rate);
		}
		series3.put("data", data3);
		result.put("series3", series3); 
		result.put("max", 100);
		renderText(JSONObject.fromObject(result).toString());
		return null;
	}

	/**
	 * 合格率详情页面
	 */
	@Action("check-qualified-chart-detail")
	public String getInspectChartDetail() throws Exception {
		params = convertJsonObject(params);
		return SUCCESS;
	} 
	
	/**
	 * 合格率详情页面数据
	 */
	@Action("check-qualified-chart-detail-datas")
	public String getInspectChartDetailDatas() throws Exception {
		params = convertJsonObject(params);
		String name = (String) params.get("name");
		String StartDate = (String) params.get("StartDate");
		String EndDate = (String) params.get("EndDate");
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
		Date startDate = sdf.parse(StartDate);
		Date endDate = sdf.parse(EndDate);
		if (name.equals("校验数")) {
			page = inspectionMsachartManager.listActual(page, startDate, endDate);

		}
		if (name.equals("校验合格数")) {
			page = inspectionMsachartManager.listQualifiedActual(page, startDate,endDate);
		}
		renderText(PageUtils.pageToJson(page));
		return null;
	} 

	@Action("list")
	@Override
	public String list() throws Exception {
		return SUCCESS;
	}

	/**
	 * 转换json
	 * 
	 * @param params
	 * @return
	 */
	private JSONObject convertJsonObject(JSONObject params) {
		JSONObject resultJson = new JSONObject();
		if (params != null) {
			for (Object key : params.keySet()) {
				resultJson.put(key, params.getJSONArray(key.toString()).get(0));
			}
		}
		return resultJson;
	} 
}
