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
 * 内部车和车牌号绑定记录(PayInsidePlateBind)实体类
 *
 * @author makejava
 * @since 2019-05-22 17:54:52
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_inside_plate_bind")
public class PayInsidePlateBind extends BaseDO<PayInsidePlateBind> implements Syncable {
    private static final long serialVersionUID = -34834261275079575L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //内部车id
    @NotNull(message = "内部车id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("inside_id")
    private Long insideId;

    //车牌号
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    @TableField("is_sync")
    private Integer isSync;

    @TableField("park_id")
    private Long parkId;

    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    @Length(message = "备注字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remark")
    private String remark;

    @TableField(exist = false)
    private Long pkey;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
