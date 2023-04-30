package com.xhb.report.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.Logger;
import com.xhb.pay.bean.PayCarcome;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.report.action.TollCollectorReportAction;
import com.xhb.report.dao.UnattendedDao;
import com.xhb.report.dto.UnattendedDTO;
import com.xhb.report.service.UnattendedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 生成报表任务
 *
 * @author wangjie
 * @Date 2019/6/4 14:29
 * </per>
 */
@Service
public class UnattendedServiceImpl implements UnattendedService {

    private static final Logger LOG = Logger.getLogger(TollCollectorReportAction.class);

    @Autowired
    private UnattendedDao unattendedDao;

    @Autowired
    private PayCarcomeService payCarcomeService;


    @Override
    public List<UnattendedDTO> findUnattended(Map<String, Object> paramMap) {

        Integer parkingTime = null;
        if (paramMap.get("overtimeParking") != null && paramMap.get("overtimeParking").toString().equals("2")) {
            parkingTime = 60 * 60 * 24;
        }
        if (paramMap.get("overtimeParking") != null && paramMap.get("overtimeParking").toString().equals("3")) {
            parkingTime = 60 * 60 * 24 * 3;
        }
        if (paramMap.get("overtimeParking") != null && paramMap.get("overtimeParking").toString().equals("4")) {
            parkingTime = 60 * 60 * 24 * 7;
        }
        if (paramMap.get("overtimeParking") != null && paramMap.get("overtimeParking").toString().equals("5")) {
            parkingTime = 60 * 60 * 24 * 30;
        }
        if (paramMap.get("overtimeParking") != null && paramMap.get("overtimeParking").toString().equals("6")) {
            parkingTime = 60 * 60 * 24 * 90;
        }
        paramMap.put("parkingTime", parkingTime);
        List<UnattendedDTO> list = unattendedDao.findUnattended(paramMap);
        return list;
    }

    @Override
    public void carOut(UnattendedDTO unattendedDTO) {
        List<Long> idList = unattendedDao.findCarcome(unattendedDTO);
        for (Long id : idList) {
            PayCarcome payCarcome = new PayCarcome();
            payCarcome.setId(id);
            payCarcome.setStatus(PayCarcomeService.STATUS_CREATE_HAS_PAY);
            payCarcome.setIsSync(Constant.INT_FALSE);
            payCarcomeService.updateSelectiveById(payCarcome);
        }
    }


}
