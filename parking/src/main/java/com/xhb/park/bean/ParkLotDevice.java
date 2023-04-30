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
@TableName("t_park_lot_device")
public class ParkLotDevice extends BaseDO<ParkLotDevice> {
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
     * 车场id
     */
    @TableField("park_id")
    private Long parkId;

    /**
     * 0未分配，1已分配
     */
    @TableField("type")
    private Integer type;

    /**
     * 是否在线
     */
    @TableField("is_on_line")
    private Integer isOnLine;
}
