package com.xhb.report.service;

import com.xhb.report.vo.ParkingReportVO;
import com.xhb.report.vo.ParkingVO;
import com.xhb.report.vo.ReportVO;

import java.util.List;

/**
 * 首页报表接口
 */
public interface HomeService {


    /**
     * 今日泊位 简单版
     * @return
     */
    List<ReportVO> berthTodaySimpleness(String groupCode);

    /**
     * 今日收费
     * @return
     */
    List<ReportVO> chargeToday(String groupCode);

    /**
     * 今日欠费
     * @return
     */
    List<ReportVO> arrearsToday(String groupCode);

}
