package com.xhb.pay.vo;

import lombok.Data;

/**
 * 特殊放行下班报表记录
 */
@Data
public class PaySpecialPassVo {

    private String describ;//特殊放行描述

    private String count;//数量

    private String amount;//总金额

    public PaySpecialPassVo() {

    }

    public PaySpecialPassVo(String describ, String count, String amount) {
        this.describ = describ;
        this.count = count;
        this.amount = amount;
    }
}
