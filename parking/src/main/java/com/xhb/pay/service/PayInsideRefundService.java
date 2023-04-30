package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayInsideRefund;
import com.xhb.pay.dto.RefundInfoDTO;

import java.util.List;
import java.util.Map;

/**
 * 内部用户账户退款(PayInsideRefund)表服务接口
 *
 * @author makejava
 * @since 2019-05-31 17:06:10
 */
public interface PayInsideRefundService extends BaseService<PayInsideRefund> {

    boolean insertRefund(RefundInfoDTO refundInfoDTO);

    /**
     * 查询内部客户退款记录
     *
     * @param paramMap 过滤条件：停车场，客户姓名，电话，车牌号，起止时间
     * @return
     */
    List<PayInsideRefund> findPayInsideRefundListByCondition(Map<String, Object> paramMap);

    /**
     * 查询内部客户退款记录总数
     *
     * @param paramMap 带过滤
     * @return
     */
    int findCount(Map<String, Object> paramMap);

    /**
     * 查询 退款、赠送、手续的金额 合计
     *
     * @param paramMap 带过滤
     * @return
     */
    PayInsideRefund findSum(Map<String, Object> paramMap);
}
