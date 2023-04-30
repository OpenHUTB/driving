package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

/**
 * 威富通对账单信息临时储存(PayGatewayBillSwiftpassTemp)实体类
 *
 * @author makejava
 * @since 2019-06-13 14:13:30
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_gateway_bill_swiftpass_temp")
public class PayGatewayBillSwiftpassTemp extends BaseDO<PayGatewayBillSwiftpassTemp> {
    private static final long serialVersionUID = -88161875114465802L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //订单号
    @Length(message = "订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("order_no")
    private String orderNo;

    //是否是退款
    @TableField("is_refund")
    private Integer isRefund;

    //清算金额
    @TableField("settlement_amount")
    private Double settlementAmount;

    //手续费
    @TableField("service_charge")
    private Double serviceCharge;

    //商户id
    @Length(message = "商户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("mch_id")
    private Long mchId;

    /**
     * 总金额
     */
    @TableField("total_amount")
    private Double totalAmount;

    @TableField("swiftpass_order_no")
    private String swiftpassOrderNo;

    @TableField("pay_order_no")
    private String payOrderNo;


    @TableField("pay_time")
    private String payTime;

    /**
     * 支付方式
     */
    @TableField("pay_type")
    private String payType;


}
