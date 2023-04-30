package com.xhb.park.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkTempDiscount;

/**
 * 临时优惠规则(ParkTempDiscount)表数据库访问层
 *
 * @author make Jun
 * @since 2020-03-18 15:27:09
 */
@MapperDefinition(domainClass = ParkTempDiscount.class, orderBy = " update_time DESC")
public interface ParkTempDiscountDao extends BaseDao<ParkTempDiscount> {

}
