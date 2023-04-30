package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayTempOrderFeeDay;

/**
 * (PayTempOrderFeeDay)表数据库访问层
 *
 * @author jackwong
 * @since 2019-04-01 15:56:17
 */
@MapperDefinition(domainClass = PayTempOrderFeeDay.class, orderBy = " update_time DESC")
public interface PayTempOrderFeeDayDao extends BaseDao<PayTempOrderFeeDay> {

}