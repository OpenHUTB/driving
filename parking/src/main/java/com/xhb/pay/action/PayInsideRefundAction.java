package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.CheckUtils;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ParamException;
import com.fhs.core.log.LogDesc;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.PayInsideRefund;
import com.xhb.pay.dto.RefundInfoDTO;
import com.xhb.pay.service.PayInsideRefundService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 内部用户账户退款(PayInsideRefund)表控制层
 *
 * @author makejava
 * @since 2019-05-31 17:13:30
 */
@RestController
@RequestMapping("/ms/pay_inside_refund")
public class PayInsideRefundAction extends ModelSuperAction<PayInsideRefund> {
    @Autowired
    private PayInsideRefundService payInsideRefundService;

    /**
     * 添加
     *
     * @param
     * @param
     */
    @RequestMapping("refundInfoAdd")
    @ResponseBody
    @RequiresPermissions("pay_inside_refund:add")
    @LogDesc(value = "添加", type = LogDesc.ADD)
    public HttpResult<Boolean> add(RefundInfoDTO refundInfoDTO, HttpServletRequest request, HttpServletResponse response) {
        ParamChecker.isNotNullOrEmpty(refundInfoDTO.getInsideId(), "内部用户id不能为空");
        if (CheckUtils.isNullOrEmpty(refundInfoDTO.getRefundAmont())) {
            throw new ParamException("退款余额输入无效");
        }
        refundInfoDTO.setUserId(getSessionuser(request).getUserId());
        refundInfoDTO.setGroupCode(getSessionuser(request).getGroupCode());
        payInsideRefundService.insertRefund(refundInfoDTO);
        return HttpResult.success(true);
    }

}
