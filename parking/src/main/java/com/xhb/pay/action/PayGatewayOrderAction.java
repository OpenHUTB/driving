package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.xhb.pay.bean.PayGatewayOrder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/ms/pay_gateway_order")
public class PayGatewayOrderAction extends ModelSuperAction<PayGatewayOrder> {
}
