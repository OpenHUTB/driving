package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

/**
 * 减免分类表(ParkReliefType)实体类
 *
 * @author jack_wang(wl)
 * @since 2019-08-01 17:02:11
 */

@Data
@Builder
@TableName("t_park_relief_type")
public class ParkReliefType extends BaseDO<ParkReliefType> implements Syncable {
    private static final long serialVersionUID = -47336246909230455L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //减免分类名称
    @Length(message = "减免分类名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("name")
    private String name;

    //减免金额
    @TableField("amount")
    private Integer amount;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //0未同步 1已同步
    @TableField("is_sync")
    private Integer isSync;

    public ParkReliefType() {
    }

    public ParkReliefType(
            Long id,
            String name,
            Integer amount,
            Long parkId,
            String groupCode,
            Integer isSync) {
        this.id = id;
        this.name = name;
        this.amount = amount;
        this.parkId = parkId;
        this.groupCode = groupCode;
        this.isSync = isSync;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

}
