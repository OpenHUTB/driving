package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.pay.bean.PayGatewayOrder;
import com.xhb.pay.bean.PayHandLiftRod;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 手动抬杆(PayHandLiftRod)表数据库访问层
 *
 * @author makejava
 * @since 2019-06-10 11:58:10
 */
@Repository
@MapperDefinition(domainClass = PayHandLiftRod.class, orderBy = " update_time DESC")
public interface PayHandLiftRodDao extends BaseDao<PayHandLiftRod> {
    /**
     * 手动抬杆总金额和数量
     *
     * @param collectorChangeShifts 收银员id,上班时间，下班时间
     * @return
     */
    Map<String, Object> findPayHandLiftRodAmountByTime(CollectorChangeShifts collectorChangeShifts);

    /**
     * 按照年月份，停车场查询 手动抬杆总金额
     *
     * @param parkId
     * @param dateTime yyyy-MM
     * @return
     */
    Double getMonthRod(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 按照年月份，停车场查询: 每天的手动抬杆总金额
     *
     * @param parkId
     * @param dateTime
     * @return
     */
    List<Map<String, Object>> geDaysRodByMonth(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

}
