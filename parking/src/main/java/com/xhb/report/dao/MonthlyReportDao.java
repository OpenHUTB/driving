package com.xhb.report.dao;

import com.xhb.report.dto.MonthlyReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 月租户包月
 *
 * @author wangjie
 * @Date 2019/6/11 11:58
 * </per>
 */
public interface MonthlyReportDao {

    List<MonthlyReportDTO> findMonthlyDataList(Map<String, Object> param);

    DailyReportVo findMonthlyAmount(Map<String, Object> param);

}
