package com.xhb.pay.service;



import com.fhs.core.base.service.BaseService;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.PayCarcomeHistory;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.form.PayCarcomeForm;
import com.xhb.report.bean.ReportTask;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.util.List;
import java.util.Map;

/**
 * 车辆入场历史记录表
 */
public interface PayCarcomeHistoryService extends BaseService<PayCarcomeHistory> {

    /**
     * 查询临时订单列表
     */
    List<PayCarcomeExportDTO> queryPayCarcomePage(PayCarcomeForm payCarcomeForm,Object obj);

    /**
     * 查询车辆进出详情
     */
    PayCarcomeExportDTO queryPayCarcome(Long id);


    /**
     * 创建 停车场 返回文件对象
     *
     * @param task
     * @return
     */
    File makeCarcomeHistory(ReportTask task);

    /**
     * 查询数量
     *
     * @param paramMap
     * @return
     */
    Long findCount(Map<String, Object> paramMap);

    /**
     * 删除车辆进出数据
     * @param id
     */
    void delData2PayCarcomeHistory(Long id);

    /**
     * 修改车辆进出数据
     */
    void updateData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm);

    /**
     * 新增车辆进出数据
     */
    void addData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm);
}
