package com.xhb.pay.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.pay.bean.PayInsideContract;
import com.xhb.pay.vo.PayInsideContractVo;
import org.apache.ibatis.annotations.Param;

import java.lang.reflect.InvocationTargetException;
import java.util.List;
import java.util.Map;

/**
 * 内部车承包时间段表(PayInsideContract)表服务接口
 *
 * @author makejava
 * @since 2019-05-22 17:53:07
 */
public interface PayInsideContractService extends BaseService<PayInsideContract> {

    /**
     * 按月充
     */
    String BY_MONTH = "0";

    /**
     * 按天充
     */
    String BY_DAY = "1";

    /**
     * 未提醒
     */
    int NO_REMIND = 0;

    /**
     * 已提醒
     */
    int HAVE_TO_REMIND = 1;

    /**
     * 后台系统
     */
    int BACK_OFFICE_SYSTEM = 1;

    /**
     * 公众号/支付宝
     */
    int MP_AND_ALIPAY = 2;

    /**
     * App
     */
    int APP = 3;

    /**
     * 小程序
     */
    int MINI_PROGRAMS = 4;

    void insertContract(PayInsideContract payInsideContract);

    PayInsideContract findLastRecord(PayInsideContract build);

    int selectValidMonthly(Long id);


}
