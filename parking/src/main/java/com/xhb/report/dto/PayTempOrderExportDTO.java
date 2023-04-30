package com.xhb.report.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import com.github.liaochong.myexcel.core.annotation.ExcludeColumn;
import lombok.Data;

/**
 * <per>
 * 临时订单dto
 *
 * @author wangjie
 * @Date 2019/5/31 16:03
 * </per>
 */
@Data
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "临时订单", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class PayTempOrderExportDTO extends BaseDO<PayTempOrderExportDTO> {

    @ExcelColumn(index = 0, title = "网关支付订单号")
    private String orderNo;//订单编号

    @ExcelColumn(index = 1, title = "停车场名称")
    private String parkName;//所在车场

    @ExcelColumn(index = 2, title = "入口名称")
    private String enterPortName;//入口编码

    @ExcelColumn(index = 3, title = "出口名称")
    private String outPortName;//出口编码

    @ExcelColumn(index = 4, title = "车牌号码")
    private String plateNumber;//车牌号码

    @ExcelColumn(index = 5, title = "车辆类型")
    @Trans(type = "wordbook", key = "record_type")
    private String recordType;// 车辆类型

    @ExcelColumn(index = 6, title = "入场时间")
    private String enterTime;//入场时间

    @ExcelColumn(index = 7, title = "出场时间")
    private String outTime;//出场时间

    @ExcelColumn(index = 8, title = "订单状态")
    @Trans(type = "wordbook", key = "temp_order_status")
    private String orderStatus;//订单状态

    @ExcelColumn(index = 9, title = "应收金额")
    private Double totalAmount;//应收金额

    @ExcelColumn(index = 10, title = "支付方式")
    @Trans(type = "wordbook", key = "pay_type")
    private String payType;//支付方式

    @ExcelColumn(index = 11, title = "第三方支付订单号")
    private String payOrderNo;//第三方支付订单号

    @ExcelColumn(index = 12, title = "支付时间")
    private String payTime;//支付时间

    @ExcelColumn(index = 13, title = "抬杆时间")
    private String liftingRodTime;//抬杆时间

    @ExcelColumn(index = 14, title = "备注")
    private String detail;//详情

    @ExcelColumn(index = 15, title = "缴费方式")
    private String paymentType;//缴费方式

    @ExcelColumn(index = 16, title = "实收金额")
    private Double actualAmount;//实收金额

    @ExcelColumn(index = 17, title = "优惠类型")
    private String discountType; //优惠类型

    @ExcelColumn(index = 18, title = "减免金额")
    private Double discountAmount;//减免金额

    @ExcelColumn(index = 19, title = "停车时长")
    private String parkingTime;//停车时间

    @ExcelColumn(index = 20, title = "收费员")
    private String name;//收费员

    @ExcelColumn(index = 21, title = "现金支付金额")
    private Double cashPay;//现金支付金额

    @ExcelColumn(index = 22, title = "网络支付金额")
    private Double gatePay;//网络支付金额

    @ExcelColumn(index = 23, title = "代金券支付金额")
    private Double cashCouponPay;//代金券支付金额

    @ExcelColumn(index = 24, title = "余额支付")
    private Double balancePay;//余额支付

    @ExcelColumn(index = 25, title = "积分支付")
    private Double integralPay;//积分支付

    @ExcelColumn(index = 26, title = "特殊放行损失")
    private Double specialPay;//特殊放行损失

    @ExcludeColumn
    private Integer isAdvancePay; //是否提前交费

    public PayTempOrderExportDTO() {
    }

    public PayTempOrderExportDTO(String orderNo, String parkName, String enterPortName, String outPortName, String plateNumber, String recordType, String enterTime,
                                 String outTime, String orderStatus, Double totalAmount, String payType, String payOrderNo,
                                 String payTime, String liftingRodTime, String detail, String paymentType, Double actualAmount, String discountType, Double discountAmount,
                                 String parkingTime, String name, Double cashPay, Double gatePay,
                                 Double cashCouponPay, Double balancePay, Double integralPay, Double specialPay) {
        this.orderNo = orderNo;
        this.parkName = parkName;
        this.enterPortName = enterPortName;
        this.outPortName = outPortName;
        this.plateNumber = plateNumber;
        this.recordType = recordType;
        this.enterTime = enterTime;
        this.outTime = outTime;
        this.orderStatus = orderStatus;
        this.totalAmount = totalAmount;
        this.payType = payType;
        this.payOrderNo = payOrderNo;
        this.payTime = payTime;
        this.liftingRodTime = liftingRodTime;
        this.detail = detail;
        this.paymentType = paymentType;
        this.actualAmount = actualAmount;
        this.discountType = discountType;
        this.discountAmount = discountAmount;
        this.parkingTime = parkingTime;
        this.name = name;
        this.cashPay = cashPay;
        this.gatePay = gatePay;
        this.cashCouponPay = cashCouponPay;
        this.balancePay = balancePay;
        this.integralPay = integralPay;
        this.specialPay = specialPay;
    }
}
