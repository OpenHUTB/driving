package com.xhb.report.dao;

import com.xhb.report.dto.RefundReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 退款明细
 *
 * @author wangjie
 * @Date 2019/6/11 12:28
 * </per>
 */
public interface RefundReportDao {

    List<RefundReportDTO> findRefundDataList(Map<String, Object> param);

    DailyReportVo findRefundAmount(Map<String, Object> param);

}
