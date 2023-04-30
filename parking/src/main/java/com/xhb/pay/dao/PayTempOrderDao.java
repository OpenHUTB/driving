package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.park.bean.ParkParking;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.pay.bean.PayTempOrder;
import com.xhb.pay.dto.ParkProvinceidDTO;
import com.xhb.pay.dto.TempOrderNumberAndAmountDTO;
import com.xhb.pay.dto.TempStopAvgHourDTO;
import com.xhb.report.dto.StatementOfAccountsReceivableDTO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 临时入场出厂缴费(PayTempOrder)表数据库访问层
 *
 * @author jackwong
 * @since 2019-03-07 13:03:09
 */
@Repository
@MapperDefinition(domainClass = PayTempOrder.class, orderBy = " update_time DESC")
public interface PayTempOrderDao extends BaseDao<PayTempOrder> {

    /**
     * 获取临时订单总数
     *
     * @param parkIds
     * @return
     */
    Integer findTempOrderCount(@Param("parkIds") String parkIds);

    /**
     * 获取今日临时订单数
     *
     * @param parkIds
     * @return
     */
    Integer findTodayTempOrderCount(@Param("parkIds") String parkIds);


    /**
     * 按照年月份，停车场查询 临时停车实付金额
     *
     * @param parkId
     * @param dateTime yyyy-MM
     * @param isOnline 支付途径 1线上 0线下
     * @return
     */
    Map<String, Object> getMonthRevenueByOnline(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("isOnline") Integer isOnline);

    /**
     * 按照年月份，停车场查询: 每日收入趋势(应收和实收)
     *
     * @param parkId
     * @param dateTime yyyy-MM
     * @return
     */
    List<Map<String, Object>> findEverydayIncome(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("carType") Integer carType);

    /**
     * 停车时长 数量统计
     */
    Map<String, Object> findParkingTimeCount(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 缴费方式 数量统计
     *
     * @param parkId   停车场id
     * @param dateTime 月份时间 yyyy-MM
     * @param dayTime  天数时间 yyyy-MM-dd (注意：时间二选一)
     * @return
     */
    List<Map<String, Object>> findTempOrderPayType(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("dayTime") String dayTime);

    /**
     * 缴费途径 现金
     *
     * @param parkId   停车场id
     * @param dateTime 月份时间 yyyy-MM
     * @param dayTime  天数时间 yyyy-MM-dd (注意：时间二选一)
     * @return
     */
    Integer findTempOrderPayCashCount(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("dayTime") String dayTime);

    /**
     * 缴费途径 提前扫码
     *
     * @param parkId   停车场id
     * @param dateTime 月份时间 yyyy-MM
     * @param dayTime  天数时间 yyyy-MM-dd (注意：时间二选一)
     * @return
     */
    Integer findTempOrderPayAdvanceCode(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("dayTime") String dayTime);

    /**
     * 缴费途径 岗亭扫码(线上)
     *
     * @param parkId
     * @param dateTime
     * @param dayTime  (注意：时间二选一)
     * @return
     */
    Integer findTempOrderPayCode(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("dayTime") String dayTime);

    /**
     * 缴费途径 预付费
     *
     * @param parkId
     * @param dateTime
     * @param dayTime  (注意：时间二选一)
     * @return
     */
    Integer findTempOrderPayAdvance(@Param("parkId") Long parkId, @Param("dateTime") String dateTime, @Param("dayTime") String dayTime);

    /**
     * 按照年月份，停车场查询: 临时订单实收总金额
     */
    Double findTempOrderPayActualAmountSum(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);

    /**
     * 查询减免分类
     */
    List<Map<String, Object>> findTempOrderPayDiscountAmount(@Param("parkId") Long parkId, @Param("dateTime") String dateTime);


}
