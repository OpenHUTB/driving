package com.xhb.park.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.constant.Constant;
import com.fhs.common.utils.DateUtils;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.fhs.core.exception.ParamException;
import com.fhs.system.service.WordBookService;
import com.xhb.park.bean.ParkLotDevice;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkRegionLot;
import com.xhb.park.dao.ParkLotDeviceDao;
import com.xhb.park.service.ParkLotDeviceEventService;
import com.xhb.park.service.ParkLotDeviceService;
import com.xhb.park.service.ParkParkingService;
import com.xhb.park.service.ParkRegionLotService;
import com.xhb.utils.ExcelBaseUtils;
import com.xhb.utils.ExcelField;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 路边停车- 地磁设备管理
 *
 * @author yutao
 * @since 2022-05-23 20:08:13
 */
@Slf4j
@Service("parkLotDeviceService")
@DataSource("park")
public class ParkLotDeviceServiceImpl extends BaseServiceImpl<ParkLotDevice> implements ParkLotDeviceService {

    @Autowired
    private ParkParkingService parkParkingService;

    @Autowired
    private ParkRegionLotService parkRegionLotService;

    @Autowired
    private WordBookService wordBookService;

    @Autowired
    private ParkLotDeviceEventService parkLotDeviceEventService;

    @Autowired
    private ParkLotDeviceDao parkLotDeviceDao;


    @Override
    public void exportExcel(HttpServletResponse response, Long parkId) {
        ParkParking parkParking = parkParkingService.selectById(parkId);
        if (null == parkParking) {
            throw new ParamException("无效停车场");
        }

        LambdaQueryWrapper<ParkRegionLot> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.eq(ParkRegionLot::getParkId, parkId);
        lambdaQueryWrapper.orderByDesc(ParkRegionLot::getCreateTime);
        List<ParkRegionLot> parkRegionLots = parkRegionLotService.selectListMP(lambdaQueryWrapper);

        List<ExcelField> fields = new ArrayList<>();
        fields.add(ExcelField.builder().name("车位编号").code("lotNo").rule("required").importFlag(true).export(true).with(4000).build());
        fields.add(ExcelField.builder().name("地磁序号列").code("hardwareSn").notRepeat(true).importFlag(true).export(true).with(4000).build());
        fields.add(ExcelField.builder().name("id").code("id").rule("required").importFlag(true).export(true).hidden(true).build());
        try {
            response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(parkParking.getParkName() + ":车位列表.xlsx", "utf-8"));
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            ExcelBaseUtils.exportExcel(response.getOutputStream(), fields, parkRegionLots);
        } catch (IOException e) {
            throw new ParamException("导出数据异常，请联系管理员");
        }
    }

    @Override
    public void importExcel(MultipartFile file, String serviceCode, String sysUserId) {
        List<ExcelField> fields = new ArrayList<>();
        fields.add(ExcelField.builder().name("车位编号").code("lotNo").rule("required").importFlag(true).export(true).build());
        fields.add(ExcelField.builder().name("地磁序号列").code("hardwareSn").notRepeat(true).importFlag(true).export(true).build());
        fields.add(ExcelField.builder().name("id").code("id").rule("required").importFlag(true).export(true).hidden(true).build());
        try {
            List<ParkRegionLot> parkRegionLots = ExcelBaseUtils.easyImportExcel(file.getInputStream(), fields, ParkRegionLot.class, wordBookService);
            //查询原始数据
            List<Long> ids = parkRegionLots.stream().map(ParkRegionLot::getId).collect(Collectors.toList());
            LambdaQueryWrapper<ParkRegionLot> lambdaQueryWrapper = new LambdaQueryWrapper<>();
            lambdaQueryWrapper.in(ParkRegionLot::getId, ids);
            List<ParkRegionLot> preParkRegionLot = parkRegionLotService.selectListMP(lambdaQueryWrapper);
            if (preParkRegionLot.isEmpty()) {
                throw new ParamException("模板数据异常，请重新导出模板");
            }
            Long parkId = preParkRegionLot.get(0).getParkId();
            Map<String, Long> snMap = new HashMap<>();
            for (ParkRegionLot parkRegionLot : preParkRegionLot) {
                if (StringUtils.isBlank(parkRegionLot.getHardwareSn())) {
                    continue;
                }
                snMap.put(parkRegionLot.getHardwareSn(), parkRegionLot.getId());
            }
            //原地磁数据
            LambdaQueryWrapper<ParkLotDevice> lotDeviceWrapper = new LambdaQueryWrapper<>();
            lotDeviceWrapper.in(ParkLotDevice::getSn, snMap.keySet());
            List<ParkLotDevice> preParkLotDevices = this.selectListMP(lotDeviceWrapper);
            List<String> preSnList = preParkLotDevices.stream().map(ParkLotDevice::getSn).collect(Collectors.toList());

            //1.需要新增的数据
            List<ParkLotDevice> addList = new ArrayList<>();
            //2.需要更新的数据
            List<ParkLotDevice> updateList = new ArrayList<>();
            //3.需要清空的数据
            List<String> clearSNList = new ArrayList<>();
            ParkLotDevice parkLotDevice;
            for (ParkRegionLot parkRegionLot : parkRegionLots) {
                parkLotDevice = new ParkLotDevice();
                parkLotDevice.setServiceCode(serviceCode);
                parkLotDevice.setServiceCode(serviceCode);
                parkLotDevice.setParkId(parkId);
                parkLotDevice.setLotId(parkRegionLot.getId());
                parkLotDevice.setSn(parkRegionLot.getHardwareSn());
                parkLotDevice.setType(Constant.INT_TRUE);
                parkLotDevice.setIsOnLine(Constant.INT_FALSE);
                parkRegionLot.setUpdateTime(DateUtils.getCurrentDateStr(DateUtils.DATETIME_PATTERN));
                //需要清空的数据
                preSnList.remove(parkRegionLot.getHardwareSn());
                if (StringUtils.isBlank(parkRegionLot.getHardwareSn())) {
                    //地磁序号列 为空不做处理
                    continue;
                }
                if (snMap.containsKey(parkRegionLot.getHardwareSn())) {
                    //需要更新的数据
                    updateList.add(parkLotDevice);
                    continue;
                }
                parkLotDevice.preInsert(sysUserId);
                parkLotDevice.setId(idHelper.nextId());
                addList.add(parkLotDevice);
            }
            if (!preSnList.isEmpty()) {
                for (String sn : preSnList) {
                    parkLotDeviceEventService.nuBoundParkingSpace(sn);
                }
            }
            if (!updateList.isEmpty()) {
                for (ParkLotDevice lotDevice : updateList) {
                    parkLotDeviceDao.updateBeanBySN(lotDevice);
                }
            }
            if (!addList.isEmpty()) {
                this.batchInsert(addList);
            }
            parkRegionLotService.batchUpdate(parkRegionLots);
        } catch (RuntimeException e) {
            throw new ParamException(e.getMessage());
        } catch (Exception e) {
            throw new ParamException("导入数据异常，请联系管理员");
        }

    }
}
