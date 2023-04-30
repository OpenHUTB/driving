package com.xhb.report.vo;

import lombok.Builder;
import lombok.Data;

/**
 * 万能复用报表VO
 */
@Data
@Builder
public class ReportVO {
    /**
     * id
     */
    private String id;
    /**
     * 健
     */
    private String key;
    /**
     * 值
     */
    private Object content;
}
