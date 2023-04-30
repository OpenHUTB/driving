package com.xhb.report.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 未出库统计报表
 *
 * @author wangy
 * @Date 2019/6/26 14:40
 * </per>
 */
@Data
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "出库统计报表", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class UnattendedDTO extends BaseDO<UnattendedDTO> {

    private Long parkId;

    @ExcelColumn(index = 0, title = "停车场")
    private String parkName;//停车场

    @ExcelColumn(index = 1, title = "车牌号")
    private String plateNumber;//车牌号


    @ExcelColumn(index = 2, title = "入场时间")
    private String accessTime;//入场时间

    @ExcelColumn(index = 3, title = "出入口")
    private String portName;//出入口

    @ExcelColumn(index = 5, title = "入场图片")
    private String enterId;//入场图片

    @ExcelColumn(index = 4, title = "停车类型")
    @Trans(type = "wordbook", key = "record_type")
    private String recordType;//停车类型

    public UnattendedDTO() {
    }

    public UnattendedDTO(String parkName, String plateNumber, String accessTime, String portName, String recordType, String enterId, Long parkId) {
        this.parkName = parkName;
        this.plateNumber = plateNumber;
        this.accessTime = accessTime;
        this.portName = portName;
        this.recordType = recordType;
        this.enterId = enterId;
        this.parkId = parkId;
    }
}
