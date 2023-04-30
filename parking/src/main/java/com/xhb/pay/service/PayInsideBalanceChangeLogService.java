package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayInsideBalanceChangeLog;

/**
 * 内部车余额变动日志(PayInsideBalanceChangeLog)表服务接口
 *
 * @author makejava
 * @since 2019-05-23 12:10:51
 */
public interface PayInsideBalanceChangeLogService extends BaseService<PayInsideBalanceChangeLog> {

    //0充值
    int PAY_LOG_RECHARGE = 0;
    //1 赠送金额充值
    int PAY_LOG_GIVEAMOUNT = 1;
    //2 包月充值
    int PAY_LOG_MONTH_RECHARGE = 2;
    //3包月扣费
    int PAY_LOG_MONTH_REFUND = 3;
    //4 包时段扣费
    int PAY_LOG_TIME_REFUND = 4;
    //5 提前结束包月入账
    int PAY_LOG_MONTH_AMOUNT_ADD = 5;
    //6 退款给客户
    int PAY_LOG_REFUND_TO_CUST = 6;
    //7 余额退款手续费
    int PAY_LOG_SERVICE_AMOUNT = 7;
    //8 赠送金额扣除
    int PAY_LOG_GIVEAMOUNT_DEDUCT = 8;

}
