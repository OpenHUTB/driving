package com.xhb.report.service;

import com.xhb.report.dto.MonthlyParkDTO;
import com.xhb.report.dto.OtherBusinessDTO;
import com.xhb.report.dto.TempParkDTO;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 收入全览
 *
 * @author wangjie
 * @Date 2019/6/13 11:25
 * </per>
 */
public interface IncomeOverviewService {

    /**
     * 月租户收入
     *
     * @param param
     * @return
     */
    List<MonthlyParkDTO> findMonthlyParkDataList(Map<String, Object> param);

    /**
     * 临停收入
     *
     * @param param
     * @return
     */
    List<TempParkDTO> findTempParkDataList(Map<String, Object> param);

    /**
     * 其它业务收入
     *
     * @param param
     * @return
     */
    List<OtherBusinessDTO> findOtherBusinessDataList(Map<String, Object> param);

}
