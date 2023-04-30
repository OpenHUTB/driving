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
 * 分段收费规则管理(ParkTempSegment)实体类 ---废弃
 *
 * @author jackwong
 * @since 2019-03-13 20:27:17
 */

@Data
@Builder
@TableName("t_park_temp_segment")
public class ParkTempSegment extends BaseDO<ParkTempSegment> implements Syncable {
    private static final long serialVersionUID = 539932997704646072L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //车场编号
    @NotNull(message = "车场编号字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //白天开始时间
    @NotEmpty
    @NotNull(message = "白天开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "白天开始时间字段的长度最大为16", groups = {Add.class, Update.class}, max = 16)
    @TableField("day_start")
    private String dayStart;

    //白天结束时间
    @NotEmpty
    @NotNull(message = "白天结束时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "白天结束时间字段的长度最大为16", groups = {Add.class, Update.class}, max = 16)
    @TableField("day_end")
    private String dayEnd;

    //晚上开始时间
    @NotEmpty
    @NotNull(message = "晚上开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "晚上开始时间字段的长度最大为16", groups = {Add.class, Update.class}, max = 16)
    @TableField("night_start")
    private String nightStart;

    //晚上结束时间
    @NotEmpty
    @NotNull(message = "晚上结束时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "晚上结束时间字段的长度最大为16", groups = {Add.class, Update.class}, max = 16)
    @TableField("night_end")
    private String nightEnd;

    //描述
    @Length(message = "描述字段的长度最大为225", groups = {Add.class, Update.class}, max = 225)
    @TableField("description")
    private String description;

    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("segment_name")
    private String segmentName;

    //是否已下发
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

    public ParkTempSegment() {
    }

    public ParkTempSegment(Long id, Long parkId, String dayStart, String dayEnd, String nightStart, String nightEnd, String description, String segmentName, Integer isSync, String groupCode) {
        this.id = id;
        this.parkId = parkId;
        this.dayStart = dayStart;
        this.dayEnd = dayEnd;
        this.nightStart = nightStart;
        this.nightEnd = nightEnd;
        this.description = description;
        this.segmentName = segmentName;
        this.isSync = isSync;
        this.groupCode = groupCode;
    }
}
