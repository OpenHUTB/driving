package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkParking;
import com.xhb.pay.dto.ParkProvinceidDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 停车场表(ParkParking)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 15:10:43
 */
@Repository
@MapperDefinition(domainClass = ParkParking.class, orderBy = " update_time DESC")
public interface ParkParkingDao extends BaseDao<ParkParking> {


}
