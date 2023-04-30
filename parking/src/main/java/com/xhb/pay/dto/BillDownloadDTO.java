package com.xhb.pay.dto;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import lombok.Data;

/**
 * 对账单下载
 */
@Data
@XStreamAlias("xml")
public class BillDownloadDTO extends BaseSwiftpassDTO<BillDownloadDTO> {

    /**
     * 下载单个商户对账单
     */
    private String service = "pay.bill.merchant";


    @XStreamAlias("bill_date")
    private String billDate;
    @XStreamAlias("bill_type")
    private String billType;

}
