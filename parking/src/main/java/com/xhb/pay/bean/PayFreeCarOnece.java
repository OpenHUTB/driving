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
 * 一次性免费车(PayFreeCarOnece)实体类
 *
 * @author makejava
 * @since 2019-04-12 14:24:57
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_free_car_onece")
public class PayFreeCarOnece extends BaseDO<PayFreeCarOnece> implements Discountable, Syncable {
    private static final long serialVersionUID = -76831229257849985L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plat_number")
    private String platNumber;

    //减免比例0-100
    @NotNull(message = "减免比例0-100字段不可为null", groups = {Update.class, Delete.class})
    @TableField("radio")
    private Integer radio;

    //备注
    @Length(message = "备注字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("remark")
    private String remark;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //申请人
    @NotEmpty
    @NotNull(message = "申请人字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "申请人字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("apply_user")
    private String applyUser;

    //是否已经使用过

    @NotNull(message = "是否已经使用过字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_used")
    private Integer isUsed;
    //入场记录id
    @TableField("enter_id")
    private Long enterId;

    /**
     * 是否已经下发
     */
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
