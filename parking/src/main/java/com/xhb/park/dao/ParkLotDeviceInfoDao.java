package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkLotDevice;
import com.xhb.park.bean.ParkLotDeviceInfo;

/**
 * 路边停车地磁设置数据记录
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
@MapperDefinition(domainClass = ParkLotDeviceInfo.class, orderBy = " update_time DESC")
public interface ParkLotDeviceInfoDao extends BaseDao<ParkLotDeviceInfo> {

}
