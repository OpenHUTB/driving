package com.xhb.report.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.xhb.report.dao.HandLiftReportDao;
import com.xhb.report.dto.HandLiftReportDTO;
import com.xhb.report.service.HandLiftReportService;
import com.xhb.report.vo.DailyReportVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 手动抬杆报表
 *
 * @author wangjie
 * @Date 2019/6/21 14:17
 * </per>
 */
@Service
public class HandLiftReportServiceImpl extends BaseServiceImpl<HandLiftReportDTO> implements HandLiftReportService {

    @Autowired
    private HandLiftReportDao handLiftReportDao;

    /**
     * 获取月报表手动抬杆收费记录
     *
     * @param param
     * @return
     */
    @Override
    public DailyReportVo findHandLiftAmount(Map<String, Object> param) {
        return handLiftReportDao.findHandLiftAmount(param);
    }

    /**
     * 获取月报表手动抬杆详情
     *
     * @param param
     * @return
     */
    @Override
    public List<HandLiftReportDTO> findHandLiftDate(Map<String, Object> param) {
        return handLiftReportDao.findHandLiftDate(param);
    }
}
