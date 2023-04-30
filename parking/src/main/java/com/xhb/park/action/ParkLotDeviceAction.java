package com.xhb.park.action;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.result.HttpResult;
import com.xhb.park.bean.ParkLotDevice;
import com.xhb.park.bean.ParkRegionLot;
import com.xhb.park.service.ParkLotDeviceEventService;
import com.xhb.park.service.ParkLotDeviceService;
import com.xhb.park.service.ParkRegionLotService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 路边停车地磁设备
 */
@Slf4j
@Api(tags = "地磁设备")
@RestController
@RequestMapping("/ms/lotDevice")
public class ParkLotDeviceAction extends ModelSuperAction<ParkLotDevice> {

    @Autowired
    private ParkLotDeviceEventService parkLotDeviceEventService;

    @Autowired
    private ParkRegionLotService parkRegionLotService;

    @Autowired
    private ParkLotDeviceService parkLotDeviceService;

    /**
     * @return 获取所有的停车场的车位号
     */
    @RequestMapping("getLotList")
    public List<ParkRegionLot> getLotList(@RequestParam(value = "parkId") Long parkId) {
        ParamChecker.isNotNull(parkId, "parkId不能为空");
        LambdaQueryWrapper<ParkRegionLot> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        lambdaQueryWrapper.eq(ParkRegionLot::getParkId, parkId);
        return parkRegionLotService.selectListMP(lambdaQueryWrapper);
    }

    @PostMapping("boundParkingSpace")
    @ApiOperation(value = "地磁绑定", notes = "数据来源", httpMethod = "POST")
    public HttpResult<Boolean> boundParkingSpace(ParkLotDevice parkLotDevice, HttpServletRequest request) {
        parkLotDeviceEventService.boundParkingSpace(parkLotDevice);
        return HttpResult.success(true);
    }

    @GetMapping("nuBoundParkingSpace")
    @ApiOperation(value = "地磁解绑", notes = "数据来源", httpMethod = "POST")
    public HttpResult<Boolean> nuBoundParkingSpace(@RequestParam(value = "sn") String sn, HttpServletRequest request) {
        ParamChecker.isNotNull(sn, "地磁编号不能为空");
        parkLotDeviceEventService.nuBoundParkingSpace(sn);
        return HttpResult.success(true);
    }

    /**
     * @return 导出
     */
    @GetMapping("exportExcel")
    @ApiOperation(value = "导出", notes = "数据来源", httpMethod = "GET")
    public void exportExcel(@RequestParam(value = "parkId") Long parkId, HttpServletResponse response) {
        ParamChecker.isNotNull(parkId, "parkId不能为空");
        parkLotDeviceService.exportExcel(response, parkId);
    }

    /**
     * @return 导入
     */
    @PostMapping("importExcel")
    @ApiOperation(value = "导入", notes = "数据来源", httpMethod = "POST")
    public HttpResult<Boolean> importExcel(HttpServletRequest request, @RequestParam("file") MultipartFile file, @RequestParam(value = "serviceCode") String serviceCode) {
        ParamChecker.isNotNull(serviceCode, "服务code不能为空");
        String sysUserId = super.getSessionuser(request).getUserId();
        parkLotDeviceService.importExcel(file, serviceCode, sysUserId);
        return HttpResult.success(true);
    }
}
