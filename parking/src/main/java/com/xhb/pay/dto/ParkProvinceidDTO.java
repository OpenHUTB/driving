package com.xhb.pay.dto;

import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import lombok.Data;

/**
 * operator 区域翻译
 *
 * @author yutao
 * @since 2019-10-11 09:22:11
 */
@Data
@TransTypes(types = {Constant.AREA_INFO})
public class ParkProvinceidDTO extends BaseDO<ParkProvinceidDTO> {

    /**
     * 区域名称
     */
    @Trans(type = Constant.AREA_INFO, key = "areaParentId")
    private String provinceid;

    /**
     * 金额
     */
    private Double amount;

    /**
     * 停车位数量
     */
    private Integer number;

}
