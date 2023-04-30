package com.xhb.park.dao;

import com.xhb.park.bean.ParkParkingPort;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 进出口管理(ParkParkingPort)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 20:22:11
 */
@Repository
@MapperDefinition(domainClass = ParkParkingPort.class, orderBy = " update_time DESC")
public interface ParkParkingPortDao extends BaseDao<ParkParkingPort> {

}
