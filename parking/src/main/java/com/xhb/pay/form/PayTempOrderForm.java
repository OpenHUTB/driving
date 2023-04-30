package com.xhb.pay.form;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 临时订单列表的条件查询需要此form
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PayTempOrderForm {
    //停车场Id
    private Long parkId;
    //车牌号
    private String plateNumber;
    //收费员id
    private Long collectorId;
    //订单状态0：未支付 1：已支付 3：免费放行;4:黑名单放行 5:异常订单 -1:撤销
    private Integer orderStatus;
    //页数
    private Integer page;
    //显示条数
    private Integer rows;
    //从第几条显示
    private Long num;
    //最小支付时间
    private String payTimeMin;
    //最大支付时间
    private String payTimeMax;
    //最小出入场时间
    private String enterTimeMin;
    //最大出入场时间
    private String enterTimeMax;
    //集团编码
    private String groupCode;
    //有权限查看的停车场
    private String parkIds;
    //用户权限
    private Integer admin;
}
