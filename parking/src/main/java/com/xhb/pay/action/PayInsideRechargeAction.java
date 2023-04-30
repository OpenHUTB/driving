package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.constant.Constant;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ParamException;
import com.fhs.core.group.Add;
import com.fhs.core.log.LogDesc;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.service.PayInsideCarService;
import com.xhb.pay.service.PayInsideRechargeService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 充值记录表(PayInsideRecharge)表控制层
 *
 * @author makejava
 * @since 2019-05-23 19:13:09
 */
@RestController
@RequestMapping("/ms/pay_inside_recharge")
public class PayInsideRechargeAction extends ModelSuperAction<PayInsideRecharge> {

    private static final Logger LOG = Logger.getLogger(PayInsideRechargeAction.class);

    @Autowired
    private PayInsideRechargeService rechargeService;

    @RequestMapping("rechargeAdd")
    @ResponseBody
    @RequiresPermissions("pay_inside_recharge:add")
    @LogDesc(value = "添加", type = LogDesc.ADD)
    public HttpResult add(@Validated(Add.class) PayInsideRecharge payInsideRecharge, HttpServletRequest request,
                          HttpServletResponse response) {
        ParamChecker.isNotNullOrEmpty(payInsideRecharge.getParkId(), "停车场id不能为空");
        ParamChecker.isNotNullOrEmpty(payInsideRecharge.getInsideId(), "内部用户id不能为空");
        if (CheckUtils.isNullOrEmpty(payInsideRecharge.getAmount()) || payInsideRecharge.getAmount() == 0) {
            throw new ParamException("充值金额输入无效");
        }
        payInsideRecharge.preInsert(getSessionuser(request).getUserId());
        payInsideRecharge.setGroupCode(getSessionuser(request).getGroupCode());
        payInsideRecharge.setFromType(PayInsideCarService.DEFAULT_FROM_TYPE);
        rechargeService.insertRecharge(payInsideRecharge, Constant.INT_FALSE);
        return HttpResult.success();
    }

    /**
     * 查询储户时段租用户最后一次充值记录
     *
     * @param insideId 内部用户id
     */
    @RequestMapping("findLastInfo/{insideId}")
    @ResponseBody
    @RequiresPermissions("pay_inside_recharge:see")
    @LogDesc(value = "查询", type = LogDesc.SEE)
    public HttpResult findLastInfo(@PathVariable("insideId") Long insideId) {
        PayInsideRecharge payInsideRecharge = rechargeService.findLastRecord(PayInsideRecharge.builder().insideId(insideId).build());
        if (!CheckUtils.isNullOrEmpty(payInsideRecharge)) {
            return HttpResult.success(payInsideRecharge);
        }
        return HttpResult.error();
    }

}

