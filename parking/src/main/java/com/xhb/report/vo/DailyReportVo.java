package com.xhb.report.vo;

import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 日报表
 *
 * @author wangjie
 * @Date 2019/5/30 11:20
 * </per>
 */
@Data
@ExcelTable(sheetName = "月报表", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class DailyReportVo {

    @ExcelColumn(order = 1, title = "日期")
    private String payTime;//日期

    @ExcelColumn(order = 2, title = "应收")
    private Double receivable;//应收

    @ExcelColumn(order = 3, title = "实收")
    private Double realIncome;//实收

    @ExcelColumn(order = 4, title = "出场次数")
    private Integer outNumber;//出场次数

    @ExcelColumn(order = 5, title = "岗亭现金(不包括手动抬杆)")
    private Double cashPay;//岗亭现金

    @ExcelColumn(order = 6, title = "岗亭现金(手动抬杆)")
    private Double cashPayLow;//岗亭现金

    @ExcelColumn(order = 7, title = "网络支付")
    private Double gatePay;//网络支付

    @ExcelColumn(order = 8, title = "储值卡支付")
    private Double balancePay;//储值卡支付

    @ExcelColumn(order = 9, title = "积分支付")
    private Double integralPay;//积分支付

    @ExcelColumn(order = 10, title = "优免券")
    private Double cashCouponPay;//优免券

    @ExcelColumn(order = 11, title = "优免券使用数量")
    private Integer cashCouponNumber;//优免券使用数量

    @ExcelColumn(order = 12, title = "特殊处理损失")
    private Double specialPay;//特殊处理损失

    @ExcelColumn(order = 13, title = "后台系统月租户")
    private Double systemMonthly;//后台系统月租户

    @ExcelColumn(order = 14, title = "公众号/服务号月租户包月")
    private Double publicMonthly;//公众号/服务号月租户包月

    @ExcelColumn(order = 15, title = "APP月租户包月")
    private Double appMonthly;//APP月租户包月

    @ExcelColumn(order = 16, title = "后台系统储值卡充值")
    private Double systemStorageCard;//后台系统储值卡充值

    @ExcelColumn(order = 17, title = "后台系统退卡")
    private Double systemRefund;//后台系统退卡

    @ExcelColumn(order = 18, title = "退款扣手续费")
    private Double refundServiceAmount;//退款扣手续费

    @ExcelColumn(order = 19, title = "退款扣赠送金额")
    private Double refundGiveAmount;//退款扣赠送金额

    @ExcelColumn(order = 20, title = "退款扣赠送金额")
    private Double discountAmount;//优惠金额

    public DailyReportVo() {
    }

    public DailyReportVo(String payTime, Double receivable, Double realIncome, Integer outNumber, Double cashPay, Double cashPayLow,
                         Double gatePay, Double balancePay, Double integralPay, Double cashCouponPay, Integer cashCouponNumber,
                         Double specialPay, Double systemMonthly, Double publicMonthly, Double appMonthly, Double systemStorageCard,
                         Double systemRefund, Double refundServiceAmount, Double refundGiveAmount, Double discountAmount) {
        this.payTime = payTime;
        this.receivable = receivable;
        this.realIncome = realIncome;
        this.outNumber = outNumber;
        this.cashPay = cashPay;
        this.cashPayLow = cashPayLow;
        this.gatePay = gatePay;
        this.balancePay = balancePay;
        this.integralPay = integralPay;
        this.cashCouponPay = cashCouponPay;
        this.cashCouponNumber = cashCouponNumber;
        this.specialPay = specialPay;
        this.systemMonthly = systemMonthly;
        this.publicMonthly = publicMonthly;
        this.appMonthly = appMonthly;
        this.systemStorageCard = systemStorageCard;
        this.systemRefund = systemRefund;
        this.refundServiceAmount = refundServiceAmount;
        this.refundGiveAmount = refundGiveAmount;
        this.discountAmount = discountAmount;
    }
}
