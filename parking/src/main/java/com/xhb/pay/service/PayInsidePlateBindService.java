package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.service.ParkMonthlyRuleService;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.bean.PayInsidePlateBind;

/**
 * 内部车和车牌号绑定记录(PayInsidePlateBind)表服务接口
 *
 * @author makejava
 * @since 2019-05-22 17:54:52
 */
public interface PayInsidePlateBindService extends BaseService<PayInsidePlateBind> {

    void insertPlateBind(PayInsidePlateBind payInsidePlateBind);

    void updatePlateBind(PayInsidePlateBind payInsidePlateBind);

    void deletePlateBind(Long id);

}
