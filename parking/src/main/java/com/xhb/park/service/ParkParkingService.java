package com.xhb.park.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.park.bean.ParkParking;

import java.util.List;
import java.util.Map;

/**
 * 停车场表(ParkParking)表服务接口
 *
 * @author jackwong
 * @since 2019-03-13 15:10:45
 */
public interface ParkParkingService extends BaseService<ParkParking> {

    /**
     * 入库
     */
    int STATUS_INDB = 0;

    /**
     * 创建订单
     */
    int STATUS_CREATE_ORDER = 1;

    /**
     * 已支付
     */
    int STATUS_HAS_PAY = 2;

    /**
     * 短信通知
     */
    int SMS_NOTICE = 3;

    /**
     * 公众号和短信通知
     */
    int PUBLIC_NOTICE = 2;

    /**
     * 单个场
     */
    String BIG_PARK_TYPE_SINGLE = "0";

    /**
     * 场中场单个运营主体
     */
    String BIG_PARK_TYPE_SINGLE_MULT_ONE_OPERATOR = "1";


    /**
     * 场中场多个运营主体
     */
    String BIG_PARK_TYPE_SINGLE_MULT_MANY_OPERATOR = "2";

    /**
     * ROOT车场
     */
    Long ROOT = 0L;

    /**
     * 混合统计
     */

    int SPACE_MIX_CENSUS = 1;

    /**
     * 分开统计
     */

    int SPACE_SEPARATE_CENSUS = 0;


    int default_palte = 1;

    int yellow_plate = 2;

    int green_palte = 5;

    /**
     * 停车场 路边停车
     */
    int PARK_ROAD_YES = 1;

    int PARK_ROAD_NO = 0;

    /**
     * 获取父停车场，如果本身是父停车场
     * 那么返回自己
     *
     * @param parkId 停车场id
     * @return 父停车场
     */
    ParkParking getParentPark(Long parkId);

    /**
     * 获取一个子parkid或者父parkid下面所有的parkid返回list集合
     *
     * @param parkId parkId
     * @return 多个兄弟车厂的id集合
     */
    List<Long> getAllParkIdsForBigParkReturnList(Long parkId);


}
