package com.xhb.park.bean;

import java.io.Serializable;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.*;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.mybatis.jpa.annotation.*;
import com.fhs.core.group.*;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.*;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * (ParkSpecialPassType)实体类
 *
 * @author makejava
 * @since 2019-05-27 11:34:52
 */

@Data
@Builder
@TableName("t_park_special_pass_type")
public class ParkSpecialPassType extends BaseDO<ParkSpecialPassType> implements Syncable {
    private static final long serialVersionUID = -63596857666107532L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //描述
    @NotEmpty
    @NotNull(message = "描述字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "描述字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("describ")
    private String describ;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @NotNull(message = "是否同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;


    @NotNull(message = "是否启用字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_disable")
    private String isDisable;

    public ParkSpecialPassType() {
    }

    public ParkSpecialPassType(Long id, String describ, Long parkId, Integer isSync, String isDisable) {
        this.id = id;
        this.describ = describ;
        this.parkId = parkId;
        this.isSync = isSync;
        this.isDisable = isDisable;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
