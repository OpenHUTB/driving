package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayInsideCarOnlinePayTempOrder;

import java.util.List;

/**
 * 内部客户网络支付订单(PayInsideCarOnlinePayTempOrder)表服务接口
 *
 * @author makejava
 * @since 2019-05-25 15:38:01
 */
public interface PayInsideCarOnlinePayTempOrderService extends BaseService<PayInsideCarOnlinePayTempOrder> {

    /**
     * 未缴费
     */
    int NOT_PAY_COST = 0;

    /**
     * 已缴纳
     */
    int ALREADY_PAY_COST = 1;

    /**
     * 已退款
     */
    int HAVE_A_REFUND = 2;

    /**
     * 已超时
     */
    int HAVE_A_TIMEOUT = 3;

    /**
     * 超时时间
     */
    int TIME_OUT_MINUTES = 10;


    /**
     * 根据insideId查询最后一条充值记录的车位信息
     *
     * @param insideId
     * @return
     */

    String selectLastRechargeRecord(Long insideId);

}
