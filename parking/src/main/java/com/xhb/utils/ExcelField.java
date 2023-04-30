package com.xhb.utils;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ExcelField {
    /**
     * 文本类型：支持【text】【label】【select】
     */
    private String type;

    /**
     * 字段code
     */
    private String code;

    /**
     * 字段名称
     */
    private String name;

    /**
     * 校验规则：【required】
     */
    private String rule;

    /**
     * 是否导入
     */
    private Boolean importFlag;

    /**
     * 是否导出
     */
    private Boolean export;

    /**
     * 导入重复校验
     */
    private Boolean notRepeat;

    /**
     * 导出模板宽度: 默认是2000(4个字的距离)
     */
    private Integer with;

    /**
     * 下拉字典code：
     */
    private String selectWordbookCode;

    /**
     * 是否隐藏
     */
    private Boolean hidden;
}
