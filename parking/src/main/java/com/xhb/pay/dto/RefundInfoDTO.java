package com.xhb.pay.dto;

import lombok.Data;

/**
 * 扣费信息(储户时段租用户扣费，月租用户扣费)
 */
@Data
public class RefundInfoDTO {
    private String userId;              //用户id
    private String groupCode;           //集团编码

    private Long parkId;              //停车场id
    private Long insideId;            //内部用户id
    private Double refundAmont;         //退款金额
    private String refundCusName;       //接收退款人
    private String remark;              //备注
    private Integer lotNum;              //车位数

    private String monthlyEndDate;      //月租结束日期
    private Long contractId;          //月租户充值记录id,月租户必插


    private Double deductGiveAmount;    //扣除赠送金额
    private Double serviceAmount;       //手续费金额


}
