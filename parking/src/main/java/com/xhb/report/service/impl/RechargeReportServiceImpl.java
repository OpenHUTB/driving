package com.xhb.report.service.impl;

import com.xhb.report.dao.RechargeReportDao;
import com.xhb.report.dto.RechargeReportDTO;
import com.xhb.report.service.RechargeReportService;
import com.xhb.report.vo.DailyReportVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 储值户
 *
 * @author wangjie
 * @Date 2019/6/11 12:15
 * </per>
 */
@Service
public class RechargeReportServiceImpl implements RechargeReportService {

    @Autowired
    private RechargeReportDao rechargeReportDao;

    /**
     * 储值户记录
     *
     * @param param
     * @return
     */
    @Override
    public List<RechargeReportDTO> findRechargeDataList(Map<String, Object> param) {
        return rechargeReportDao.findRechargeDataList(param);
    }

    /**
     * 储值户充值金额统计
     *
     * @param param
     * @return
     */
    @Override
    public DailyReportVo findRechargeAmount(Map<String, Object> param) {
        return rechargeReportDao.findRechargeAmount(param);
    }
}
