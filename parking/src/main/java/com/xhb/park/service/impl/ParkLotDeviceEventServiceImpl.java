package com.xhb.park.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.constant.Constant;
import com.fhs.common.utils.DateUtils;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.exception.ParamException;
import com.xhb.park.bean.*;
import com.xhb.park.dao.ParkLotDeviceDao;
import com.xhb.park.dao.ParkLotDeviceEventDao;
import com.xhb.park.dao.ParkLotDeviceEventHistoryDao;
import com.xhb.park.dao.ParkLotDeviceInfoDao;
import com.xhb.park.service.ParkLotDeviceEventService;
import com.xhb.park.service.ParkRegionLotService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 路边停车地磁设置数据记录
 *
 * @author yutao
 * @since 2022-05-13 20:08:13
 */
@Slf4j
@Service("parkLotDeviceEventService")
@DataSource("park")
public class ParkLotDeviceEventServiceImpl extends BaseServiceImpl<ParkLotDeviceEvent> implements ParkLotDeviceEventService {

    @Autowired
    private ParkLotDeviceEventDao parkLotDeviceEventDao;

    @Autowired
    private ParkLotDeviceDao parkLotDeviceDao;

    @Autowired
    private ParkLotDeviceInfoDao parkLotDeviceInfoDao;

    @Autowired
    private ParkRegionLotService parkRegionLotService;

    @Autowired
    private ParkLotDeviceEventHistoryDao parkLotDeviceEventHistoryDao;


    /**
     * 地磁设备最大掉线分钟
     */
    @Value("${lot.device.max.minute:60}")
    private int lotDeviceMaxMinute;


    /**
     * 【地磁设备】绑定车位
     *
     * @param parkLotDevice
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void boundParkingSpace(ParkLotDevice parkLotDevice) {
        ParkRegionLot parkRegionLot = parkRegionLotService.selectById(parkLotDevice.getLotId());
        if (null == parkRegionLot) {
            throw new ParamException("车位不存在");
        }
        //车位地磁校验
        LambdaQueryWrapper<ParkRegionLot> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.eq(ParkRegionLot::getHardwareSn, parkLotDevice.getSn());
        List<ParkRegionLot> parkRegionLots = parkRegionLotService.selectListMP(lambdaQueryWrapper);
        if (parkRegionLots.size() > 0) {
            throw new ParamException("该地磁已绑定车位号 lotNo=" + parkRegionLots.get(0).getLotNo());
        }

        parkLotDevice.setUpdateTime(DateUtils.getCurrentDateStr(DateUtils.DATETIME_PATTERN));
        parkLotDevice.setType(Constant.INT_TRUE);
        parkLotDeviceDao.updateById(parkLotDevice);
        parkRegionLot.setHardwareSn(parkLotDevice.getSn());
        parkRegionLotService.updateById(parkRegionLot);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void nuBoundParkingSpace(String sn) {
        ParkLotDevice parkLotDevice = parkLotDeviceDao.selectBean(ParkLotDevice.builder().sn(sn).build());
        if (null == parkLotDevice) {
            throw new ParamException("地磁设备不存在");
        }
        //车位地磁解绑
        LambdaQueryWrapper<ParkRegionLot> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.eq(ParkRegionLot::getHardwareSn, sn);
        List<ParkRegionLot> parkRegionLots = parkRegionLotService.selectListMP(lambdaQueryWrapper);
        if (!parkRegionLots.isEmpty()) {
            parkRegionLotService.noBoundParkingSpace(sn);
        }
        parkLotDeviceDao.updateBySN(sn);
    }
}
