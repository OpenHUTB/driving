package com.xhb.park.dao;

import com.xhb.park.bean.ParkBlacklist;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 黑名单表(历史记录)  入口判断(ParkBlacklist)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 20:08:13
 */
@MapperDefinition(domainClass = ParkBlacklist.class, orderBy = " update_time DESC")
public interface ParkBlacklistDao extends BaseDao<ParkBlacklist> {

}
