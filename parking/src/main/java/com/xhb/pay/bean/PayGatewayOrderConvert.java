package com.xhb.pay.bean;

import java.io.Serializable;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.*;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.mybatis.jpa.annotation.*;
import com.fhs.core.group.*;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.*;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * 订单号转换(PayGatewayOrderConvert)实体类
 *
 * @author jack_wang(wl)
 * @since 2019-09-03 15:00:14
 */

@Data
@Builder
@TableName("t_pay_gateway_order_convert")
public class PayGatewayOrderConvert extends BaseDO<PayGatewayOrderConvert> {
    private static final long serialVersionUID = 526751962570893000L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车系统订单号
    @NotEmpty
    @NotNull(message = "停车系统订单号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "停车系统订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("gateway_order_no")
    private String gatewayOrderNo;

    //交大一附院第三方支付订单号
    @NotEmpty
    @NotNull(message = "交大一附院第三方支付订单号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "交大一附院第三方支付订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("out_trade_no")
    private String outTradeNo;


    public PayGatewayOrderConvert() {
    }

    public PayGatewayOrderConvert(
            Long id,
            String gatewayOrderNo,
            String outTradeNo) {
        this.id = id;
        this.gatewayOrderNo = gatewayOrderNo;
        this.outTradeNo = outTradeNo;
    }


}
