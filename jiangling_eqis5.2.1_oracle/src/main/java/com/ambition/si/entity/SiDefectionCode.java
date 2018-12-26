package com.ambition.si.entity;

//import java.util.List;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
//import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ambition.product.base.IdEntity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.norteksoft.wf.engine.client.ExtendField;

/**
 * 
 * 类名:不良项目
 * <p>amb</p>
 * <p>厦门安必兴信息科技有限公司</p>
 * <p>功能说明：</p>
 * @author  LPF
 * @version 1.00 2016年9月8日 发布
 */
@Entity
@Table(name = "SI_DEFECTION_CODE")
@JsonIgnoreProperties(value={"hibernateLazyInitializer","handler","fieldHandler"})
public class SiDefectionCode extends IdEntity{

	private static final long serialVersionUID = 1L;
	private String defectionCodeNo;//不良项目编码
	private String defectionCodeName;//不良项目名称
	@ManyToOne
	@JoinColumn(name = "FK_DEFECTION_TYPE_NO")
	@JsonIgnore
	private SiDefectionType defectionType;//不良类型
	@Embedded
	private ExtendField extendField;
	
	private Boolean isFlag;//标志位
	
	//Get、Set方法
	public String getDefectionCodeNo() {
		return defectionCodeNo;
	}
	public void setDefectionCodeNo(String defectionCodeNo) {
		this.defectionCodeNo = defectionCodeNo;
	}
	public String getDefectionCodeName() {
		return defectionCodeName;
	}
	public void setDefectionCodeName(String defectionCodeName) {
		this.defectionCodeName = defectionCodeName;
	}
	public Boolean getIsFlag() {
		return isFlag;
	}
	public void setIsFlag(Boolean isFlag) {
		this.isFlag = isFlag;
	}

	public SiDefectionType getDefectionType() {
		return defectionType;
	}
	public void setDefectionType(SiDefectionType defectionType) {
		this.defectionType = defectionType;
	}
	public ExtendField getExtendField() {
		return extendField;
	}
	public void setExtendField(ExtendField extendField) {
		this.extendField = extendField;
	}
	public String toString() {
		return "制造质量管理：不良代码维护  ID"+this.getId()+",不良代码名称"+this.defectionCodeName;
	}
}
