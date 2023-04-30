package com.xhb.report.service;

import com.xhb.report.vo.AdmissionReportParkComeLineVO;

import java.util.Map;

/**
 * 停车场出入场记录报表服务
 */

public interface AdmissionReportService {

    /**
     * 获取日期段的折线图
     *
     * @param paramMap 停车场，开始日期，结束日期
     * @return
     */
    AdmissionReportParkComeLineVO findCountDate(Map<String, Object> paramMap);

    /**
     * 获取一天24小时的折线图
     *
     * @param paramMap 停车场，起止时间
     * @return
     */
    AdmissionReportParkComeLineVO findCountDay(Map<String, Object> paramMap);

    /**
     * 查询 入出场 总数
     *
     * @param paramMap 停车场，起止时间
     * @return
     */
    Map<String, Object> findOutEnterCount(Map<String, Object> paramMap);


}
