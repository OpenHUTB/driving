package com.xhb.road.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 预存费用(PayAdvancePayOrder)实体类
 *
 * @author jack_wang(wl)
 * @since 2019-09-05 18:36:32
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_advance_pay_order")
public class PayAdvancePayOrder extends BaseDO<PayAdvancePayOrder> {
    private static final long serialVersionUID = -40952557387462852L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @TableField("enter_id")
    private Long enterId;

    @NotEmpty
    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "${column.comment}字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    @NotEmpty
    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //预付费小时数
    @NotNull(message = "预付费小时数字段不可为null", groups = {Update.class, Delete.class})
    @TableField("hours")
    private Integer hours;

    //预付费金额
    @NotNull(message = "预付费金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    //放大金额
    @NotNull(message = "放大金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("enlarged_amount")
    private Double enlargedAmount;

    //网关订单号
    @Length(message = "网关订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("order_no")
    private String orderNo;

    //支付方式
    @TableField("pay_type")
    private Integer payType;

    //是否在线支付
    @NotNull(message = "是否在线支付字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_online")
    private Integer isOnline;

    //收费员id
    @TableField("collector_id")
    private Long collectorId;

    //支付成功时间
    @Length(message = "支付成功时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("pay_time")
    private String payTime;

    //订单状态0：未支付 1：已支付 5:异常订单  2已过期
    @NotNull(message = "订单状态0：未支付 1：已支付 5:异常订单  2已过期字段不可为null", groups = {Update.class, Delete.class})
    @TableField("order_status")
    private Integer orderStatus;

    //临时订单id，使用过的都要有这个
    @TableField("temp_order_id")
    private Long tempOrderId;

    //超时时间
    @Length(message = "超时时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("out_time")
    private String outTime;

    //前端用户Id
    @TableField("user_id")
    private String userId;

}
