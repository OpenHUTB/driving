package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayMonthlyRecord;
import com.xhb.pay.service.PayMonthlyRecordService;
import org.springframework.stereotype.Service;

/**
 * 月租户充值记录表(PayMonthlyRecord)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-29 14:40:48
 */
@Service("payMonthlyRecordService")
@DataSource("park")
public class PayMonthlyRecordServiceImpl extends BaseServiceImpl<PayMonthlyRecord> implements PayMonthlyRecordService {

}
