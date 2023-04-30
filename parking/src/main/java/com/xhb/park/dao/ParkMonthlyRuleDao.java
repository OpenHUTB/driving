package com.xhb.park.dao;

import com.xhb.park.bean.ParkMonthlyRule;
import org.apache.ibatis.annotations.Param;

import java.util.List;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 月租用户收费规则表(ParkMonthlyRule)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-13 20:21:12
 */
@Repository
@MapperDefinition(domainClass = ParkMonthlyRule.class, orderBy = " update_time DESC")
public interface ParkMonthlyRuleDao extends BaseDao<ParkMonthlyRule> {

}
