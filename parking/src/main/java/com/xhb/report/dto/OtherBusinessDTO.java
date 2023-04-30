package com.xhb.report.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 其它业务
 *
 * @author wangjie
 * @Date 2019/6/13 11:33
 * </per>
 */
@Data
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "其它业务", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class OtherBusinessDTO extends BaseDO<OtherBusinessDTO> {

    @ExcelColumn(index = 1, title = "日期")
    private String payTime;//日期

    @ExcelColumn(index = 2, title = "商户充值金额")
    private Double businessRechargeAmount;//商户充值金额

    @ExcelColumn(index = 3, title = "充值商户数")
    private Integer businessRechargeCount;//充值商户数

    @ExcelColumn(index = 4, title = "代金卷使用张数")
    private Integer couponUsedCount;//代金卷使用张数

    @ExcelColumn(index = 5, title = "储值金额")
    private Double rechargeAmount;//储值金额

    @ExcelColumn(index = 6, title = "储值用户数")
    private Integer rechargeNumber;//储值用户数

    @ExcelColumn(index = 7, title = "退费金额")
    private Double refundAmount;//退费金额

    @ExcelColumn(index = 8, title = "退费用户数")
    private Integer refundNumber;//退费用户数

    @ExcelColumn(index = 9, title = "储值卡用户当日扣费")
    private Double rechargeCarCharging;//储值卡用户当日扣费

    @ExcelColumn(index = 10, title = "储值卡用户余额")
    private Double rechargeCarSurplus;//储值卡用户余额

    @ExcelColumn(index = 11, title = "储值卡余额>0的用户数")
    private Integer rechargeSurplusNumber;//储值卡余额>0的用户数

    private Long parkId;//停车场id

    public OtherBusinessDTO() {
    }

    public OtherBusinessDTO(String payTime, Double businessRechargeAmount, Integer businessRechargeCount, Integer couponUsedCount, Double rechargeAmount, Integer rechargeNumber, Double refundAmount, Integer refundNumber, Double rechargeCarCharging, Double rechargeCarSurplus, Integer rechargeSurplusNumber) {
        this.payTime = payTime;
        this.businessRechargeAmount = businessRechargeAmount;
        this.businessRechargeCount = businessRechargeCount;
        this.couponUsedCount = couponUsedCount;
        this.rechargeAmount = rechargeAmount;
        this.rechargeNumber = rechargeNumber;
        this.refundAmount = refundAmount;
        this.refundNumber = refundNumber;
        this.rechargeCarCharging = rechargeCarCharging;
        this.rechargeCarSurplus = rechargeCarSurplus;
        this.rechargeSurplusNumber = rechargeSurplusNumber;
    }
}
