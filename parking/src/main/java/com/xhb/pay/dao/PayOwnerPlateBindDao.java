package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayOwnerPlateBind;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * @Author: 陈志虎
 * @Description: TODO
 * @DateTime: 2022/4/22 13:42
 **/
@MapperDefinition(domainClass = PayOwnerPlateBind.class, orderBy = " update_time DESC")
public interface PayOwnerPlateBindDao extends BaseDao<PayOwnerPlateBind> {

    /**
     *  app--实名车牌报表
     * @param dates 查询7天的时间集合
     * @param collectorId 收费员ID
     * @return
     */
    List<Map<String,Object>> plateNumberReport(@Param("dates") List<String> dates, @Param("collectorId") Long collectorId);
}
