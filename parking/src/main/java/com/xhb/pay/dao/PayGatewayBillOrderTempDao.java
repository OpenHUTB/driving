package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayGatewayBillOrderTemp;

/**
 * 对账单临时表(PayGatewayBillOrderTemp)表数据库访问层
 *
 * @author makejava
 * @since 2019-06-13 15:36:40
 */
@MapperDefinition(domainClass = PayGatewayBillOrderTemp.class, orderBy = " update_time DESC")
public interface PayGatewayBillOrderTempDao extends BaseDao<PayGatewayBillOrderTemp> {


}