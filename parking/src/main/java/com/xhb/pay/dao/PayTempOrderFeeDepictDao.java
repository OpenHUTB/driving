package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayTempOrderFeeDepict;

/**
 * 临时费用(临时订单)详单(PayTempOrderFeeDepict)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-29 15:28:44
 */
@MapperDefinition(domainClass = PayTempOrderFeeDepict.class, orderBy = " update_time DESC")
public interface PayTempOrderFeeDepictDao extends BaseDao<PayTempOrderFeeDepict> {

}