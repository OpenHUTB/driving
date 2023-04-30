package com.xhb.park.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkLotDevice;
import com.xhb.park.bean.ParkLotDeviceEvent;
import com.xhb.park.bean.ParkLotDeviceInfo;


/**
 * 路边停车地磁设置数据记录
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
public interface ParkLotDeviceEventService extends BaseService<ParkLotDeviceEvent> {

    /**
     * 消息类型: 设备状态上报
     * 固定值：TMoteStatus
     */
    String XX_MESSAGE_TYPE_NAME_TMOTESTATUS = "TMoteStatus";

    /**
     * 消息类型: 设备信息上报
     * 固定值：TMoteStatus
     */
    String XX_MESSAGE_TYPE_NAME_TMOTEINFO = "TMoteInfo";

    /**
     * 设备服务code(适配不同商家地磁)
     */
    String SERVICE_CODE_A = "A";

    /**
     * 状态：
     * 0：状态更新为空闲 （车辆驶出）
     * 1：状态更新为占用 （车辆驶入）
     * 2：心跳维持为空闲 （无车心跳）
     * 3：心跳维持为占用 （有车心跳）
     */
    int LOT_DEVICE_STATUS_OUT = 0;
    int LOT_DEVICE_STATUS_COME = 1;
    int LOT_DEVICE_STATUS_NO = 2;
    int LOT_DEVICE_STATUS_YES = 3;

    /**
     * 【地磁设备】绑定车位
     *
     * @param parkLotDevice
     * @return
     */
    void boundParkingSpace(ParkLotDevice parkLotDevice);

    /**
     * 【地磁设备】解绑车位
     *
     * @param sn
     * @return
     */
    void nuBoundParkingSpace(String sn);
}
