package com.xhb.report.dao;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 首页报表dao
 */
public interface IndexReportDao {


    /**
     * 根据停车场ids 和起止日期获取停车场入场统计数据
     *
     * @param parkIds   用户有权限的停车场ids
     * @param startDate 开始日期yyyy-MM-dd格式
     * @param endDate   结束日期yyyy-MM-dd 格式
     * @return 统计数据
     */
    List<Map<String, Object>> getParkIncomeCountList(@Param("parkIds") String parkIds, @Param("startDate") String startDate, @Param("endDate") String endDate);


}
