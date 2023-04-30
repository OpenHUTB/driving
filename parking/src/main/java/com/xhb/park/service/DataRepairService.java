package com.xhb.park.service;

import com.xhb.park.vo.DataRepairVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface DataRepairService {

    /**
     * 根据停车场id下发数据
     *
     * @param parkId
     */
    void repairAllData(Long parkId);

    /**
     * 修复数据
     * @param dataRepairVOList 指定修复范围
     * @param parkId 停车场id
     */
    void repairData(List<DataRepairVO> dataRepairVOList,Long parkId);

    default List<Map<String, String>> getTblSett() {
        //map 有三个key分别是title tableName isBigger
        List<Map<String, String>> result = new ArrayList<>();
        Map<String, String> oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_parking");
        oneTableMap.put("title", "停车场");
        oneTableMap.put("isBigger", "true");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_temp_order");
        oneTableMap.put("title", "临时出入场缴费");
        oneTableMap.put("isBigger", "true");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_blacklist");
        oneTableMap.put("title", "黑名单");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_config");
        oneTableMap.put("title", "车场配置");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_lease_type");
        oneTableMap.put("title", "租户类型");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_monthly_rule");
        oneTableMap.put("title", "月租用户收费规则");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_parking_port");
        oneTableMap.put("title", "进出口管理");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_temp_rule");
        oneTableMap.put("title", "临时用户收费规则");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_temp_segment");
        oneTableMap.put("title", "临时用户收费规则");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_monthly_record");
        oneTableMap.put("title", "月租户充值记录");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_ucenter_toll_collector");
        oneTableMap.put("title", "收费人员");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_free_car_temp");
        oneTableMap.put("title", "临时免费车");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_carcome");
        oneTableMap.put("title", "车辆入场记录");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_free_car");
        oneTableMap.put("title", "免费车配置");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_free_car_onece");
        oneTableMap.put("title", "一次性免费车");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);


        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_special_pass_type");
        oneTableMap.put("title", "特殊放行类型");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_inside_balance_change_log");
        oneTableMap.put("title", "内部车余额变动日志");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_inside_car");
        oneTableMap.put("title", "月租户数据");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_inside_contract");
        oneTableMap.put("title", "月租户交费数据");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_inside_plate_bind");
        oneTableMap.put("title", "月租户绑定车牌数据");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_pay_inside_recharge");
        oneTableMap.put("title", "充值记录表");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);



        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_business_cash_coupon");
        oneTableMap.put("title", "现金券");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);


        oneTableMap = new HashMap<>();
        oneTableMap.put("tableName", "t_park_relief_type");
        oneTableMap.put("title", "减免分类");
        oneTableMap.put("isBigger", "false");
        result.add(oneTableMap);

        return result;
    }
}
