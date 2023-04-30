package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 路边停车地磁设置数据记录 - 历史
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_park_lot_device_event_history")
public class ParkLotDeviceEventHistory extends BaseDO<ParkLotDeviceEventHistory> {
    private static final long serialVersionUID = 895108888269411861L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    /**
     * 服务code(适配不同商家地磁)
     */
    @TableField("service_code")
    private String serviceCode;

    /**
     * 地磁编号
     */
    @TableField("sn")
    private String sn;

    /**
     * 泊位(车位id)编号
     */
    @TableField("lot_id")
    private Long lotId;

    /**
     * 状态：
     * 0：状态更新为空闲 （车辆驶出）
     * 1：状态更新为占用 （车辆驶入）
     * 2：心跳维持为空闲 （无车心跳）
     * 3：心跳维持为占用 （有车心跳）
     */
    @TableField("status")
    private Integer status;

    /**
     * (注：每个商家都不一样)
     * 设备状态变化计数, 每次变化加 1。
     * 达最大值65535后重新从0开始计数
     */
    @TableField("count")
    private String count;

    /**
     * 车位状态变化的时间
     */
    @TableField("check_time")
    private Date checkTime;
}
