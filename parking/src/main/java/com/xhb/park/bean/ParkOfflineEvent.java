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
 * (ParkOfflineEvent)实体类
 *
 * @author makejava
 * @since 2019-07-08 18:18:07
 */

@Data
@Builder
@TableName("t_park_offline_event")
public class ParkOfflineEvent extends BaseDO<ParkOfflineEvent> {
    private static final long serialVersionUID = 749311290033808591L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //掉线时间
    @Length(message = "掉线时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("drop_time")
    private String dropTime;

    //恢复时间
    @Length(message = "恢复时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("recovery_time")
    private String recoveryTime;

    //1 掉线 2恢复
    @NotNull(message = "1 掉线 2恢复字段不可为null", groups = {Update.class, Delete.class})
    @TableField("event_state")
    private Integer eventState;


    public ParkOfflineEvent() {
    }

    public ParkOfflineEvent(
            Long id,
            Long parkId,
            String dropTime,
            String recoveryTime,
            Integer eventState
    ) {
        this.id = id;
        this.parkId = parkId;
        this.dropTime = dropTime;
        this.recoveryTime = recoveryTime;
        this.eventState = eventState;
    }


}
