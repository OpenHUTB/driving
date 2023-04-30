package com.xhb.park.dao;

import com.xhb.park.bean.ParkReliefType;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 减免分类表(ParkReliefType)表数据库访问层
 *
 * @author jack_wang(wl)
 * @since 2019-08-01 17:02:11
 */
@MapperDefinition(domainClass = ParkReliefType.class, orderBy = " update_time DESC")
public interface ParkReliefTypeDao extends BaseDao<ParkReliefType> {

}
