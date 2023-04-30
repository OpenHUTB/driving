package com.xhb.report.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.DateUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.report.bean.ReportNoGetOutCar;
import com.xhb.report.dao.ReportNoGetOutCarDao;
import com.xhb.report.service.ReportNoGetOutCarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

/**
 * (ReportNoExistCar)表服务实现类
 *
 * @author makeJun
 * @since 2020-01-17 14:42:14
 */
@Service("reportNoExistCarService")
public class ReportNoGetOutCarServiceImpl extends BaseServiceImpl<ReportNoGetOutCar> implements ReportNoGetOutCarService {

    private static final Logger LOG = Logger.getLogger(ReportNoGetOutCarServiceImpl.class);

    /**
     * 所有时间
     */
    private static final String ALL_DAY = "1";
    /**
     * 一天内
     */
    private static final String IN_ONE_DAY = "2";
    /**
     * 三天内
     */
    private static final String IN_THREE_DAY = "3";
    /**
     * 一周内
     */
    private static final String IN_WEEK_DAY = "4";
    /**
     * 一月内
     */
    private static final String IN_ONE_MONTH = "5";
    /**
     * 三月内
     */
    private static final String IN_THREE_MONTH = "6";


    @Autowired
    private ReportNoGetOutCarDao noGetOutCarDao;

    @Autowired
    private PayCarcomeService carcomeService;

    /**
     * 根据条件查询车辆
     */

    @Override
    public List<ReportNoGetOutCar> findNoOutCar(Map<String, Object> paramMap) {
        Long parkingTime = null;
        if (paramMap.get("overtimeParking") != null) {
            switch (paramMap.get("overtimeParking").toString()) {
                case IN_ONE_DAY:
                    parkingTime = (long) 60 * 60 * 24 * 1000;
                    break;
                case IN_THREE_DAY:
                    parkingTime = (long) 60 * 60 * 24 * 3 * 1000;
                    break;
                case IN_WEEK_DAY:
                    parkingTime = (long) 60 * 60 * 24 * 7 * 1000;
                    break;
                case IN_ONE_MONTH:
                    parkingTime = (long) 60 * 60 * 24 * 30 * 1000;
                    break;
                case IN_THREE_MONTH:
                    parkingTime = (long) 60 * 60 * 24 * 90 * 1000;
                    break;
            }
        }
        if (parkingTime != null) {
            paramMap.put("parkingTime", DateUtils.timestampFormat(System.currentTimeMillis() - parkingTime, DateUtils.DATETIME_PATTERN));
        }

        return noGetOutCarDao.findNoOutCar(paramMap);
    }

    /**
     * 根据条件查询车辆总数
     */

    @Override
    public Integer findNoOutCarCount(Map<String, Object> paramMap) {
        return noGetOutCarDao.findNoOutCarCount(paramMap);
    }

    /**
     * 标记车辆已出场
     */

    @Override
    public boolean carOut(ReportNoGetOutCar noGetOutCar) {
        // 查询指定车辆入场之前的所有未支付记录
        List<String> idList = noGetOutCarDao.findNotPayCar(noGetOutCar);
        StringJoiner sj = new StringJoiner("','", "('", "')");
        idList.forEach(id -> {
            sj.add(id);
        });
        carcomeService.batchUpdateStatus(sj.toString());
        this.deleteById(noGetOutCar.getId());
        return Constant.BTRUE;
    }

}
