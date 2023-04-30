package com.xhb.road.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.road.bean.PayAdvancePayOrder;
import com.xhb.road.dto.RoadDownChargeDto;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 路边停车预支付PayAdvancePayOrder)表数据库访问层
 *
 * @author jack_wang(wl)
 * @since 2019-08-27 14:24:06
 */
@Repository
@MapperDefinition(domainClass = PayAdvancePayOrder.class, orderBy = " update_time DESC")
public interface PayAdvancePayOrderDao extends BaseDao<PayAdvancePayOrder> {

    /**
     * 按照年月份，停车场查询 预支付支付金额
     *
     * @param parkId
     * @param dateTime yyyy-MM
     * @return
     */
    Double getMonthAdvance(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 按照年月份，停车场查询 每天预支付支付金额
     *
     * @param parkId
     * @param dateTime
     * @return
     */
    List<Map<String, Object>> getDaysAdvanceByMonth(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);
}
