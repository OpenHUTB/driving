package com.xhb.report.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

/**
 * 车厂报表VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParkingReportVO {

    /**
     * 停车场总数
     */
    private long total;
    /**
     * 封闭停车场
     */
    private long close;
    /**
     * 路边停车场
     */
    private long road;
    /**
     * 停车场列表
     */
    private List<ParkingVO> parkingList;
}
