package com.xhb.report.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Calendar;

/**
 * 停车场报表VO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParkingVO {
    /**
     * 停车场ID
     */
    private Long id;
    /**
     * 名称
     */
    private String name;
    /**
     * 总车位
     */
    private long totalParkingSpace;
    /**
     * 已使用车位
     */
    private long occupyParkingSpace;

    /**
     * 值
     */
    private String value;

    /**
     * 今日最大值
     */
    private double dayMax;
    /**
     * 获取车位占用情况
     * @return
     */
    public Integer getState(){
        if (totalParkingSpace > 0){
            if (occupyParkingSpace > (totalParkingSpace * 0.8)){
                return 3;
            }else
            if (occupyParkingSpace <= (totalParkingSpace * 0.8) && occupyParkingSpace > (totalParkingSpace * 0.6)){
                return 2;
            }else
            if (occupyParkingSpace <= (totalParkingSpace * 0.6)){
                return 1;
            }
        }
        return null;
    }
    /**
     * 获取车位占用情况
     * @return
     */
    public String getPercentage(){
        if (value != null && Double.parseDouble(value) > 0){
            return String.format("%.2f", (Double.parseDouble(value) / dayMax) * 100) + "%";
        }
        return "0.00%";
    }

}
