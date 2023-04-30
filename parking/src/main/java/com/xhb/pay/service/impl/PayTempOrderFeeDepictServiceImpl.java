package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayTempOrderFeeDepict;
import com.xhb.pay.service.PayTempOrderFeeDepictService;
import org.springframework.stereotype.Service;

/**
 * 临时费用(临时订单)详单(PayTempOrderFeeDepict)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-29 15:28:44
 */
@Service("payTempOrderFeeDepictService")
@DataSource("park")
public class PayTempOrderFeeDepictServiceImpl extends BaseServiceImpl<PayTempOrderFeeDepict> implements PayTempOrderFeeDepictService {

}
