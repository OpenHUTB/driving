package com.xhb.report.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.report.bean.ReportNoGetOutCar;

import java.util.List;
import java.util.Map;

/**
 * (ReportNoGetOutCar)表服务接口
 *
 * @author makeJun
 * @since 2020-01-17 14:42:14
 */
public interface ReportNoGetOutCarService extends BaseService<ReportNoGetOutCar> {

    /**
     * 根据条件查询车辆
     */

    List<ReportNoGetOutCar> findNoOutCar(Map<String, Object> paramMap);

    /**
     * 根据条件查询车辆总数
     */

    Integer findNoOutCarCount(Map<String, Object> paramMap);

    /**
     * 标记车量已出场
     */

    boolean carOut(ReportNoGetOutCar noGetOutCar);
}
