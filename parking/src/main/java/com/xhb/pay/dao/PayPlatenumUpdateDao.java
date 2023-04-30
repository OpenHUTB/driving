package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayPlatenumUpdate;

/**
 * 修改车牌号表(PayPlatenumUpdate)表数据库访问层
 *
 * @author makeliujun
 * @since 2019-10-08 17:44:37
 */
@MapperDefinition(domainClass = PayPlatenumUpdate.class, orderBy = " update_time DESC")
public interface PayPlatenumUpdateDao extends BaseDao<PayPlatenumUpdate> {

}