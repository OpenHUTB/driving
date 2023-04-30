package com.xhb.pay.dto;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import lombok.Data;

/**
 * 退款查询
 * by jackwong
 */
@Data
public class RefundQueryDTO extends BaseSwiftpassDTO<RefundQueryDTO> {


    private String service = "unified.trade.refundquery";
    /**
     * 商户退款单号
     */
    @XStreamAlias("out_refund_no")
    private String outRefundNo;

    /**
     * 商户退款单号
     */
    @XStreamAlias("refund_id")
    private String refundId;

}
