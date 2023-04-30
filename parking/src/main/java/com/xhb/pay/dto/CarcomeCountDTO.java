package com.xhb.pay.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import lombok.Data;

/**
 * 进出口数量统计
 *
 * @author yutao
 * @since 2019-10-11 09:22:11
 */
@Data
@TransTypes(types = {"wordbook"})
public class CarcomeCountDTO extends BaseDO<CarcomeCountDTO> {
    //进出口名称
    private String portName;

    //类型1入 2出
    private Integer type;

    //数量
    private Integer number;

    /**
     * 报表需要翻译
     * 类型
     */
    @Trans(type = "wordbook", key = "park_type")
    private String parkType;

    /**
     * 小时
     */
    private String hour;

}
