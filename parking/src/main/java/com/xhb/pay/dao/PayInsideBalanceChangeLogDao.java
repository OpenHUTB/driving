package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayInsideBalanceChangeLog;

/**
 * 内部车余额变动日志(PayInsideBalanceChangeLog)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-23 12:10:50
 */
@MapperDefinition(domainClass = PayInsideBalanceChangeLog.class, orderBy = " update_time DESC")
public interface PayInsideBalanceChangeLogDao extends BaseDao<PayInsideBalanceChangeLog> {

}