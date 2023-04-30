package com.xhb.report.dto;

import lombok.Data;

@Data
public class StatementOfAccountsReceivableDTO {
    /**
     * id
     */
    private Long parkId;
    /**
     * 停车场名称
     */
    private String parkName;
    /**
     * 车辆通行总数
     */
    private String totalCar;
    /**
     * 通行时间
     */
    private String outTime;
    /**
     * 应收总金额
     */
    private String totalAmount;
    /**
     * 实收总金额
     */
    private String actualAmount;
}
