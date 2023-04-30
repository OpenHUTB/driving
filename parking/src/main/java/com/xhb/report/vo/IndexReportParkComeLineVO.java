package com.xhb.report.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 首页不同车场近30日入场记录统计VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class IndexReportParkComeLineVO {

    /**
     * 停车场名称
     */
    private List<String> parkNameList;

    /**
     * 日期集合
     */
    private List<String> dateList;

    /**
     * 停车场数据
     */
    private List<OneParkData> parkDataList;

    public static class OneParkData {
        public String name;
        public String type = "line";
        public List<Integer> data;
    }
}
