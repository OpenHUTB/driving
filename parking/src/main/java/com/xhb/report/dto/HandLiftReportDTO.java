package com.xhb.report.dto;

import com.fhs.core.base.bean.BaseDO;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 手动抬杆
 *
 * @author wangjie
 * @Date 2019/6/21 14:12
 * </per>
 */
@Data
@ExcelTable(sheetName = "手动抬杆明细", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class HandLiftReportDTO extends BaseDO<HandLiftReportDTO> {

    @ExcelColumn(index = 0, title = "停车场名称")
    private String parkName;   //停车场

    @ExcelColumn(index = 1, title = "出入口名称")
    private String portName; //出入口名称

    @ExcelColumn(index = 2, title = "收费员")
    private String collectorName; //收费员

    @ExcelColumn(index = 3, title = "收费金额")
    private Double cashPay;//收费金额

    @ExcelColumn(index = 4, title = "抬杆原因")
    private String remark;  //手动抬杆原因

    @ExcelColumn(index = 5, title = "抬杆时间")
    private String payTime;//抬杆时间


    public HandLiftReportDTO() {
    }

    public HandLiftReportDTO(String parkName, String portName, String collectorName, Double cashPay, String remark, String payTime) {
        this.parkName = parkName;
        this.portName = portName;
        this.collectorName = collectorName;
        this.cashPay = cashPay;
        this.remark = remark;
        this.payTime = payTime;
    }
}
