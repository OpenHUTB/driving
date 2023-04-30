package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkLotDeviceEventHistory;

/**
 * 路边停车地磁设置数据记录
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
@MapperDefinition(domainClass = ParkLotDeviceEventHistory.class, orderBy = " update_time DESC")
public interface ParkLotDeviceEventHistoryDao extends BaseDao<ParkLotDeviceEventHistory> {

}
