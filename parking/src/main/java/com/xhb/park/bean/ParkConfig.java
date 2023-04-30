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
 * (ParkConfig)实体类
 *
 * @author jackwong
 * @since 2019-03-13 20:15:15
 */

@Data
@Builder
@TableName("t_park_config")
public class ParkConfig extends BaseDO<ParkConfig> implements Syncable {
    private static final long serialVersionUID = -77846054536626757L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //配置编码，唯一
    @Length(message = "配置编码，唯一字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("config_code")
    private String configCode;

    //配置项名称
    @NotEmpty
    @NotNull(message = "配置项名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "配置项名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("config_name")
    private String configName;

    //车场编码,配置关联车场
    @TableField("park_id")
    private Long parkId;

    //配置项值
    @NotEmpty
    @NotNull(message = "配置项值字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "配置项值字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("config_value")
    private String configValue;


    //状态:0:可用 1 ：禁用
    @NotEmpty
    @NotNull(message = "状态:0:可用 1 ：禁用字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "状态:0:可用 1 ：禁用字段的长度最大为2", groups = {Add.class, Update.class}, max = 2)
    @TableField("is_disable")
    private String isDisable;

    //状态:0:未下发 1 ：已下发
    @NotNull(message = "状态:0:未下发 1 ：已下发字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //描述
    @Length(message = "描述字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("description")
    private String description;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    public ParkConfig() {
    }

    public ParkConfig(Long id, String configCode, String configName, Long parkId, String configValue, String isDisable, Integer isSync, String description, String groupCode) {
        this.id = id;
        this.configCode = configCode;
        this.configName = configName;
        this.parkId = parkId;
        this.configValue = configValue;
        this.isDisable = isDisable;
        this.isSync = isSync;
        this.description = description;
        this.groupCode = groupCode;
    }
}
