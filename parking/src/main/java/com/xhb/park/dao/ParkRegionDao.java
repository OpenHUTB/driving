package com.xhb.park.dao;

import com.fhs.common.utils.EMap;
import com.xhb.park.bean.ParkRegion;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 停车场区域(ParkRegion)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-22 17:50:22
 */
@MapperDefinition(domainClass = ParkRegion.class, orderBy = " update_time DESC")
public interface ParkRegionDao extends BaseDao<ParkRegion> {

}
