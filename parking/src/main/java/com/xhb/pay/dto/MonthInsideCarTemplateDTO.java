package com.xhb.pay.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MonthInsideCarTemplateDTO {

    /**
     * 客户姓名
     */
    private String ownerName;

    /**
     * 客户电话
     */
    private String ownerMobile;

    /**
     * 车位数
     */
    private Integer lotNum;

    /**
     * 月租户类型(需要和系统中月租户类型名称完全匹配)
     */
    private String leaseTypeId;

    /**
     * 余额(精确到小数点后2位)
     */
    private Double balance;

    /**
     * 车牌号(多个车牌号以英文逗号分隔)
     */
    private String plateNums;

    /**
     * 月租户收费规则名称(需要和系统月租户收费规则名称完全匹配)
     */
    private String ruleId;

    /**
     * 月卡开始日期 t_pay_inside_contract
     */
    private String startDate;

    /**
     * 月卡结束日期 t_pay_inside_contract
     */
    private String endDate;
}
