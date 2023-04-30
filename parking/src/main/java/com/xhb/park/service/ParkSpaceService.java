package com.xhb.park.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkSpace;
import com.xhb.pay.bean.PayCarcome;

import java.util.List;
import java.util.Map;

/**
 * (ParkSpace)表服务接口
 *
 * @author makejava
 * @since 2019-04-19 16:01:16
 */
public interface ParkSpaceService extends BaseService<ParkSpace> {

    /**
     * 成功
     */
    int UPDATE_SPACE_RESULT_SUCCESS = 0;

    /**
     * 本辆车辆入场后没有空车位了
     */
    int UPDATE_SPACE_RESULT_NOT_FREE_SPACE = 1;

    /**
     * 车辆出场后有空车位了(之前没有)
     */
    int UPDATE_SPACE_RESULT_HAS_FREE_SPACE = 2;


    /**
     * 查询 车位
     *
     * @param map 根据集团编码，停车场
     * @return
     */
    List<ParkSpace> findParkingSpaceNum(Map<String, Object> map);


}
