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
 * 储值用户充值
 *
 * @author wangjie
 * @Date 2019/6/11 12:08
 * </per>
 */
@Data
@TransTypes(types = {"wordbook", "sysUser"})
@ExcelTable(sheetName = "储值卡充值明细", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class RechargeReportDTO extends BaseDO<RechargeReportDTO> {

    @ExcelColumn(index = 1, title = "内部用户名称")
    private String ownerName;//内部用户名称

    @ExcelColumn(index = 2, title = "电话")
    private String ownerMobile;//电话

    @ExcelColumn(index = 3, title = "客户类型")
    private String leaseName;//客户类型

    @ExcelColumn(index = 4, title = "充值时间")
    private String createTime;//包月充值时间

    @ExcelColumn(index = 5, title = "充值金额")
    private Double amount;//充值金额

    @ExcelColumn(index = 6, title = "赠送金额")
    private Integer giveAmount;//赠送金额

    @ExcelColumn(index = 7, title = "充值方式")
    @Trans(type = "wordbook", key = "recharge_type")
    private String rechargeType;//充值方式

    @ExcelColumn(index = 8, title = "当班人员")
    @Trans(type = "sysUser", key = "sysUser:userName")
    private String collectorName;//当班人员

    @ExcelColumn(index = 9, title = "备注")
    private String remark;//备注

    public RechargeReportDTO() {
    }

    public RechargeReportDTO(String ownerName, String ownerMobile, String leaseName, String createTime, Double amount, Integer giveAmount, String rechargeType, String collectorName, String remark) {
        this.ownerName = ownerName;
        this.ownerMobile = ownerMobile;
        this.leaseName = leaseName;
        this.createTime = createTime;
        this.amount = amount;
        this.giveAmount = giveAmount;
        this.rechargeType = rechargeType;
        this.collectorName = collectorName;
        this.remark = remark;
    }
}
