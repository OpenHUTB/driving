package com.xhb.pay.dao;

import com.xhb.pay.bean.CollectorChangeShifts;
import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.dto.SummaryDto;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 交接班(CollectorChangeShifts)表数据库访问层
 *
 * @author jack_wang(wl)
 * @since 2019-08-05 10:56:47
 */
@Repository
@MapperDefinition(domainClass = CollectorChangeShifts.class, orderBy = " update_time DESC")
public interface CollectorChangeShiftsDao extends BaseDao<CollectorChangeShifts> {

}
