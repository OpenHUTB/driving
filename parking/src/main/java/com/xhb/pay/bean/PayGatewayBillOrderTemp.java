package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 对账单临时表(PayGatewayBillOrderTemp)实体类
 *
 * @author makejava
 * @since 2019-06-13 15:36:40
 */

@Data
@Builder
@TableName("t_pay_gateway_bill_order_temp")
public class PayGatewayBillOrderTemp extends BaseDO<PayGatewayBillOrderTemp> {
    private static final long serialVersionUID = 712395843131512825L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //订单号
    @NotEmpty
    @NotNull(message = "订单号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("order_no")
    private String orderNo;

    //总金额
    @NotNull(message = "总金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("total_amount")
    private Integer totalAmount;

    //是否已经对过账
    @TableField("is_reconciliation")
    private Integer isReconciliation;

    //清算金额
    @TableField("settlement_amount")
    private Double settlementAmount;

    //服务费
    @TableField("service_charge")
    private Double serviceCharge;

    //商户id
    @NotNull(message = "商户id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("mch_id")
    private Long mchId;

    //威富通金额
    @TableField("swiftpass_amount")
    private Double swiftpassAmount;


    public PayGatewayBillOrderTemp() {
    }

    public PayGatewayBillOrderTemp(
            Long id,
            String orderNo,
            Integer totalAmount,
            Integer isReconciliation,
            Double settlementAmount,
            Double serviceCharge,
            Long mchId,
            Double swiftpassAmount
    ) {
        this.id = id;
        this.orderNo = orderNo;
        this.totalAmount = totalAmount;
        this.isReconciliation = isReconciliation;
        this.settlementAmount = settlementAmount;
        this.serviceCharge = serviceCharge;
        this.mchId = mchId;
        this.swiftpassAmount = swiftpassAmount;
    }


}
