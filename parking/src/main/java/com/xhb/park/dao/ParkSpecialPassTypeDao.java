package com.xhb.park.dao;

import com.xhb.park.bean.ParkSpecialPassType;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * (ParkSpecialPassType)表数据库访问层
 *
 * @author makejava
 * @since 2019-05-27 11:34:52
 */
@MapperDefinition(domainClass = ParkSpecialPassType.class, orderBy = " update_time DESC")
public interface ParkSpecialPassTypeDao extends BaseDao<ParkSpecialPassType> {

}
