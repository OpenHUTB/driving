package com.xhb.report.dao;

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
 * @Date 2019/6/13 10:55
 * </per>
 */
public interface IncomeOverviewDao {

    List<MonthlyParkDTO> findMonthlyParkDataList(Map<String, Object> param);

    List<TempParkDTO> findTempParkDataList(Map<String, Object> param);

    List<OtherBusinessDTO> findOtherBusinessDataList(Map<String, Object> param);

    void insertAndSelectMonthly();

    void insertAndSelectOtherBusiness();

}
