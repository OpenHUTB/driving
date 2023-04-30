package com.xhb.park.bean;

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
 * 黑名单表(历史记录)  入口判断(ParkBlacklist)实体类
 *
 * @author jackwong
 * @since 2019-03-13 20:08:13
 */

@Data
@Builder
@TableName("t_park_blacklist")
public class ParkBlacklist extends BaseDO<ParkBlacklist> implements Syncable {
    private static final long serialVersionUID = -51537155666394694L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    //状态 0：解除 1：未解除
    @NotEmpty
    @NotNull(message = "状态 0：解除 1：未解除字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "状态 0：解除 1：未解除字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("lock_status")
    private String lockStatus;

    //黑名单原因
    @Length(message = "黑名单原因字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("description")
    private String description;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //是否下发
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    public ParkBlacklist() {
    }

    public ParkBlacklist(Long id, String plateNumber, String lockStatus, String description, Long parkId, Integer isSync, String groupCode) {
        this.id = id;
        this.plateNumber = plateNumber;
        this.lockStatus = lockStatus;
        this.description = description;
        this.parkId = parkId;
        this.isSync = isSync;
        this.groupCode = groupCode;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
