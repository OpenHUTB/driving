package com.xhb.pay.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * <per>
 * 租户缴费记录
 *
 * @author wangjie
 * @Date 2019/6/10 17:48
 * </per>
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PayInsideContractVo {

    private Long id;//

    private String ownerName;//用户名

    private String ownerMobile;//用户电话

    private Long parkId;//停车场id

    private String groupCode;//集团编号

    private String endDate;//结束时间

    private String parkName;//停车场名称

    private String bufferDays;//月租到期缓冲天数

    /**
     * 内部客户车牌号
     */
    private String plateNums;

    /**
     * 前端用户id
     */
    private String frontUserId;


}
