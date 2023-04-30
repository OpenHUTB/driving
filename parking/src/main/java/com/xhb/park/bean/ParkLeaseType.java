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
 * 租户类型(ParkLeaseType)实体类
 *
 * @author jackwong
 * @since 2019-03-13 20:16:37
 */

@Data
@Builder
@TableName("t_park_lease_type")
public class ParkLeaseType extends BaseDO<ParkLeaseType> implements Syncable {
    private static final long serialVersionUID = 895108888269411867L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //车场编号
    @NotNull(message = "车场编号字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //租户类型名称
    @Length(message = "租户类型名称字段的长度最大为64", groups = {Add.class, Update.class}, max = 64)
    @TableField("lease_name")
    private String leaseName;

    //状态：0:启用;1:禁用
    @Length(message = "状态：0:启用;1:禁用字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_disable")
    private String isDisable;

    //是否下发
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //是否是公众号默认类型：0:否;1:是
    @Length(message = "否是公众号默认类型：0:否;1:是字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_mp_default")
    private String isMpDefault;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    public ParkLeaseType() {
    }

    public ParkLeaseType(Long id, Long parkId, String leaseName, String isDisable, Integer isSync, String groupCode, String isMpDefault) {
        this.id = id;
        this.parkId = parkId;
        this.leaseName = leaseName;
        this.isDisable = isDisable;
        this.isSync = isSync;
        this.groupCode = groupCode;
        this.isMpDefault = isMpDefault;
    }
}
