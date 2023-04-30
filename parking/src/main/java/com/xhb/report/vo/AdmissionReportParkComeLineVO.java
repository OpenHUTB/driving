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
public class AdmissionReportParkComeLineVO {

    /**
     * 出/入场
     */
    private List<String> admissionList;

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
        public String type;
        public List<Object> data;
        public int yAxisIndex;

    }

}
