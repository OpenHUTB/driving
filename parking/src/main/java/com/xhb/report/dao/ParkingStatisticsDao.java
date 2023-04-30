package com.xhb.report.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 停车统计报表dao
 */
@Repository
public interface ParkingStatisticsDao {

    List<Map<String, Object>> getParkIncomeCountList(@Param("dateFull") String dateFull, @Param("typeF") String typeF, @Param("parkIdImport") Long parkIdImport, @Param("parkIds") String parkIds, @Param("groupCode") String groupCode);

    List<Map<String, Object>> findParkingFlows(@Param("dateFull") String dateFull, @Param("typeF") String typeF, @Param("parkIdImport") Long parkIdImport, @Param("parkIds") String parkIds, @Param("groupCode") String groupCode);

    List<Map<String, Object>> findParkReportHoliday(@Param("dateFull") String dateFull);

    List<Map<String, Object>> findTrafficIncome(@Param("dateFull") String dateFull, @Param("parkIdImport") Long parkIdImport, @Param("groupCode") String groupCode, @Param("parkIds") String parkIds);

    List<Map<String, Object>> findTraffic(@Param("dateFull") String dateFull, @Param("parkIdImport") Long parkIdImport, @Param("groupCode") String groupCode, @Param("parkIds") String parkIds);
}
