package com.xhb.business.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.business.bean.BusinessCashCoupon;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 现金券表(BusinessCashCoupon)表数据库访问层
 *
 * @author jackwong-wanglei
 * @since 2019-07-16 14:39:29
 */
@Repository
@MapperDefinition(domainClass = BusinessCashCoupon.class, orderBy = " update_time DESC")
public interface BusinessCashCouponDao extends BaseDao<BusinessCashCoupon> {

    /**
     * 按照年月份，停车场查询: 商家优惠卷 金额
     */
    List<Map<String, Object>> findBusinessCashCouponcAmount(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

}
