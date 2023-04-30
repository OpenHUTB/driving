package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.CheckUtils;
import com.fhs.core.group.Add;
import com.fhs.core.log.LogDesc;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.service.PayInsideContractService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 内部车承包时间段表(PayInsideContract)表控制层
 *
 * @author makejava
 * @since 2019-05-23 19:12:40
 */
@RestController
@RequestMapping("/ms/pay_inside_contract")
public class PayInsideContractAction extends ModelSuperAction<PayInsideContract> {
    @Autowired
    private PayInsideContractService payInsideContractService;

    /**
     * 添加
     *
     * @param
     * @param check 检查结果
     */
    @RequestMapping("contractAdd")
    @ResponseBody
    @RequiresPermissions("pay_inside_contract:add")
    @LogDesc(value = "添加", type = LogDesc.ADD)
    public HttpResult<Boolean> add(@Validated(Add.class) PayInsideContract payInsideContract, BindingResult check, HttpServletRequest request,
                                   HttpServletResponse response) {
        payInsideContract.preInsert(getSessionuser(request).getUserId());
        payInsideContract.setGroupCode(getSessionuser(request).getGroupCode());
        payInsideContractService.insertContract(payInsideContract);
        return HttpResult.success(true);
    }

    /**
     * 查询月租用户最后一次充值记录
     *
     * @param insideId 内部用户id
     */
    @RequestMapping("findLastInfo/{insideId}")
    @ResponseBody
    @RequiresPermissions("pay_inside_contract:see")
    @LogDesc(value = "查询", type = LogDesc.SEE)
    public HttpResult findLastInfo(@PathVariable("insideId") Long insideId) {
        PayInsideContract payInsideContract = payInsideContractService.findLastRecord(PayInsideContract.builder().insideId(insideId).build());
        if (!CheckUtils.isNullOrEmpty(payInsideContract)) {
            return HttpResult.success(payInsideContract);
        }
        return HttpResult.error();
    }

}
