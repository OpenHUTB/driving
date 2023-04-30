package com.xhb.pay.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import lombok.Data;

/**
 * 不同类型停车场平均停车时长
 *
 * @author yutao
 * @since 2019-10-17 16:47:33
 */
@Data
@TransTypes(types = {"wordbook"})
public class TempOrderNumberAndAmountDTO extends BaseDO<TempOrderNumberAndAmountDTO> {

    /**
     * 类型
     */
    @Trans(type = "wordbook", key = "park_type")
    private String parkType;

    /**
     * 日期
     */
    private String date;

    /**
     * 数量
     */
    private Integer number;

    /**
     * 金额
     */
    private Double amount;

}
