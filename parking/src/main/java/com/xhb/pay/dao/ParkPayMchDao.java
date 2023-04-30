package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.xhb.pay.bean.ParkPayMch;
import com.mybatis.jpa.annotation.MapperDefinition;
import org.springframework.stereotype.Repository;

/**
 * (ParkPayMch)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-04 10:22:09
 */
@MapperDefinition(domainClass = ParkPayMch.class)
public interface ParkPayMchDao extends BaseDao<ParkPayMch> {

}