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
 * 一个订单可能是多天，这是一天的费用信息(PayTempOrderFeeDay)实体类
 *
 * @author jackwong
 * @since 2019-04-01 15:56:17
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_temp_order_fee_day")
public class PayTempOrderFeeDay extends BaseDO<PayTempOrderFeeDay> implements Syncable {
    private static final long serialVersionUID = 967047864876068409L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //收费日期yyyy-MM-dd
    @NotEmpty
    @NotNull(message = "收费日期yyyy-MM-dd字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "收费日期yyyy-MM-dd字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("fee_date")
    private String feeDate;

    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    @TableField("temp_order_id")
    private Long tempOrderId;

    //所在车场
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @TableField("is_sync")
    private Integer isSync;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
