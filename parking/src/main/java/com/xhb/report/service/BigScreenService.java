package com.xhb.report.service;

import com.xhb.report.vo.DateReportVO;
import com.xhb.report.vo.ParkingReportVO;
import com.xhb.report.vo.ParkingVO;
import com.xhb.report.vo.ReportVO;

import java.util.List;
import java.util.Map;

/**
 * 大屏报表接口
 */
public interface BigScreenService {
    /**
     * 车厂车位情况
     * @return
     */
    ParkingReportVO parkingSpaceUsage(String groupCode);
    /**
     * 停车场地图
     * @return
     */
    ParkingReportVO parkingSpaceUsageMap(String groupCode);
    /***
     * 订单笔数
     * @return
     */
    List<ReportVO> paymentStatistics(String groupCode);

    /**
     * 今日泊位
     * @return
     */
    List<ReportVO> berthToday(String groupCode);

    /**
     * 今日支付方式
     * @return
     */
    List<ReportVO> howToPayToday(String groupCode);

    /**
     * 用户报表
     * @return
     */
    List<ReportVO> userReport();

    /**
     * 实时入场
     *
     * @return
     */
    List<ParkingVO> liveAdmission(String groupCode) ;

    /**
     * 今日交易额TOP5
     *
     * @return
     */
    List<ParkingVO> todaySTradingVolumeTOP5(String groupCode) ;

    /**
     * 今日停车时长
     *
     * @return
     */
    List<ReportVO> parkingTimeToday(String groupCode) ;

    /**
     * 今日订单TOP5
     *
     * @return
     */
    List<ParkingVO> todaySOrderTOP5(String groupCode) ;

    /**
     * 今日车流量
     *
     * @return
     */
    List<DateReportVO> trafficFlowToday(String groupCode);

    /**
     * 付款时间分布
     *
     * @return
     */
    List<DateReportVO> paymentTimeDistribution(String groupCode);


    /**
     * 泊位使用率
     *
     * @return
     */
    List<DateReportVO> berthUtilization(String groupCode);


}
