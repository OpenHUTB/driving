package com.xhb.park.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.park.bean.ParkMonthlyRule;
import com.xhb.park.dao.ParkMonthlyRuleDao;
import com.xhb.park.service.ParkMonthlyRuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 月租用户收费规则表(ParkMonthlyRule)表服务实现类
 *
 * @author jackwong
 * @since 2019-03-13 20:21:12
 */
@Service("parkMonthlyRuleService")
@DataSource("park")
public class ParkMonthlyRuleServiceImpl extends BaseServiceImpl<ParkMonthlyRule> implements ParkMonthlyRuleService {

    @Autowired
    private ParkMonthlyRuleDao parkMonthlyRuleDao;

}
