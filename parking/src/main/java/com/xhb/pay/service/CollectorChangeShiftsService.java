package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.CollectorChangeShifts;

import java.util.Map;

/**
 * 交接班(CollectorChangeShifts)表服务接口
 *
 * @author jack_wang(wl)
 * @since 2019-08-05 10:56:47
 */
public interface CollectorChangeShiftsService extends BaseService<CollectorChangeShifts> {

    /**
     * 收费员下班 报表
     *
     * @param collectorChangeShifts
     * @return
     */
    Map<String, Object> workReport(CollectorChangeShifts collectorChangeShifts);


}
