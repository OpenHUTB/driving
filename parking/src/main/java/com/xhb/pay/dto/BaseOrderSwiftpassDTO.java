package com.xhb.pay.dto;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import lombok.Data;

@Data
public class BaseOrderSwiftpassDTO<T extends BaseOrderSwiftpassDTO> extends BaseSwiftpassDTO<T> {
    /**
     * 商户系统内部的订单号
     */
    @XStreamAlias("out_trade_no")
    private String outTradeNo;

    /**
     * 商户系统内部的订单号
     */
    @XStreamAlias("transaction_id")
    private String transactionId;

    /**
     * api版本号
     */
    private String version = "2.0";

    private String charset = "UTF-8";

}
