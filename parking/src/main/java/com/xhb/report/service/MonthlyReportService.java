package com.xhb.report.service;

import com.xhb.report.dto.MonthlyReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 月租户包月报表
 *
 * @author wangjie
 * @Date 2019/6/11 12:00
 * </per>
 */
public interface MonthlyReportService {

    /**
     * 查询月租户充值记录
     *
     * @param param
     * @return
     */
    List<MonthlyReportDTO> findMonthlyDataList(Map<String, Object> param);

    /**
     * 月租户充值金额统计
     *
     * @param param
     * @return
     */
    DailyReportVo findMonthlyAmount(Map<String, Object> param);
}
