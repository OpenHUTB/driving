package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

/**
 * 停车场区域(ParkRegion)实体类
 *
 * @author makejava
 * @since 2019-05-22 17:50:22
 */

@Data
@Builder
@TableName("t_park_region")
public class ParkRegion extends BaseDO<ParkRegion> implements Syncable {
    private static final long serialVersionUID = 777202754734297979L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @TableField("is_sync")
    private Integer isSync;

    //区域名称
    @Length(message = "区域名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("region_name")
    private String regionName;

    public ParkRegion() {
    }

    public ParkRegion(Long id, Long parkId, Integer isSync, String regionName) {
        this.id = id;
        this.parkId = parkId;
        this.isSync = isSync;
        this.regionName = regionName;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
