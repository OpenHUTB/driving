package com.xhb.report.service;

import com.xhb.report.dto.RefundReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 退款明细
 *
 * @author wangjie
 * @Date 2019/6/11 12:29
 * </per>
 */
public interface RefundReportService {

    /**
     * 退款记录
     *
     * @param param
     * @return
     */
    List<RefundReportDTO> findRefundDataList(Map<String, Object> param);

    /**
     * 退款统计
     *
     * @param param
     * @return
     */
    DailyReportVo findRefundAmount(Map<String, Object> param);

}
