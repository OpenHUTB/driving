package com.xhb.report.service;

import com.xhb.report.bean.ReportTask;
import com.xhb.report.vo.DailyReportVo;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.File;
import java.util.Map;

/**
 * <per>
 * 临时订单表单
 *
 * @author wangjie
 * @Date 2019/5/31 16:44
 * </per>
 */
public interface TempOrderReportService {

    /**
     * 创建月报表返回文件对象
     *
     * @param task
     * @return
     */
    File makeMonthReport(ReportTask task);

    /**
     * 查询月租户信息
     *
     * @param paramMap
     * @return
     */
    DailyReportVo findMonthData(Map<String, Object> paramMap);


}
