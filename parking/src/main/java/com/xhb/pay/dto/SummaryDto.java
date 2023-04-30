package com.xhb.pay.dto;

import lombok.Data;

/**
 * 收费员汇总 参数传递
 *
 * @author yutao
 * @since 2019-08-29 16:47:33
 */
@Data
public class SummaryDto {
    //收费员Id
    private Long collectorId;
    //开始时间
    private String startTime;
    //结束时间
    private String endTime;
}
