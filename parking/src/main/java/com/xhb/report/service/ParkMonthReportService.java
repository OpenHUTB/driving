package com.xhb.report.service;

import com.xhb.report.bean.ReportTask;

import java.util.Map;

/**
 * OA 对接月报表
 *
 * @author yutao
 * @since 2019-09-28 09:22:11
 */
public interface ParkMonthReportService {

    /**
     * 创建OA word文件
     *
     * @param task
     * @return
     */
    String makeReportWord(ReportTask task);

    /**
     * 获取报表数据信息
     *
     * @return
     */
    Map<String, Object> findCountData(Long parkId, String dateTime);

}
