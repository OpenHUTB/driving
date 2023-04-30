package com.xhb.report.service.impl;

import com.xhb.report.dao.RefundReportDao;
import com.xhb.report.dto.RefundReportDTO;
import com.xhb.report.service.RefundReportService;
import com.xhb.report.vo.DailyReportVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 退款
 *
 * @author wangjie
 * @Date 2019/6/11 12:30
 * </per>
 */
@Service
public class RefundReportServiceImpl implements RefundReportService {

    @Autowired
    private RefundReportDao refundReportDao;

    /**
     * 退款记录
     *
     * @param param
     * @return
     */
    @Override
    public List<RefundReportDTO> findRefundDataList(Map<String, Object> param) {
        return refundReportDao.findRefundDataList(param);
    }

    /**
     * 退款统计
     *
     * @param param
     * @return
     */
    @Override
    public DailyReportVo findRefundAmount(Map<String, Object> param) {
        return refundReportDao.findRefundAmount(param);
    }
}
