package com.xhb.pay.vo;

import lombok.Data;

/**
 * 减免分类下班报表记录
 */
@Data
public class ParkReliefTypeVo {

    private String reliefName;//减免分类名称

    private String count;//数量

    private String amount;//现金收费总金额

    public ParkReliefTypeVo() {

    }

    public ParkReliefTypeVo(String reliefName, String count, String amount) {
        this.reliefName = reliefName;
        this.count = count;
        this.amount = amount;
    }
}
