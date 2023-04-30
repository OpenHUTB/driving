package com.xhb.park.service;


import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkRegionLot;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * (ParkRegionLot)表服务接口
 *
 * @author makejava
 * @since 2019-05-24 10:37:43
 */
public interface ParkRegionLotService extends BaseService<ParkRegionLot> {


    /**
     * 未占用
     */
    int IN_THE_FREE = 0;

    /**
     * 已锁定待付款
     */
    int IN_THE_BOOK = 1;

    /**
     * 租赁中
     */
    int IN_THE_USE = 2;

    /**
     * 已超时
     */
    int IN_TIME_OUT = 4;

    /**
     * 超时时间
     */
    int TIME_OUT_MINUTES = 10;


    /**
     * 批量导入
     *
     * @param paramMap 当前登录用户Id（sysUserId）,停车场id（parkId）,区域id（regionId）,集团编码（groupCode）
     * @param file     文件
     * @return
     */
    boolean batchImport(Map<String, String> paramMap, MultipartFile file);

    /**
     * 查询车位号，区域名称
     *
     * @param id
     * @return
     */

    String getLotAndRegionInfo(Long id);


    /**
     * 车位解绑
     * @param sn
     * @return
     */
    int noBoundParkingSpace(String sn);


}
