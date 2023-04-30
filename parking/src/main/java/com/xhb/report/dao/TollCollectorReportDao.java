package com.xhb.report.dao;

import com.xhb.report.bean.ReportCollectorReport;
import com.xhb.report.vo.DailyReportVo;
import com.xhb.report.vo.TollCollectorReportVo;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 线下收费统计
 */
@Repository
public interface TollCollectorReportDao {

    List<TollCollectorReportVo> findListData(Map<String, Object> paramMap);

    Integer findCount(Map<String, Object> paramMap);

    String selectMinDate(Long parkId);

    List<ReportCollectorReport> findReportCollectorByParkId(@Param("parkId") Long parkId, @Param("reportDate") String reportDate);

    @MapKey("payTime")
    Map<String, DailyReportVo> findDailyTempOrder(Map<String, Object> paramMap);

    @MapKey("payTime")
    Map<String, Map<String, Long>> findDailyCarOutNum(Map<String, Object> paramMap);

    @MapKey("payTime")
    Map<String, Map<String, BigDecimal>> findDailyHandLiftAmount(Map<String, Object> paramMap);

    TollCollectorReportVo queryTempOrderOfflineCharging(TollCollectorReportVo tollCollectorReportVo);

    Long countFindListData(Map<String, Object> paramMap);
}
