package com.ambition.carmfg.oqc.service;

import java.io.File;
import java.io.FileInputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ambition.carmfg.entity.OqcInspectionReport;
import com.ambition.carmfg.entity.OqcVisualInspectionReport;
import com.ambition.carmfg.oqc.dao.OqcInspectionReportDao;
import com.ambition.carmfg.oqc.dao.OqcVisualInspectionReportDao;
import com.ambition.gp.entity.GpAverageMaterial;
import com.ambition.qsm.baseinfo.dao.SystemMaintenanceDao;
import com.ambition.qsm.entity.CustomerAudit;
import com.ambition.qsm.entity.SystemMaintenance;
import com.ambition.util.common.CommonUtil1;
import com.norteksoft.mms.form.entity.ListColumn;
import com.norteksoft.product.api.ApiFactory;
import com.norteksoft.product.api.entity.ListView;
import com.norteksoft.product.orm.Page;
import com.norteksoft.product.util.ContextUtils;
import com.norteksoft.product.util.PropUtils;

/**
 * 
 * 类名:体系维护Manager
 * <p>amb</p>
 * <p>厦门安必兴信息科技有限公司</p>
 * <p>功能说明：</p>
 * @author  LPF
 * @version 1.00 2016年9月26日 发布
 */
@Service
@Transactional
public class OqcVisualInspectionReportManager {
	@Autowired
	private OqcVisualInspectionReportDao oqcVisualInspectionReportDao;	
	
	public OqcVisualInspectionReport getOqcVisualInspectionReport(Long id){
		return oqcVisualInspectionReportDao.get(id);
	}
	
	public void deleteOqcVisualInspectionReport(OqcVisualInspectionReport oqcVisualInspectionReport){
		oqcVisualInspectionReportDao.delete(oqcVisualInspectionReport);
	}

	public Page<OqcVisualInspectionReport> search(Page<OqcVisualInspectionReport>page){
		return oqcVisualInspectionReportDao.search(page);
	}

	public List<OqcVisualInspectionReport> listAll(){
		return oqcVisualInspectionReportDao.getAllOqcVisualInspectionReport();
	}
		
	public void deleteOqcInspectionReport(Long id){
		oqcVisualInspectionReportDao.delete(id);
	}
	public void deleteOqcVisualInspectionReport(String ids) {
		String[] deleteIds = ids.split(",");
		for (String id : deleteIds) {
			OqcVisualInspectionReport  oqcVisualInspectionReport = oqcVisualInspectionReportDao.get(Long.valueOf(id));
			if(oqcVisualInspectionReport.getId() != null){
				oqcVisualInspectionReportDao.delete(oqcVisualInspectionReport);
			}
		}
	}
	public void saveOqcVisualInspectionReport(OqcVisualInspectionReport oqcVisualInspectionReport){
		oqcVisualInspectionReportDao.save(oqcVisualInspectionReport);
	}
	
	public Page<OqcVisualInspectionReport> listState(Page<OqcVisualInspectionReport> page,String type,String code,String subName ) {//,String factorySupply
		String hql = " from OqcVisualInspectionReport s where hiddenState='N' ";
		List<Object> searchParams = new ArrayList<Object>();
//		searchParams.add(state);
		if(type!=null ){
			if("0".equals(type)){
				type=GpAverageMaterial.STATE_SUBMIT;
			}
			if("1".equals(type)){
				type=GpAverageMaterial.STATE_PENDING;
			}
			if("2".equals(type)){
				type=GpAverageMaterial.STATE_QUALIFIED;
			}
		/*	if("3".equals(type)){
				type=GpAverageMaterial.STATE_OVERDUE;
			}*/
			hql=hql+" and s.isHarmful=?";
			searchParams.add(type);
		}
		if(code!=null ){
			hql=hql+" and s.supplierCode=?";
			searchParams.add(code);
		}
		if(subName!=null ){
			hql=hql+" and s.factoryClassify=?";
			searchParams.add(subName);
		}
	/*	if("南昌".equals(factorySupply)||"苏州".equals(factorySupply)||"深圳".equals(factorySupply)){
			hql=hql+" and s.factorySupply=?";
			searchParams.add(factorySupply);
		}*/
		return oqcVisualInspectionReportDao.searchPageByHql(page, hql, searchParams.toArray());
		
	}
	

	public void harmful(String eid,String type){
		String[] ids = eid.split(",");
		for(String id : ids){
			OqcVisualInspectionReport oqcVisualInspectionReport = oqcVisualInspectionReportDao.get(Long.valueOf(id));
			if("U".equals(type)){
				oqcVisualInspectionReport.setIsHarmful(GpAverageMaterial.STATE_PENDING);
				oqcVisualInspectionReport.setTaskProgress(GpAverageMaterial.STATE_PENDING);
			}else if("Y".equals(type)){
				oqcVisualInspectionReport.setIsHarmful(GpAverageMaterial.STATE_QUALIFIED);
				oqcVisualInspectionReport.setTaskProgress(GpAverageMaterial.STATE_QUALIFIED);
			}else if("N".equals(type)){
				oqcVisualInspectionReport.setIsHarmful(GpAverageMaterial.STATE_SUBMIT);
				oqcVisualInspectionReport.setTaskProgress(GpAverageMaterial.STATE_SUBMIT);
			}else if("O".equals(type)){
				oqcVisualInspectionReport.setIsHarmful(GpAverageMaterial.STATE_OVERDUE);
				oqcVisualInspectionReport.setTaskProgress(GpAverageMaterial.STATE_OVERDUE);
			}
			if(!"未更新".equals(oqcVisualInspectionReport.getUpdateStatus())){
				oqcVisualInspectionReport.setUpdateStatus("未更新");
			}
			oqcVisualInspectionReportDao.save(oqcVisualInspectionReport);
		}
	}
	public void isHarmfulDate(String eid){
		String[] ids = eid.split(",");
		for(String id : ids){
			OqcVisualInspectionReport  oqcVisualInspectionReport=oqcVisualInspectionReportDao.get(Long.valueOf(id));
			String businessUnitName=oqcVisualInspectionReport.getBusinessUnitName();
			//String enterpriseGroup=oqcInspectionReport.getEnterpriseGroup();
			String classGroup=oqcVisualInspectionReport.getClassGroup();
			String processSection=oqcVisualInspectionReport.getProcessSection();
			String ofilmModel= oqcVisualInspectionReport.getOfilmModel();
			String customer=oqcVisualInspectionReport.getCustomer();
			String batchNumber=oqcVisualInspectionReport.getBatchNumber();
			String attachment=oqcVisualInspectionReport.getAttachment();
			//String uploadMan=oqcInspectionReport.getUploadMan();//上传人
			String personResponsible=oqcVisualInspectionReport.getPersonResponsible();//责任人
			String auditMan=oqcVisualInspectionReport.getAuditMan();//审核人
			//Date UploadDate=oqcInspectionReport.getUploadDate();//上传日期
			Date reportDate=oqcVisualInspectionReport.getReportDate();
			
			String remark=oqcVisualInspectionReport.getRemark();
			if("".equals(auditMan)||auditMan==null){
				throw new RuntimeException("审核人不能为空!");
			}
			if("".equals(businessUnitName)||businessUnitName==null){
				throw new RuntimeException("厂区不能为空!");
			}
			/*if("".equals(enterpriseGroup)||enterpriseGroup==null){
				throw new RuntimeException("事业群不能为空!");
			}*/
			if("".equals(classGroup)||classGroup==null){
				throw new RuntimeException("班别不能为空!");
			}
			if("".equals(processSection)||processSection==null){
				throw new RuntimeException("制程区段不能为空!");
			}
			if("".equals(ofilmModel)||ofilmModel==null){
				throw new RuntimeException("欧菲机种不能为空!");
			}
			if("".equals(customer)||customer==null){
				throw new RuntimeException("客户不能为空!");
			}
			if("".equals(batchNumber)||batchNumber==null){
				throw new RuntimeException("检验批号不能为空!");
			}
		/*	if("".equals(attachment)||attachment==null){
				throw new RuntimeException("附件不能为空!");
			}*/
			if(attachment==null||"".equals(attachment)||attachment.indexOf("|~|")<0){
				throw new RuntimeException("附件不能为空!");
			}
			if("".equals(personResponsible)||personResponsible==null){
				throw new RuntimeException("责任人不能为空!");
			}
			if("".equals(reportDate)||reportDate==null){
				throw new RuntimeException("时间不能为空!");
			}
			
			if("".equals(remark)||remark==null){
				throw new RuntimeException("备注不能为空!");
			}
			
	}
	
}
	public String importDatas(File file) throws Exception{
		StringBuffer sb = new StringBuffer("");
		//表单字段                                                                                                                    //MFG_OQC_INSPECTION_REPORT
		Map<String,String> fieldMap = this.getFieldMap("MFG_OQC_INSPECTION_REPORT");//MFG_IPQC_INSPECTION  ,QSM_CUSTOMER_AUDIT
		Workbook book = WorkbookFactory.create(new FileInputStream(file));
		Sheet sheet = book.getSheetAt(0);
		Row row = sheet.getRow(0);
		if(row == null){
			throw new RuntimeException("第一行不能为空!");
		}
		Map<String,Integer> columnMap = new HashMap<String,Integer>();
		for(int i=0;;i++){
			Cell cell = row.getCell(i);
			if(cell==null){
				break;
			}
			String value = cell.getStringCellValue();
			if(fieldMap.containsKey(value)){
				columnMap.put(value,i);
			}
		}
		/*if(columnMap.keySet().size() != fieldMap.keySet().size()){
			throw new AmbFrameException("Excel格式不正确!请重新导出台账数据模板!");
		}*/
		
		DecimalFormat df = new DecimalFormat("#.##");
		Iterator<Row> rows = sheet.rowIterator();
		rows.next();//标题行
		int i = 0;
		while(rows.hasNext()){
			row = rows.next();
			try {
				Map<String,Object> objMap = new HashMap<String, Object>();
				for(String columnName : columnMap.keySet()){
					Cell cell = row.getCell(columnMap.get(columnName));
					if(cell != null){
						Object value = null;
						if(Cell.CELL_TYPE_STRING == cell.getCellType()){
							value = cell.getStringCellValue();
						}else if(Cell.CELL_TYPE_NUMERIC == cell.getCellType()){
							if (HSSFDateUtil.isCellDateFormatted(cell)) {
								value = cell.getDateCellValue();
							} else {
								value = df.format(cell.getNumericCellValue());
							}
						}else if(Cell.CELL_TYPE_FORMULA == cell.getCellType()){
							value = cell.getCellFormula();
						}
						objMap.put(fieldMap.get(columnName),value);
					}
				}
				OqcVisualInspectionReport oqcVisualInspectionReport=new OqcVisualInspectionReport();
				//CustomerAudit customerAudit = new CustomerAudit();
				oqcVisualInspectionReport.setCompanyId(ContextUtils.getCompanyId());
				oqcVisualInspectionReport.setCreatedTime(new Date());
				oqcVisualInspectionReport.setCreator(ContextUtils.getUserName());
				oqcVisualInspectionReport.setModifiedTime(new Date());
				oqcVisualInspectionReport.setModifier(ContextUtils.getUserName());
				for(String key : objMap.keySet()){
			     CommonUtil1.setProperty(oqcVisualInspectionReport,key, objMap.get(key));
				}
				oqcVisualInspectionReportDao.save(oqcVisualInspectionReport);
			   sb.append("第" + (i+1) + "行导入成功!<br/>");
			} catch (Exception e) {
				e.printStackTrace();
				sb.append("第" + (i+1) + "行导入失败:<font color=red>" + e.getMessage() + "</font><br/>");
			}
			i++;
		}
		file.delete();
		return sb.toString();
	}
	
	public Map<String,String> getFieldMap(String listCode){
		Map<String,String> fieldMap = new HashMap<String, String>();
		ListView columns = ApiFactory.getMmsService().getListViewByCode(listCode);
		for(ListColumn column: columns.getColumns()){
			if(column.getVisible()){
				fieldMap.put(column.getHeaderName(), column.getTableColumn().getName());
			}
		}
		return fieldMap;
	}
	
}
