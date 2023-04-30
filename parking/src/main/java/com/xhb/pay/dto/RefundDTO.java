package com.xhb.pay.dto;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import lombok.Data;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 退款查询
 * by jackwong
 */
@XmlRootElement
@Data
public class RefundDTO extends BaseOrderSwiftpassDTO<RefundDTO> {


    private String service = "unified.trade.refund";

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

    /**
     * 订单总金额 分
     */
    @XStreamAlias("total_fee")
    private Integer totalFee;

    /**
     * 本次退款金额 分
     */
    @XStreamAlias("total_fee")
    private Integer refundFee;

    /**
     * 退款操作员商户号
     */
    @XStreamAlias("op_user_id")
    private Integer opUserId;

    /**
     * ORIGINAL-原路退款，可以不写
     */
    @XStreamAlias("refund_channel")
    private Integer refundChannel;


}
