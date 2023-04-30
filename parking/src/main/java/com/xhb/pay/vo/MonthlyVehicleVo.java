package com.xhb.pay.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Author: Jun
 * @Description: 车辆包租清单VO
 * @Date: 2020/10/16 17:38
 */
@Data
public class MonthlyVehicleVo {
    /**
     * 内部客户id
     */
    private String insideId;
    /**
     * 车牌号
     */
    private String plateNums;
    /**
     * 最后一次包月结束时间
     */
    private Date endDate;
    /**
     * 租赁类型
     */
    private String monthlyType;
    /**
     * 最后一次缴费金额
     */
    private BigDecimal amount;
}
