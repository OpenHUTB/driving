package com.xhb.park.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkParkingPort;

import java.util.Map;

/**
 * 进出口管理(ParkParkingPort)表服务接口
 *
 * @author jackwong
 * @since 2019-03-13 20:22:11
 */
public interface ParkParkingPortService extends BaseService<ParkParkingPort> {

    /**
     * 内部
     */
    int PORT_FUN_TYPE_INSIDE = 0;

    /**
     * 入口
     */
    int PORT_FUN_TYPE_ENTRANCE = 1;

    /**
     * 出口
     */
    int PORT_FUN_TYPE_EXIT = 2;


    /**
     * 出口
     */
    String PORT_FUN_TYPE_EXIT_STR = "2";

    /**
     * 入口
     */
    String PORT_FUN_TYPE_ENTRANCE_STR = "1";

    /**
     * 节假日
     */
    String INPEAK_TIME_TYPE_HOLIDAY = "0";

    /**
     * 周末
     */
    String INPEAK_TIME_TYPE_WEEK = "1";

    /**
     * 节假日+周末
     */
    String INPEAK_TIME_TYPE_HOLIDAY_AND_WEEK = "2";

    /**
     * 每天
     */
    String INPEAK_TIME_TYPE_DAYS = "3";

}
