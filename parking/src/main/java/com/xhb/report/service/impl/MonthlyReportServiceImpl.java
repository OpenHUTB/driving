package com.xhb.report.service.impl;

import com.xhb.report.dao.MonthlyReportDao;
import com.xhb.report.dto.MonthlyReportDTO;
import com.xhb.report.service.MonthlyReportService;
import com.xhb.report.vo.DailyReportVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 月租户包月报表
 *
 * @author wangjie
 * @Date 2019/6/11 12:01
 * </per>
 */
@Service
public class MonthlyReportServiceImpl implements MonthlyReportService {

    @Autowired
    private MonthlyReportDao monthlyReportDao;

    /**
     * 查询月租户充值记录
     *
     * @param param
     * @return
     */
    @Override
    public List<MonthlyReportDTO> findMonthlyDataList(Map<String, Object> param) {
        return monthlyReportDao.findMonthlyDataList(param);
    }

    /**
     * 月租户充值金额统计
     *
     * @param param
     * @return
     */
    @Override
    public DailyReportVo findMonthlyAmount(Map<String, Object> param) {
        return monthlyReportDao.findMonthlyAmount(param);
    }
}
