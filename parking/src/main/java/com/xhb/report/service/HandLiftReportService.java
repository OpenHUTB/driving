package com.xhb.report.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.report.dto.HandLiftReportDTO;
import com.xhb.report.vo.DailyReportVo;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 手动抬杆
 *
 * @author wangjie
 * @Date 2019/6/21 14:16
 * </per>
 */
public interface HandLiftReportService extends BaseService<HandLiftReportDTO> {

    /**
     * 获取月报表手动抬杆收费记录
     *
     * @param param
     * @return
     */
    DailyReportVo findHandLiftAmount(Map<String, Object> param);

    /**
     * 获取月报表手动抬杆详情
     *
     * @param param
     * @return
     */
    List<HandLiftReportDTO> findHandLiftDate(Map<String, Object> param);
}
