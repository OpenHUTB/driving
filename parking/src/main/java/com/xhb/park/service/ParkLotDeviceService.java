package com.xhb.park.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkLotDevice;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;

/**
 * 路边停车- 地磁设备管理
 *
 * @author yutao
 * @since 2022-05-23 20:08:13
 */
public interface ParkLotDeviceService extends BaseService<ParkLotDevice> {

    /**
     * 车位地磁导出
     *
     * @param response
     * @param parkId
     */
    void exportExcel(HttpServletResponse response, Long parkId);

    /**
     * 车位地磁导入
     *
     * @param file
     * @param sysUserId
     * @param serviceCode
     */
    void importExcel(MultipartFile file, String serviceCode, String sysUserId);
}
