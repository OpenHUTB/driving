package com.xhb.report.vo;

import lombok.Data;

/**
 * <per>
 * 线下收费统计实体
 *
 * @author wangjie
 * @Date 2019/5/28 15:50
 * </per>
 */
@Data
public class TollCollectorReportVo {

    private Long parkId;//停车场id
    private String collectorId;//收费员id
    private String parkName;//停车场名称
    private String name;//收费员名称
    private String payTime;//支付日期
    private Integer strokeNumber;//线下支付笔数
    private Double actualAmount;//线下支付金额
    private Integer specialPassNumber;//异常放行次数
    private Double specialPay;//异常放行损失
    private Double cashPay;//手动抬杆金额
    private Integer cashNumber;//手动抬杆次数

    public TollCollectorReportVo() {
    }

    public TollCollectorReportVo(Long parkId, String collectorId, String parkName, String name, String payTime, Integer strokeNumber,
                                 Double actualAmount, Integer specialPassNumber, Double specialPay, Double cashPay, Integer cashNumber) {
        this.parkId = parkId;
        this.collectorId = collectorId;
        this.parkName = parkName;
        this.name = name;
        this.payTime = payTime;
        this.strokeNumber = strokeNumber;
        this.actualAmount = actualAmount;
        this.specialPassNumber = specialPassNumber;
        this.specialPay = specialPay;
        this.cashPay = cashPay;
        this.cashNumber = cashNumber;
    }
}
