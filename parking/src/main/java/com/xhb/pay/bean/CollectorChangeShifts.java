package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.Syncable;
import com.xhb.park.bean.UcenterTollCollector;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 交接班(CollectorChangeShifts)实体类
 *
 * @author jack_wang(wl)
 * @since 2019-08-05 10:56:42
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TransTypes(types = {"pagex", "wordbook"})
@TableName("t_collector_change_shifts")
public class CollectorChangeShifts extends BaseDO<CollectorChangeShifts> implements Syncable {
    private static final long serialVersionUID = 603524889096797807L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //收费员id
    @NotNull(message = "收费员id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("collector_id")
    @Trans(type = TransType.SIMPLE,target = UcenterTollCollector.class,fields = "name",alias = "user")
    private Long collectorId;

    //上班开始时间
    @NotEmpty
    @NotNull(message = "上班开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "上班开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_time")
    private String startTime;

    //上班结束时间
    @NotEmpty
    @NotNull(message = "上班结束时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "上班结束时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_time")
    private String endTime;

    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    @Trans(type = TransType.SIMPLE,target = ParkParking.class,fields = "parkName")
    private Long parkId;

    @NotEmpty
    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //0上班 1 已下班
    @NotNull(message = "0上班 1 已下班字段不可为null", groups = {Update.class, Delete.class})
    @TableField("status")
    private Integer status;

    //0未同步 1 已同步
    @NotNull(message = "0未同步 1 已同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //交接人Id（收银员）
    @TableField("handover_person_id")
    @Trans(type = "pagex", key = "ucenter_toll_collector")
    private Long handoverPersonId;

    public Long getPrimaryVal() {
        return id;
    }
}
