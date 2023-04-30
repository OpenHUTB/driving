package com.xhb.report.service;

import com.xhb.report.dto.RechargeReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 储值用户
 *
 * @author wangjie
 * @Date 2019/6/11 12:13
 * </per>
 */
public interface RechargeReportService {

    /**
     * 储值户记录
     *
     * @param param
     * @return
     */
    List<RechargeReportDTO> findRechargeDataList(Map<String, Object> param);

    /**
     * 储值户充值金额统计
     *
     * @param param
     * @return
     */
    DailyReportVo findRechargeAmount(Map<String, Object> param);
}
