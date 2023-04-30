package com.xhb.report.vo;

import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

/**
 * 时间关系报表VO
 */
@Data
@Builder
public class DateReportVO implements Serializable,Comparable<DateReportVO>{

    private static final long serialVersionUID = 5641364104287238555l;

    /**
     * 时
     */
    private int hour;
    /**
     * 入场
     */
    private long entrance;
    /**
     * 出场
     */
    private long prep;
    /**
     * 订单数
     */
    private long order;
    /**
     * 使用率
     */
    private String proportion;


    @Override
    public int compareTo(DateReportVO vo) {
        return this.getHour() - vo.getHour();
    }
}
