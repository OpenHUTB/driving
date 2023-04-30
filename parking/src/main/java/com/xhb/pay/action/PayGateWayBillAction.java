package com.xhb.pay.action;

import com.fhs.core.exception.ParamChecker;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.ParkPayMch;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/ms/pay_gateway_bill_task")
public class PayGateWayBillAction {

    /**
     * 指定商户id 和账单日期对账
     *
     * @param mchId 商户id
     * @param date  日期
     * @return
     */
    @RequestMapping("billReconciliation")
    @RequiresPermissions("pay_gateway_bill_task:billReconciliation")
    public HttpResult<Boolean> billReconciliation(@RequestParam("mch_id") String mchId, @RequestParam("bill_task_date") String date) {
        ParamChecker.isNotNullOrEmpty(mchId, "商户id不能为空");
        ParamChecker.isNotNullOrEmpty(date, "日期不能为空");
        return HttpResult.success(true);
    }
}
