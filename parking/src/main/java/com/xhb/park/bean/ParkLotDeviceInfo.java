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
 * 路边停车地磁设置数据记录
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_park_lot_device_info")
public class ParkLotDeviceInfo extends BaseDO<ParkLotDeviceInfo> {
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
     * 设备电池电压，除以100后为真实值。如 360 表示3.6V
     */
    @TableField("batt")
    private Integer batt;

    /**
     * 温度,单位 摄氏度, 电压会随着温度降低
     */
    @TableField("temp")
    private Integer temp;

    /**
     * (设备物联卡的卡号
     */
    @TableField("sim")
    private String sim;

    /**
     * 设备NB模组的编号
     */
    @TableField("lmei")
    private String lmei;
}
