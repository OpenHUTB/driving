package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import lombok.Builder;
import lombok.Data;

/**
 * @Author: Jun
 * @Description: 删除数据事件
 * @Date: 2020-09-06 9:03
 */
@Data
@Builder
@TableName("t_data_event_del")
public class DataEventDel extends BaseDO<ParkBlacklist> implements Syncable {
    private static final long serialVersionUID = -51537155666394694L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    @TableField("namespace")
    private String namespace;

    @TableField("pkey")
    private String pkey;

    @TableField("park_id")
    private Long parkId;

    @TableField("is_sync")
    private Integer isSync;

    public DataEventDel() {
    }

    public DataEventDel(Long id, String namespace, String pkey, Long parkId, Integer isSync) {
        this.id = id;
        this.namespace = namespace;
        this.pkey = pkey;
        this.parkId = parkId;
        this.isSync = isSync;
    }

    @Override
    public Long getParkId() {
        return this.parkId;
    }

    @Override
    public void setIsSync(Integer isSync) {
        this.isSync = isSync;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }
}
