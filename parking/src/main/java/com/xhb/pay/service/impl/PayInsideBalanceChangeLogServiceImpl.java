package com.xhb.pay.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.StringUtil;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayInsideBalanceChangeLog;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.service.PayInsideBalanceChangeLogService;
import org.springframework.stereotype.Service;

/**
 * 内部车余额变动日志(PayInsideBalanceChangeLog)表服务实现类
 *
 * @author makejava
 * @since 2019-05-23 12:10:51
 */
@Service("payInsideBalanceChangeLogService")
@DataSource("park")
public class PayInsideBalanceChangeLogServiceImpl extends BaseServiceImpl<PayInsideBalanceChangeLog> implements PayInsideBalanceChangeLogService {

}
