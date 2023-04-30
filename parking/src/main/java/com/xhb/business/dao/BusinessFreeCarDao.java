package com.xhb.business.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.business.bean.BusinessFreeCar;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 商户-免费停车车牌管理(BusinessFreeCar)表数据库访问层
 *
 * @author jackwong-wanglei
 * @since 2019-07-16 14:52:37
 */
@Repository
@MapperDefinition(domainClass = BusinessFreeCar.class, orderBy = " update_time DESC")
public interface BusinessFreeCarDao extends BaseDao<BusinessFreeCar> {


}
