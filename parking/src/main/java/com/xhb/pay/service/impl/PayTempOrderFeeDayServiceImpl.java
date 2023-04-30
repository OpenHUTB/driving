package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayTempOrderFeeDay;
import com.xhb.pay.service.PayTempOrderFeeDayService;
import org.springframework.stereotype.Service;

/**
 * (PayTempOrderFeeDay)表服务实现类
 *
 * @author jackwong
 * @since 2019-04-01 15:56:17
 */
@Service("payTempOrderFeeDayService")
@DataSource("park")
public class PayTempOrderFeeDayServiceImpl extends BaseServiceImpl<PayTempOrderFeeDay> implements PayTempOrderFeeDayService {

}
