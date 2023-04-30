package com.xhb.road.dto;

import lombok.Data;

/**
 * APP路边停车线下收费明细
 *
 * @author yutao
 * @since 2019-08-29 16:47:33
 */
@Data
public class RoadDownChargeDto {
    //车牌号
    private String plateNumber;

    //付费时间
    private String payTime;

    //金额
    private Double amount;

    //类型 0补收费用 1 追缴欠费 2 预付费
    private Integer tpye;
}
