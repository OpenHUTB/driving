package com.xhb.park.dao;

import com.xhb.park.bean.ParkOfflineEvent;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * (ParkOfflineEvent)表数据库访问层
 *
 * @author makejava
 * @since 2019-07-08 11:18:52
 */
@MapperDefinition(domainClass = ParkOfflineEvent.class, orderBy = " update_time DESC")
public interface ParkOfflineEventDao extends BaseDao<ParkOfflineEvent> {

}
