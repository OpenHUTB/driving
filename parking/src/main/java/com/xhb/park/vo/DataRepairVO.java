package com.xhb.park.vo;

import lombok.Data;

/**
 * 云端选择数据下发
 */
@Data
public class DataRepairVO {

    /**
     * 表名
     */
    private String tableName;

    /**
     * 表title
     */
    private String title;

    /**
     *
     */
    private String isBigger;

    /**
     * 开始时间
     */
    private String staData;

    /**
     * 结束时间
     */
    private String endData;

}
