package com.xhb.business.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.business.bean.BusinessBalanceRechargeLog;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Map;

/**
 * (t_business_balance_recharge_log)表数据库访问层
 *
 * @author wangy
 * @since 2019-07-09 10:22:09
 */
@Repository
@MapperDefinition(domainClass = BusinessBalanceRechargeLog.class)
public interface BusinessBalanceRechargeLogDao extends BaseDao<BusinessBalanceRechargeLog> {

    /**
     * 按照年月份，停车场查询 商户充值
     *
     * @param parkId
     * @param dateTime yyyy-MM
     * @return
     */
    Double getMonthMerchant(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);
}
