package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.xhb.park.bean.Syncable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 临时费用(临时订单)详单(PayTempOrderFeeDepict)实体类
 *
 * @author jackwong
 * @since 2019-03-29 15:28:44
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_temp_order_fee_depict")
public class PayTempOrderFeeDepict extends BaseDO<PayTempOrderFeeDepict> implements Syncable {
    private static final long serialVersionUID = 991274824302490595L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //临时订单id
    @NotNull(message = "临时订单id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("temp_order_id")
    private Long tempOrderId;

    //开始时间
    @NotEmpty
    @NotNull(message = "开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_time")
    private String startTime;

    //结束时间
    @NotEmpty
    @NotNull(message = "结束时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "结束时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_time")
    private String endTime;

    //单价
    @NotNull(message = "单价字段不可为null", groups = {Update.class, Delete.class})
    @TableField("price")
    private Double price;

    //总价格
    @NotNull(message = "总价格字段不可为null", groups = {Update.class, Delete.class})
    @TableField("total_amount")
    private Double totalAmount;

    /**
     * 本费用是哪天的
     */
    @TableField("fee_day_id")
    private Long feeDayId;//

    //所在车场
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @TableField("is_sync")
    private Integer isSync;

    //结余时长(分钟数)
    @TableField("balance_minutes")
    private Integer balanceMinutes;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
