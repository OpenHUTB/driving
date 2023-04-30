package com.xhb.report.service;

import com.xhb.report.bean.ReportCollectorReport;
import com.xhb.report.vo.DailyReportVo;
import com.xhb.report.vo.TollCollectorReportVo;

import java.util.List;
import java.util.Map;

/**
 * 收费员线下收费报表
 */
public interface TollCollectorReportService {

    /**
     * 收费员线下收费报表数据分页查询
     *
     * @param paramMap
     * @return
     */
    List<TollCollectorReportVo> findListData(Map<String, Object> paramMap);

    /**
     * 收费员线下收费报表总条数
     *
     * @param paramMap
     * @return
     */
    Integer findCount(Map<String, Object> paramMap);

    /**
     * 日报表
     *
     * @param paramMap
     * @return
     */
    List<DailyReportVo> findDailyReport(Map<String, Object> paramMap);

    /**
     * 查询并插入收费员信息
     *
     * @param reportDate
     * @param parkId
     */
    void insertCollectorReport(String reportDate, Long parkId);

    /**
     * 查询最小入库时间
     *
     * @param parkId
     * @return
     */
    String selectMinDate(Long parkId);

    /**
     * 查询收费员信息
     *
     * @param parkId
     * @param reportDate
     * @return
     */
    List<ReportCollectorReport> findReportCollectorByParkId(Long parkId, String reportDate);
}
