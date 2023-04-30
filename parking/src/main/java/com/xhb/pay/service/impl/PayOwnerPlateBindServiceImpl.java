package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.pay.bean.PayOwnerPlateBind;
import com.xhb.pay.service.PayOwnerPlateBindService;
import org.springframework.stereotype.Service;

/**
 * @Author: 陈志虎
 * @Description: TODO
 * @DateTime: 2022/4/22 13:44
 **/
@Service("payOwnerPlateBindService")
@DataSource("park")
public class PayOwnerPlateBindServiceImpl extends BaseServiceImpl<PayOwnerPlateBind> implements PayOwnerPlateBindService {


}
