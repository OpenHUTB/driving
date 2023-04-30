package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayFreeCarTemp;

/**
 * 临时免费车(PayFreeCarTemp)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-29 12:49:45
 */
@MapperDefinition(domainClass = PayFreeCarTemp.class, orderBy = " update_time DESC")
public interface PayFreeCarTempDao extends BaseDao<PayFreeCarTemp> {

}