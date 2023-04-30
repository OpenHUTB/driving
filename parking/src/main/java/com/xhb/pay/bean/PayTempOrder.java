package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.Syncable;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiParam;
import lombok.*;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 临时入场出厂缴费(PayTempOrder)实体类
 *
 * @author jackwong
 * @since 2019-03-07 13:03:09
 */

@ApiModel("临时订单返回参数")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_temp_order")
@TransTypes(types = {"pagex", "wordbook"})
@EqualsAndHashCode
public class PayTempOrder extends BaseDO<PayTempOrder> implements Syncable {
    private static final long serialVersionUID = 205684543656682002L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //订单编号
    @Length(message = "订单编号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("order_no")
    private String orderNo;

    //所在车场
    @ApiParam(value = "停车场id")
    @NotNull(message = "所在车场字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    @Trans(type = "pagex", key = "parking")
    private Long parkId;

    //出口编码
    @TableField("port_id")
    private Long portId;

    //车牌号码
    @ApiParam(value = "车牌号码")
    @NotEmpty
    @NotNull(message = "车牌号码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号码字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    //入场时间
    @ApiParam(value = "入场时间")
    @NotEmpty
    @NotNull(message = "入场时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "入场时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("enter_time")
    private String enterTime;

    //出场时间
    @ApiParam(value = "入场时间")
    @Length(message = "出场时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("out_time")
    private String outTime;

    //入场记录id
    @NotNull(message = "入场记录id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("enter_id")
    private Long enterId;

    //出厂记录id
    @TableField("out_id")
    private Long outId;

    //订单状态0：未支付 1：已支付 3：免费放行;4:黑名单放行 5:异常订单 -1:撤销
    @NotNull(message = "订单状态0：未支付 1：已支付 3：免费放行;4:黑名单放行 5:异常订单 -1:撤销字段不可为null", groups = {Update.class, Delete.class})
    @TableField("order_status")
    private Integer orderStatus;

    //停车总费
    @ApiParam(value = "停车总费")
    @NotNull(message = "停车总费字段不可为null", groups = {Update.class, Delete.class})
    @TableField("total_amount")
    private Double totalAmount;

    //支付方式 见字典 需要区分线上线下支付宝微信
    @TableField("pay_type")
    private Integer payType;

    //第三方支付订单号
    @Length(message = "第三方支付订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("pay_order_no")
    private String payOrderNo;

    //支付时间
    @Length(message = "支付时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("pay_time")
    private String payTime;


    //详情
    @Length(message = "详情字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("detail")
    private String detail;

    //0 未同步 1 已下发 2 完成
    @NotEmpty
    @NotNull(message = "0 未同步 1 已下发 2 完成字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "0 未同步 1 已下发 2 完成字段的长度最大为11", groups = {Add.class, Update.class}, max = 11)
    @TableField("syn_status")
    private Integer synStatus;

    //0 线下缴费 1 线上缴费
    @Length(message = "0 线下缴费 1 线上缴费字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_online")
    private String isOnline;

    //如果是注册用户支付需要记录用户id
    @Length(message = "如果是注册用户支付需要记录用户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("user_id")
    private String userId;

    //实收金额
    @ApiParam(value = "实收金额")
    @NotNull(message = "实收金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("actual_amount")
    private Double actualAmount;

    //优惠金额
    @ApiParam(value = "优惠金额")
    @NotNull(message = "优惠金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("discount_amount")
    private Double discountAmount;


    //停车分钟数
    @ApiParam(value = "停车分钟数")
    @TableField("parking_time")
    private Integer parkingTime;

    //是否已经下发
    @TableField("is_sync")
    private Integer isSync;

    //收费员id
    @TableField("collector_id")
    private Long collectorId;

    //线下支付方式0现金
    @Length(message = "线下支付方式0现金字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("offline_pay_type")
    private String offlinePayType;

    //集团编码
    @NotEmpty
    @NotNull(message = "集团编码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //入口
    @TableField("enter_port")
    private Long enterPort;

    //现金支付金额
    @TableField("cash_pay")
    private Double cashPay;

    //网络支付金额
    @TableField("gate_pay")
    private Double gatePay;

    //代金券id
    @TableField("cash_coupon_id")
    private Long cashCouponId;

    //代金券支付金额
    @TableField("cash_coupon_pay")
    private Double cashCouponPay;

    //余额支付
    @TableField("balance_pay")
    private Double balancePay;

    //积分支付
    @TableField("integral_pay")
    private Double integralPay;

    //特殊放行损失
    @TableField("special_pay")
    private Double specialPay;

    //特殊放行id
    @TableField("special_pass_id")
    private Long specialPassId;

    //代金券抵扣时长
    @TableField("cash_coupon_hours")
    private Integer cashCouponHours;

    //代金券优惠额度100代表优惠100%
    @TableField("cash_coupon_radio")
    private Integer cashCouponRadio;

    //抬杆时间
    @TableField("lifting_rod_time")
    private String liftingRodTime;

    //是否提前交费
    @TableField("is_advance_pay")
    private Integer isAdvancePay;

    //减免分类
    @TableField("relief_type")
    private String reliefType;


    /**
     * 实际收钱的停车场id
     */
    @TableField("receiving_park_id")
    private Long receivingParkId;

    /**
     * 停车场ids，仅仅用来做参数过滤用的，db中没有此字段
     */
    @TableField(exist = false)
    private String parkIds;

    /**
     * 车牌类型
     */
    @ApiParam(value = "车牌类型")
    @TableField("car_record_type")
    private Integer carRecordType;

    /**
     * 车辆性质 0 临时车 1月租车 2免费车
     */
    @TableField("car_type")
    @Trans(type = "wordbook", key = "car_type")
    private Integer carType;

    @TableField("advance_pay")
    private Double advancePay;


    @ApiParam(value = "停放时长描述")
    @TableField(exist = false)
    private String parkTimeDesc;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    /**
     * 当获取优惠活动，或者免费车，获取包月车辆的时候，使用这个parkid
     * 这个会优先取钱实际是哪个park就用哪个park
     *
     * @return parkid
     */
    public Long getRealParkId() {
        if (this.receivingParkId != null) {
            return this.receivingParkId;
        }
        return this.parkId;
    }

}
