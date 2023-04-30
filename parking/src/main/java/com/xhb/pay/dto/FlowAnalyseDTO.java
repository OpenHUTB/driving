package com.xhb.pay.dto;

import lombok.Data;

/**
 * 每日车流分析
 *
 * @author yutao
 * @since 2019-10-11 09:22:11
 */
@Data
public class FlowAnalyseDTO {
    //日期
    private String date;

    //固定车
    private Integer monthCarNum;

    //临时车
    private Integer tempCarNum;

    //合计
    private Integer totalCarNum;

}
