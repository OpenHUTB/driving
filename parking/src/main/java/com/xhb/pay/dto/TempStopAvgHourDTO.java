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
public class TempStopAvgHourDTO extends BaseDO<TempStopAvgHourDTO> {

    /**
     * 类型名称
     */
    @Trans(type = "wordbook", key = "park_type")
    private String parkType;

    /**
     * 总条数
     */
    private Integer number;

    /**
     * 总时间（单位是秒）
     */
    private Integer parkingTime;

}
