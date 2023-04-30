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
 * 月租户包月
 *
 * @author wangjie
 * @Date 2019/6/11 11:44
 * </per>
 */
@Data
@TransTypes(types = {"wordbook", "sysUser"})
@ExcelTable(sheetName = "月租户包月明细", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class MonthlyReportDTO extends BaseDO<MonthlyReportDTO> {

    @ExcelColumn(index = 1, title = "内部用户名称")
    private String ownerName;//内部用户名称

    @ExcelColumn(index = 2, title = "电话")
    private String ownerMobile;//电话

    @ExcelColumn(index = 3, title = "客户类型")
    private String leaseName;//客户类型

    @ExcelColumn(index = 4, title = "包月充值时间")
    private String createTime;//包月充值时间

    @ExcelColumn(index = 5, title = "租赁规则")
    private String ruleName;//租赁规则

    @ExcelColumn(index = 6, title = "充值金额")
    private Double amount;//充值金额

    @ExcelColumn(index = 7, title = "包月开始日期")
    private String startDate;//包月开始日期

    @ExcelColumn(index = 8, title = "包月结束日期")
    private String endDate;//包月结束日期

    @ExcelColumn(index = 9, title = "付费充值月数")
    private Integer rechargeMonth;//付费充值月数

    @ExcelColumn(index = 10, title = "赠送月数")
    private Integer giveMonthNum;//赠送月数

    @ExcelColumn(index = 11, title = "赠送天数")
    private Integer giveDayNum;//赠送天数

    @ExcelColumn(index = 12, title = "充值方式")
    @Trans(type = "wordbook", key = "recharge_type")
    private String rechargeType;//充值方式

    @ExcelColumn(index = 13, title = "当班人员")
    @Trans(type = "sysUser", key = "sysUser:userName")
    private String collectorName;//当班人员

    @ExcelColumn(index = 14, title = "备注")
    private String remark;//备注

    public MonthlyReportDTO() {
    }

    public MonthlyReportDTO(String ownerName, String ownerMobile, String leaseName, String createTime, String ruleName, Double amount, String startDate, String endDate, Integer rechargeMonth, Integer giveMonthNum, Integer giveDayNum, String rechargeType, String collectorName, String remark) {
        this.ownerName = ownerName;
        this.ownerMobile = ownerMobile;
        this.leaseName = leaseName;
        this.createTime = createTime;
        this.ruleName = ruleName;
        this.amount = amount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.rechargeMonth = rechargeMonth;
        this.giveMonthNum = giveMonthNum;
        this.giveDayNum = giveDayNum;
        this.rechargeType = rechargeType;
        this.collectorName = collectorName;
        this.remark = remark;
    }
}
