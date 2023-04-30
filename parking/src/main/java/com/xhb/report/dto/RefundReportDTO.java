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
 * 退款明细
 *
 * @author wangjie
 * @Date 2019/6/11 12:22
 * </per>
 */
@Data
@TransTypes(types = {"sysUser"})
@ExcelTable(sheetName = "退款明细", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class RefundReportDTO extends BaseDO<RefundReportDTO> {

    @ExcelColumn(index = 1, title = "内部用户名称")
    private String ownerName;//内部用户名称

    @ExcelColumn(index = 2, title = "电话")
    private String ownerMobile;//电话

    @ExcelColumn(index = 3, title = "客户类型")
    private String leaseName;//客户类型

    @ExcelColumn(index = 4, title = "退款时间")
    private String createTime;//退款时间

    @ExcelColumn(index = 5, title = "退款金额")
    private Double refundAmount;//退款金额

    @ExcelColumn(index = 6, title = "扣手续费")
    private Double serviceAmount;//扣手续费

    @ExcelColumn(index = 7, title = "扣赠送金额")
    private Integer giveAmount;//扣赠送金额

    @ExcelColumn(index = 8, title = "月租结束日期")
    private String endDate;//月租结束日期

    @ExcelColumn(index = 9, title = "退款接收人")
    private String refundCusName;//接收退款客户名称

    @ExcelColumn(index = 10, title = "当班人员")
    @Trans(type = "sysUser", key = "sysUser:userName")
    private String collectorName;//当班人员

    @ExcelColumn(index = 11, title = "备注")
    private String remark;//备注

    public RefundReportDTO() {
    }

    public RefundReportDTO(String ownerName, String ownerMobile, String leaseName, String createTime, Double refundAmount, Double serviceAmount, Integer giveAmount, String endDate, String refundCusName, String collectorName, String remark) {
        this.ownerName = ownerName;
        this.ownerMobile = ownerMobile;
        this.leaseName = leaseName;
        this.createTime = createTime;
        this.refundAmount = refundAmount;
        this.serviceAmount = serviceAmount;
        this.giveAmount = giveAmount;
        this.endDate = endDate;
        this.refundCusName = refundCusName;
        this.collectorName = collectorName;
        this.remark = remark;
    }
}
