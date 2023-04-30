package com.xhb.pay.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.park.bean.UcenterTollCollector;
import lombok.Data;

/**
 * <per>
 * 临时订单导出
 *
 * @author wangy
 * @Date 2019/6/27 14:40
 * </per>
 */
@Data
@TransTypes(types = {"pagex", "wordbook"})
@ExcelTable(sheetName = "临时订单导出", workbookType = WorkbookType.SXLSX, excludeParent = true, includeAllField = false)
public class PayTempOrderDTO extends BaseDO<PayTempOrderDTO> {

    private Long id;

    @ExcelColumn(index = 0, title = "支付网关订单号")
    private String orderNo;//支付网关订单号

    @Trans(type = TransType.SIMPLE,target = ParkParking.class,fields = "parkName")
    private Long parkId; //停车场

    @ExcelColumn(index = 1, title = "停车场名称")
    private String parkName; //停车场


    @Trans(type = TransType.SIMPLE,target = ParkParkingPort.class,fields = "portName")
    private Long portId; //出口id

    @Trans(type = TransType.SIMPLE,target = ParkParkingPort.class,fields = "portName",alias = "enterPort")
    private String enterPort; //入口id

    @ExcelColumn(index = 2, title = "出口名称")
    private String outPortName;//出口名称

    @ExcelColumn(index = 3, title = "入口名称")
    private String enterPortName;//出入口

    @ExcelColumn(index = 4, title = "车牌号")
    private String plateNumber;//车牌号

    @Trans(type = "wordbook", key = "record_type")
    @ExcelColumn(index = 5, title = "车辆性质")
    private String carRecordType;//车辆性质

    @ExcelColumn(index = 6, title = "入场时间")
    private String enterTime;//入场时间

    @ExcelColumn(index = 7, title = "出场时间")
    private String outTime;//出场时间

    @Trans(type = "wordbook", key = "temp_order_status")
    private String orderStatus;//订单状态

    @ExcelColumn(index = 8, title = "订单状态")
    private String orderStatusName;//订单状态

    @Trans(type = "wordbook", key = "pay_type")
    private String payType;//支付方式

    @ExcelColumn(index = 9, title = "支付方式")
    private String payTypeName;//支付方式

    @ExcelColumn(index = 10, title = "应收金额")
    private String totalAmount;//应收金额

    @ExcelColumn(index = 11, title = "第三方支付订单号")
    private String payOrderNo;//第三方支付订单号

    @ExcelColumn(index = 12, title = "支付时间")
    private String payTime;//支付时间

    @Trans(type = "wordbook", key = "yesOrNo")
    private String isSync;//是否已下发

    @ExcelColumn(index = 13, title = "是否已下发")
    private String isSyncName;//是否已下发

    @Trans(type = "wordbook", key = "is_online")
    @ExcelColumn(index = 14, title = "缴费方式")
    private String isOnline;//缴费方式,场内扫码为提前缴费

    @ExcelColumn(index = 15, title = "应补金额")
    private String actualAmount;//实收金额

    @ExcelColumn(index = 16, title = "优惠金额")
    private String discountAmount;//优惠金额

    @Trans(type = "wordbook", key = "offline_pay_type")
    private String offlinePayType;//线下支付方式

    @ExcelColumn(index = 17, title = "线下支付方式")
    private String offlinePayTypeName;//线下支付方式

    @ExcelColumn(index = 18, title = "停车用时")
    private String parkingTime;//停车用时

    @ExcelColumn(index = 19, title = "收费员")
    @Trans(type = TransType.SIMPLE,target = UcenterTollCollector.class,fields = "name",alias = "user")
    private String collectorId; //收费员

    @ExcelColumn(index = 20, title = "现金支付金额")
    private String cashPay;//现金支付金额

    @ExcelColumn(index = 21, title = "网络支付金额")
    private String gatePay;//网络支付金额

    //@ExcelColumn(index = 22, title = "代金券支付金额")
    private String cashCouponPay;//代金券支付金额

    @ExcelColumn(index = 23, title = "余额支付金额")
    private String balancePay;//余额支付金额

    //@ExcelColumn(index = 24, title = "积分支付金额")
    private String integralPay;//积分支付金额

    @ExcelColumn(index = 25, title = "特殊放行损失")
    private String specialPay;//特殊放行损失

    //@ExcelColumn(index = 26, title = "代金券抵扣时长")
    private String cashCouponHours;//代金券抵扣时长

    //@ExcelColumn(index = 27, title = "代金券优惠额度")
    private String cashCouponRadio;//代金券优惠额度

    @ExcelColumn(index = 28, title = "详情")
    private String detail;//减免描述

    private String outId;//出场记录id
    private String enterId; //入场记录id

    //同步状态
    //@ExcelColumn(index = 29, title = "同步状态")
    @Trans(type = "wordbook", key = "syn_status")
    private String synStatus;

    //抬杆时间
    @ExcelColumn(index = 30, title = "抬杆时间")
    private String liftingRodTime;

    //车辆类型
    @ExcelColumn(index = 31, title = "车辆类型")
    @Trans(type = "wordbook", key = "car_type")
    private String carType;

    //@ExcelColumn(index = 32, title = "创建时间")
    private String createTime;

    public PayTempOrderDTO() {
    }

    public PayTempOrderDTO(Long id, String orderNo, Long parkId, Long portId, String enterPort, String outPortName, String enterPortName, String plateNumber, String carRecordType, String enterTime, String outTime, String orderStatus, String orderStatusName, String payType, String payTypeName, String totalAmount, String payOrderNo, String payTime, String isSync, String isSyncName, String isOnline, String actualAmount, String discountAmount, String offlinePayType, String offlinePayTypeName, String parkingTime, String collectorId, String cashPay, String gatePay, String cashCouponPay, String balancePay, String integralPay, String specialPay, String cashCouponHours, String cashCouponRadio, String detail, String outId, String enterId, String synStatus, String liftingRodTime, String carType, String createTime) {
        this.id = id;
        this.orderNo = orderNo;
        this.parkId = parkId;
        this.portId = portId;
        this.enterPort = enterPort;
        this.outPortName = outPortName;
        this.enterPortName = enterPortName;
        this.plateNumber = plateNumber;
        this.carRecordType = carRecordType;
        this.enterTime = enterTime;
        this.outTime = outTime;
        this.orderStatus = orderStatus;
        this.orderStatusName = orderStatusName;
        this.payType = payType;
        this.payTypeName = payTypeName;
        this.totalAmount = totalAmount;
        this.payOrderNo = payOrderNo;
        this.payTime = payTime;
        this.isSync = isSync;
        this.isSyncName = isSyncName;
        this.isOnline = isOnline;
        this.actualAmount = actualAmount;
        this.discountAmount = discountAmount;
        this.offlinePayType = offlinePayType;
        this.offlinePayTypeName = offlinePayTypeName;
        this.parkingTime = parkingTime;
        this.collectorId = collectorId;
        this.cashPay = cashPay;
        this.gatePay = gatePay;
        this.cashCouponPay = cashCouponPay;
        this.balancePay = balancePay;
        this.integralPay = integralPay;
        this.specialPay = specialPay;
        this.cashCouponHours = cashCouponHours;
        this.cashCouponRadio = cashCouponRadio;
        this.detail = detail;
        this.outId = outId;
        this.enterId = enterId;
        this.synStatus = synStatus;
        this.liftingRodTime = liftingRodTime;
        this.carType = carType;
        this.createTime = createTime;
    }
}
