package com.ambition.carmfg.entity;

import java.sql.Blob;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.ambition.product.base.IdEntity;

/**
 * 类名:设备参数文件
 * <p>amb</p>
 * <p>厦门安必兴信息科技有限公司</p>
 * <p>功能说明：</p>
 * @author  LPF
 * @version 1.00 2019-9-3 发布
 */
@Entity
@Table(name="MFG_PLANT_ATTACH")
public class PlantAttach extends IdEntity {
	private static final long serialVersionUID = 1L;
	private String model;//机种		
	private String modelName;//机种名称
	private String fileName;//上传时的文件名称
	private Blob blobValue;//设备参数文件

	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public Blob getBlobValue() {
		return blobValue;
	}
	public void setBlobValue(Blob blobValue) {
		this.blobValue = blobValue;
	}
}
