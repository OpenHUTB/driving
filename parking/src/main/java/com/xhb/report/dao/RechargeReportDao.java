package com.xhb.report.dao;

import com.xhb.report.dto.RechargeReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 储值用户
 *
 * @author wangjie
 * @Date 2019/6/11 12:14
 * </per>
 */
public interface RechargeReportDao {

    List<RechargeReportDTO> findRechargeDataList(Map<String, Object> param);

    DailyReportVo findRechargeAmount(Map<String, Object> param);

}
