package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayInsideCarOnlinePayTempOrder;
import com.xhb.pay.dao.PayInsideCarOnlinePayTempOrderDao;
import com.xhb.pay.service.PayInsideCarOnlinePayTempOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 内部客户网络支付订单(PayInsideCarOnlinePayTempOrder)表服务实现类
 *
 * @author makejava
 * @since 2019-05-25 15:38:01
 */
@Service("payInsideCarOnlinePayTempOrderService")
@DataSource("park")
public class PayInsideCarOnlinePayTempOrderServiceImpl extends BaseServiceImpl<PayInsideCarOnlinePayTempOrder> implements PayInsideCarOnlinePayTempOrderService {


    @Autowired
    private PayInsideCarOnlinePayTempOrderDao payInsideCarOnlinePayTempOrderDao;

    @Override
    public String selectLastRechargeRecord(Long insideId) {
        return payInsideCarOnlinePayTempOrderDao.selectLastRechargeRecord(insideId);
    }

}
