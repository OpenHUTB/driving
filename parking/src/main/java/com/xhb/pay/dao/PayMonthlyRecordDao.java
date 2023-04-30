package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.PayMonthlyRecord;
import org.apache.ibatis.annotations.Param;

/**
 * 月租户充值记录表(PayMonthlyRecord)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-29 14:40:48
 */
@MapperDefinition(domainClass = PayMonthlyRecord.class, orderBy = " update_time DESC")
public interface PayMonthlyRecordDao extends BaseDao<PayMonthlyRecord> {

    /**
     * 获得总月卡数
     *
     * @param parkIds
     * @return
     */
    Integer findMonthlyCount(@Param("parkIds") String parkIds);

    /**
     * 查询今日新增月卡数量
     *
     * @param parkIds
     * @return
     */
    Integer findTodayMonthlyCount(@Param("parkIds") String parkIds);
}
