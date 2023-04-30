package com.xhb.park.dao;

import com.xhb.park.bean.ParkLeaseType;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 租户类型(ParkLeaseType)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 20:16:37
 */
@MapperDefinition(domainClass = ParkLeaseType.class, orderBy = " update_time DESC")
public interface ParkLeaseTypeDao extends BaseDao<ParkLeaseType> {

}
