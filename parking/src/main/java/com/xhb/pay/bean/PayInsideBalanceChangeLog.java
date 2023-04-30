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
 * 内部车余额变动日志(PayInsideBalanceChangeLog)实体类
 *
 * @author makejava
 * @since 2019-05-23 12:10:50
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_inside_balance_change_log")
public class PayInsideBalanceChangeLog extends BaseDO<PayInsideBalanceChangeLog> implements Syncable {
    private static final long serialVersionUID = -76932681434621260L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //0充值 1 赠送金额充值 2 包月充值 3包月扣费 4 包时段扣费
    @NotNull(message = "0充值 1 赠送金额充值 2 包月充值 3包月扣费 4 包时段扣费字段不可为null", groups = {Update.class, Delete.class})
    @TableField("type")
    private Integer type;

    //金额
    @NotNull(message = "金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    //发生金额变动的外键
    @NotNull(message = "发生金额变动的外键字段不可为null", groups = {Update.class, Delete.class})
    @TableField("p_key")
    private Long pKey;

    //是否同步
    @NotNull(message = "是否同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //备注
    @NotEmpty
    @NotNull(message = "备注字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "备注字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("remark")
    private String remark;

    //是否是添加金额
    @NotNull(message = "是否是添加金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_add")
    private Integer isAdd;

    //内部车id
    @NotNull(message = "内部车id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("inside_id")
    private Long insideId;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
