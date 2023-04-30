package com.xhb.report.dao;

import com.xhb.report.vo.DateReportVO;
import com.xhb.report.vo.ParkingReportVO;
import com.xhb.report.vo.ParkingVO;
import com.xhb.report.vo.ReportVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 大屏报持久层接口
 */
@Repository
public interface BigScreenDao {

    /**
     * 车厂车位情况
     *
     * @return
     */
    ParkingReportVO parkingSpaceUsageCount(@Param("parkIds") String parkIds,@Param("groupCode") String groupCode);

    /**
     * 车厂车位情况
     *
     * @return
     */
    List<ParkingVO> parkingSpaceUsageList(@Param("parkIds") String parkIds);

    /***
     * 订单笔数
     * @return
     */
    Map<String, Object> paymentStatistics(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode") String groupCode);

    /**
     * 今日泊位
     *
     * @return
     */
    Map<String, Object> berthToday(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 今日泊位 简单版
     *
     * @return
     */
    Map<String, Object> berthTodaySimpleness(@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 今日支付方式
     *
     * @return
     */
    Map<String, Object> howToPayToday(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode") String groupCode);


    /**
     * 用户情况
     *
     * @return
     */
    LinkedHashMap<String, Object> userReport(@Param("year") int year, @Param("month") int month, @Param("day") int day, @Param("date")String dateString, @Param("parkIds") String parkIds);


    /**
     * 今日入场
     *
     * @return
     */
    LinkedHashMap<String, Object> admissionToday(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds);

    /**
     * 今日停车时长
     *
     * @return
     */
    Map<String, Object> parkingTimeToday(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);
    /**
     * 实时入场
     *
     * @return
     */
    List<ParkingVO> liveAdmission(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode );

    /**
     * 交易金额前五
     *
     * @return
     */
    List<ParkingVO> todaySTradingVolumeTOP5(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 今日订单TOP5
     *
     * @return
     */
    List<ParkingVO> todaySOrderTOP5(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 今日收费
     *
     * @return
     */
    Map<String, Object> chargeToday(@Param("year") int year, @Param("month") int month, @Param("day") int day,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 今日欠费
     *
     * @return
     */
    Map<String, Object> arrearsToday(@Param("date")String dateString,@Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 今日车流量
     *
     * @return
     */
    List<DateReportVO> trafficFlowToday(@Param("year") int year, @Param("month") int month, @Param("day") int day, @Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 付款时间分布
     *
     * @return
     */
    List<DateReportVO> paymentTimeDistribution(@Param("year") int year, @Param("month") int month, @Param("day") int day, @Param("parkIds") String parkIds,@Param("groupCode")String groupCode);

    /**
     * 记录泊位
     *
     * @return
     */
    List<Map<String,Object>> recordBerth();

}
