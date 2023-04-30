package com.xhb.pay.service;

import com.xhb.report.bean.ReportTask;
import com.xhb.pay.dto.PayTempOrderDTO;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.File;
import java.util.List;
import java.util.Map;

public interface PayTempOrderReportService {
    /**
     * 临时订单列表查询
     *
     * @param paramMap
     * @return
     */
    List<PayTempOrderDTO> findPayTempOrderList(Map<String, Object> paramMap);

    /**
     * 临时订单统计
     *
     * @param paramMap
     * @return
     */
    int findPayTempOrderCount(Map<String, Object> paramMap);

    /**
     * 创建月报表返回文件对象
     *
     * @param task
     * @return
     */
    File makeMonthReport(ReportTask task);
}
