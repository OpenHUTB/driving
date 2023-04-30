package com.xhb.report.service.impl;

import com.xhb.report.dao.IncomeOverviewDao;
import com.xhb.report.dto.MonthlyParkDTO;
import com.xhb.report.dto.OtherBusinessDTO;
import com.xhb.report.dto.TempParkDTO;
import com.xhb.report.service.IncomeOverviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
@Service
public class IncomeOverviewServiceImpl implements IncomeOverviewService {

    @Autowired
    private IncomeOverviewDao incomeOverviewDao;

    /**
     * 月租户收入
     *
     * @param param
     * @return
     */
    @Override
    public List<MonthlyParkDTO> findMonthlyParkDataList(Map<String, Object> param) {
        return incomeOverviewDao.findMonthlyParkDataList(param);
    }

    /**
     * 临停收入
     *
     * @param param
     * @return
     */
    @Override
    public List<TempParkDTO> findTempParkDataList(Map<String, Object> param) {
        String time =param.get("payTime").toString().replace("-","");
        param.put("payTime",time);
        return incomeOverviewDao.findTempParkDataList(param);
    }

    /**
     * 其它业务收入
     *
     * @param param
     * @return
     */
    @Override
    public List<OtherBusinessDTO> findOtherBusinessDataList(Map<String, Object> param) {
        return incomeOverviewDao.findOtherBusinessDataList(param);
    }

}
