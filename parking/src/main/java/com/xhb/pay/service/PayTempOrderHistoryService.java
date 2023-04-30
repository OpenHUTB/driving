package com.xhb.pay.service;


import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayTempOrderHistory;
import com.xhb.pay.dto.PayTempOrderDTO;
import com.xhb.pay.form.PayTempOrderForm;
import com.xhb.report.bean.ReportTask;

import java.io.File;
import java.util.List;
import java.util.Map;

public interface PayTempOrderHistoryService extends BaseService<PayTempOrderHistory> {

    /**
     * 查询临时订单列表
     */
    List<PayTempOrderDTO> queryTempOrderPage(PayTempOrderForm payTempOrderForm,Object obj );

    /**
     * 查询临时订单详情
     */
    PayTempOrderDTO queryTempOrder(Long id);

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
