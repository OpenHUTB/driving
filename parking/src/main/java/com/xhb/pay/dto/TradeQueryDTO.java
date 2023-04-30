package com.xhb.pay.dto;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import lombok.Data;

/**
 * 订单查询
 * by jackwong
 */
@Data
@XStreamAlias("xml")
public class TradeQueryDTO extends BaseOrderSwiftpassDTO<TradeQueryDTO> {


    private String service = "unified.trade.query";


}
