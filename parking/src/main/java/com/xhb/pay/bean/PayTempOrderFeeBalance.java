package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.xhb.park.bean.Syncable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

/**
 * 结余时长计费(PayTempOrderFeeBalance)实体类
 *
 * @author makejava
 * @since 2019-05-06 20:56:00
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_temp_order_fee_balance")
public class PayTempOrderFeeBalance extends BaseDO<PayTempOrderFeeBalance> implements Syncable {
    private static final long serialVersionUID = 578321314619831265L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //是否同步1已同步0未同步
    @NotNull(message = "是否同步1已同步0未同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //单价
    @NotNull(message = "单价字段不可为null", groups = {Update.class, Delete.class})
    @TableField("price")
    private Double price;

    //结余时长(分钟)
    @NotNull(message = "结余时长(分钟)字段不可为null", groups = {Update.class, Delete.class})
    @TableField("minutes")
    private Integer minutes;

    //总金额
    @NotNull(message = "总金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    //临时订单id
    @NotNull(message = "临时订单id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("temp_order_id")
    private Long tempOrderId;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
