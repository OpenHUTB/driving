package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.UcenterTollCollector;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 收费人员表(UcenterTollCollector)表数据库访问层
 *
 * @author makejava
 * @since 2019-04-03 17:32:36
 */
@MapperDefinition(domainClass = UcenterTollCollector.class, orderBy = " update_time DESC")
public interface UcenterTollCollectorDao extends BaseDao<UcenterTollCollector> {

}