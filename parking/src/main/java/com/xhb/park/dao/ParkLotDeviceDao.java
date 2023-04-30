package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkBlacklist;
import com.xhb.park.bean.ParkLotDevice;

/**
 * 路边停车地磁设置
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
@MapperDefinition(domainClass = ParkLotDevice.class, orderBy = " update_time DESC")
public interface ParkLotDeviceDao extends BaseDao<ParkLotDevice> {

    /**
     * 更新地磁设备
     * @param sn
     */
    void updateBySN(String sn);

    /**
     * 更新地磁设备
     * @param device
     */
    void updateBeanBySN(ParkLotDevice device);
}
