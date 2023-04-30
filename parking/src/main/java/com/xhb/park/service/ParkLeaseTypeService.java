package com.xhb.park.service;

import com.xhb.park.bean.ParkLeaseType;

import java.util.List;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkMonthlyRule;

/**
 * 租户类型(ParkLeaseType)表服务接口
 *
 * @author jackwong
 * @since 2019-03-13 20:16:37
 */
public interface ParkLeaseTypeService extends BaseService<ParkLeaseType> {

    /**
     * 启用
     */
    String ENABLED = "0";

    /**
     * 禁用
     */
    String DISABLE = "1";

    /**
     * 否
     */
    String IS_NOT_MP = "0";

    /**
     * 是
     */
    String IS_MP = "1";

}
