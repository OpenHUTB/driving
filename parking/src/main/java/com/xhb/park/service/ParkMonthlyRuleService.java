package com.xhb.park.service;

import com.xhb.park.bean.ParkMonthlyRule;

import java.util.List;

import com.fhs.core.base.service.BaseService;

/**
 * 月租用户收费规则表(ParkMonthlyRule)表服务接口
 *
 * @author jackwong
 * @since 2019-03-13 20:21:12
 */
public interface ParkMonthlyRuleService extends BaseService<ParkMonthlyRule> {

    /**
     * 月全租
     */
    String MONTHLY_TYPE_ALLDAY = "0";

    /**
     * 月白租
     */
    String MONTHLY_TYPE_DAYTIME = "1";

    /**
     * 夜晚租
     */
    String MONTHLY_TYPE_NIGHT = "2";

    /**
     * 免费车
     */
    String MONTHLY_TYPE_FREE = "3";

    /**
     * 储户租时段
     */
    String MONTHLY_TYPE_LEASE_HOUR = "4";

}
