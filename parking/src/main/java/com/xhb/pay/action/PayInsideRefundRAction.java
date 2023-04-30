package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.pay.bean.PayInsideRefund;
import com.xhb.pay.service.PayInsideRefundService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 内部用户账户退款记录(PayInsideRefund)表控制层
 *
 * @author makejava
 * @since 2019-05-31 17:13:30
 */
@RestController
@RequestMapping("/ms/pay_inside_refund_r")
public class PayInsideRefundRAction extends ModelSuperAction<PayInsideRefund> {
    @Autowired
    private PayInsideRefundService payInsideRefundService;

    @Autowired
    private TransService transService;

    /**
     * 内部客户退款记录 分页 条件查询
     *
     * @param request  过滤条件：停车场，客户姓名，电话，车牌号，起止时间
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("findPageByRefund")
    @RequiresPermissions("pay_inside_refund_r:see")
    public Object findPageByRefund(HttpServletRequest request, HttpServletResponse response) {
        //返回数据
        Map<String, Object> resultMap = new HashMap<String, Object>();
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        if (DataPermissonContext.getDataPermissonMap() != null) {
            paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        }
        paramMap.put("sortTzwName", this.formartOrderBy(request));
        List<PayInsideRefund> dataList = this.payInsideRefundService.findPayInsideRefundListByCondition(paramMap);
        List<PayInsideRefund> payInsideRefundList = new ArrayList<>();
        if (dataList.isEmpty()) {
            resultMap.put("total", 0);
            resultMap.put("rows", 0);
            resultMap.put("footer", payInsideRefundList);
            return resultMap;
        }
        int count = this.payInsideRefundService.findCount(paramMap);
        transService.transMore(dataList);
        //构建 合计：
        PayInsideRefund payInsideRefund = payInsideRefundService.findSum(paramMap);
        payInsideRefund.setPlateNums("合计：");
        payInsideRefundList.add(payInsideRefund);

        resultMap.put("total", count);
        resultMap.put("rows", dataList);
        resultMap.put("footer", payInsideRefundList);
        return resultMap;
    }


}
