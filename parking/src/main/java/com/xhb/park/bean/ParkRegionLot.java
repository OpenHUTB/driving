package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.*;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * (ParkRegionLot)实体类
 *
 * @author makejava
 * @since 2019-05-24 10:37:43
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_park_region_lot")
public class ParkRegionLot extends BaseDO<ParkRegionLot> implements Syncable {
    private static final long serialVersionUID = 100089669013308159L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //车位号
    @Length(message = "车位号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("lot_no")
    private String lotNo;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @TableField("is_sync")
    private Integer isSync;

    //租赁开始日期
    @Length(message = "租赁开始日期字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("start_date")
    private String startDate;

    //租赁结束日期
    @Length(message = "租赁结束日期字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("end_date")
    private String endDate;

    //内部客户id
    @TableField("inside_id")
    private Long insideId;

    //区域id
    @TableField("region_id")
    private Long regionId;

    //0 未占用 1 已锁定待付款 2 租赁中
    @TableField("status")
    private Integer status;

    @TableField("time_out_time")
    @Length(message = "锁定超时时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    private String timeOutTime;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    @TableField(value = "plate_number")
    @Length(message = "车牌号字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    private String plateNumber;

    //入场记录id
    @TableField("enter_id")
    private Long enterId;

    //地磁序号列
    @TableField("hardware_sn")
    private String hardwareSn;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    @TableField(exist = false)
    private String accessTime;
}
