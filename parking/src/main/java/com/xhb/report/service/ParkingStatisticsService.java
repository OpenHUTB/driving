package com.xhb.report.service;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

/**
 * 首页报表服务
 */

public interface ParkingStatisticsService {

    /**
     * 获取停车折线图数据
     *
     * @param dateFull     年月
     * @param typeF        记录类型
     * @param parkIdImport 停车场id
     * @param parkIds      有权限的所有停车场id
     * @return
     */
    List<Map<String, Object>> findCountData(String dateFull, String typeF, Long parkIdImport, String parkIds, String groupCode);

    /**
     * 获取停车进出流量统计图数据
     *
     * @param dateFull     年月
     * @param parkIdImport 停车场id
     * @param parkIds      有权限的所有停车场id
     * @return
     */
    Map<String, Object> findParkingFlows(String dateFull, Long parkIdImport, String parkIds, String groupCode);

    /**
     * 获取车流与收入分析
     *
     * @param dateFull     当前月
     * @param parkIdImport 停车场id
     * @param groupCode    组织类型
     * @return
     */
    Map<String, Object> findTrafficIncome(String dateFull, Long parkIdImport, String groupCode, String parkIds) throws ParseException;

}
