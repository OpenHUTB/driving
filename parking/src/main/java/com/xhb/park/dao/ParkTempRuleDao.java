package com.xhb.park.dao;

import com.xhb.park.bean.ParkTempRule;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 临时用户收费规则表(ParkTempRule)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 20:23:54
 */
@Repository
@MapperDefinition(domainClass = ParkTempRule.class, orderBy = " update_time DESC")
public interface ParkTempRuleDao extends BaseDao<ParkTempRule> {

}
