package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayGatewayOrder;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 网关支付订单(PayGatewayOrder)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-06 19:56:44
 */
@MapperDefinition(domainClass = PayGatewayOrder.class, orderBy = " update_time DESC")
public interface PayGatewayOrderDao extends BaseDao<PayGatewayOrder> {

    /**
     * 获得总网关支付订单数
     *
     * @param parkIds
     * @return
     */
    Integer findOrderCount(@Param("parkIds") String parkIds);

    /**
     * 获得每日增网关支付定单数量
     *
     * @param parkIds
     * @return
     */
    Integer findTodayOrderCount(@Param("parkIds") String parkIds);

    /**
     * 获得总的支付金额
     *
     * @param parkIds
     * @return
     */
    Double findSettlementAmountCount(@Param("parkIds") String parkIds);

    /**
     * 获得今日支付总金额
     *
     * @param parkIds
     * @return
     */
    Double findTodaySettlementAmountCount(@Param("parkIds") String parkIds);

}
