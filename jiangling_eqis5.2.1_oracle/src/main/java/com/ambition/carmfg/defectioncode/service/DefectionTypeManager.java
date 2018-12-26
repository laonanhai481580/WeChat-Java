package com.ambition.carmfg.defectioncode.service;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ambition.carmfg.defectioncode.dao.DefectionTypeDao;
import com.ambition.carmfg.entity.DefectionType;
import com.norteksoft.acs.base.utils.log.LogUtilDao;
import com.norteksoft.product.api.entity.Option;
import com.norteksoft.product.orm.Page;
import com.norteksoft.product.util.ContextUtils;

import flex.messaging.util.StringUtils;

@Service
@Transactional
public class DefectionTypeManager {
	@Autowired
	private DefectionTypeDao defectionTypeDao;	
	
	@Autowired
	private LogUtilDao logUtilDao;
	
	
	//获取记录
	public DefectionType getDefectionType(Long id){
		return defectionTypeDao.get(id);
	}
	//验证并保存记录
	public boolean isExistDefectionType(Long id, String no, String name,String businessUnit){
		String hql = "select count(*) from DefectionType d where d.companyId =? and d.businessUnitName=? and (d.defectionTypeNo = ? or d.defectionTypeName = ?)";
		List<Object> params = new ArrayList<Object>();
		params.add(ContextUtils.getCompanyId());		
		params.add(businessUnit);
		params.add(no);
		params.add(name);
		if(id != null){
			hql += " and d.id <> ?";
			params.add(id);
		}
		Query query = defectionTypeDao.getSession().createQuery(hql);
		for(int i = 0;i < params.size(); i++){
			query.setParameter(i, params.get(i));
		}
		@SuppressWarnings("rawtypes")
		List list = query.list();
		if(Integer.valueOf(list.get(0).toString()) > 0){
			return true;
		}else{
			return false;
		}		
	}
	public void saveDefectionType(DefectionType defectionType){
		if(StringUtils.isEmpty(defectionType.getDefectionTypeNo())){
			throw new RuntimeException("不良类别代码不能为空!");
		}
		if(StringUtils.isEmpty(defectionType.getDefectionTypeName())){
			throw new RuntimeException("不良类别名称不能为空!");
		}
		if(isExistDefectionType(defectionType.getId(), defectionType.getDefectionTypeNo(), defectionType.getDefectionTypeName(),defectionType.getBusinessUnitName())){
			throw new RuntimeException("该事业部已存在相同不良类别代码或名称!");
		}
		defectionTypeDao.save(defectionType);
	}
	public void saveExcelDefectionType(DefectionType defectionType){
		defectionTypeDao.save(defectionType);
	}
	
	//删除记录
	public void deleteDefectionType(String ids){
		String[] deleteIds = ids.split(",");
		for(String id : deleteIds){
			if(defectionTypeDao.get(Long.valueOf(id))!=null){
				logUtilDao.debugLog("删除", defectionTypeDao.get(Long.valueOf(id)).toString());
			}
			defectionTypeDao.delete(Long.valueOf(id));
		}
	}
	
	//删除对象
	public void deleteDefectionType(DefectionType defectionType){
		logUtilDao.debugLog("删除", defectionType.toString());
		defectionTypeDao.delete(defectionType);
	}
	
	//返回页面对象列表
	public Page<DefectionType> list(Page<DefectionType> page,String businessUnit){
		return defectionTypeDao.list(page,businessUnit);
	}
	
	//返回所有对象列表
	public List<DefectionType> listAll(){
		return defectionTypeDao.getAllDefectionType();
	}
	public DefectionType getDefectionTypeByCode(String code){
		return defectionTypeDao.getDefectionTypeByCode(code);
	}
	public List<DefectionType> getDefectionTypeByBusinessUnit(String businessUnit){
		return defectionTypeDao.getDefectionTypeByBusinessUnit(businessUnit);
	}
	public String listDefectionTypeNoByName(String name,String businessUnit){
		return defectionTypeDao.getDefectionTypeNoByName(name,businessUnit);
	}		
	/**
	 * 获取所有的不良类别
	 * @return
	 */
	public List<Option> listAllForOptions(){
		List<DefectionType> defectionTypes = listAll();
		List<Option> options = new ArrayList<Option>();
		for(DefectionType defectionType : defectionTypes){
			Option option = new Option();
			option.setName(defectionType.getDefectionTypeName());
			option.setValue(defectionType.getDefectionTypeName());
			options.add(option);
		}
		return options;
	}
}
