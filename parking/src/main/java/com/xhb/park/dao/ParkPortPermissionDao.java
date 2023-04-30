package com.xhb.park.dao;

import com.xhb.park.bean.ParkPortPermission;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * (ParkPortPermission)表数据库访问层
 *
 * @author wanglei
 * @since 2020-12-02 14:12:54
 */
@MapperDefinition(domainClass = ParkPortPermission.class, orderBy = " update_time DESC")
public interface ParkPortPermissionDao extends BaseDao<ParkPortPermission> {

}
