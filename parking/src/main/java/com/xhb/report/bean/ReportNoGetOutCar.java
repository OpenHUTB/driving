package com.xhb.report.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.SuperBean;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Builder;
import lombok.Data;

/**
 * (ReportNoExistCar)实体类
 *
 * @author makeJun
 * @since 2020-01-17 14:42:14
 */

@Data
@Builder
@TableName("t_report_no_getout_car")
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "出库统计报表", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class ReportNoGetOutCar extends SuperBean<ReportNoGetOutCar> {
    private static final long serialVersionUID = 119395073113491518L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    @TableField("park_name")
    @ExcelColumn(index = 0, title = "停车场")
    private String parkName;

    @TableField("plate_number")
    @ExcelColumn(index = 1, title = "车牌号")
    private String plateNumber;

    @TableField("access_time")
    @ExcelColumn(index = 2, title = "入场时间")
    private String accessTime;

    @TableField("port_name")
    @ExcelColumn(index = 3, title = "出入口")
    private String portName;

    @TableField("record_type")
    @ExcelColumn(index = 4, title = "停车类型")
    @Trans(type = "wordbook", key = "record_type")
    private String recordType;

    @TableField("img")
    @ExcelColumn(index = 5, title = "入场图片")
    private String img;

    @TableField("park_id")
    private Long parkId;

    @TableField("group_code")
    private String groupCode;

    public ReportNoGetOutCar() {
    }

    public ReportNoGetOutCar(Long id, String parkName, String plateNumber, String accessTime, String portName, String recordType, String img, Long parkId, String groupCode) {
        this.id = id;
        this.parkName = parkName;
        this.plateNumber = plateNumber;
        this.accessTime = accessTime;
        this.portName = portName;
        this.recordType = recordType;
        this.img = img;
        this.parkId = parkId;
        this.groupCode = groupCode;
    }
}
