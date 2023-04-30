package com.xhb.pay.service.impl;

import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayTempOrderFeeBalance;
import com.xhb.pay.service.PayTempOrderFeeBalanceService;
import org.springframework.stereotype.Service;
import com.fhs.core.base.service.impl.BaseServiceImpl;

/**
 * 结余时长计费(PayTempOrderFeeBalance)表服务实现类
 *
 * @author makejava
 * @since 2019-05-06 20:56:00
 */
@Service("payTempOrderFeeBalanceService")
@DataSource("park")
public class PayTempOrderFeeBalanceServiceImpl extends BaseServiceImpl<PayTempOrderFeeBalance> implements PayTempOrderFeeBalanceService {

}
