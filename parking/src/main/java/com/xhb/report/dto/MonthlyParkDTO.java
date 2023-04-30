package com.xhb.report.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 长租用户收入全览
 *
 * @author wangjie
 * @Date 2019/6/13 11:32
 * </per>
 */
@Data
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "长租", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class MonthlyParkDTO extends BaseDO<MonthlyParkDTO> {

    @ExcelColumn(index = 1, title = "日期")
    private String payTime;//日期

    @ExcelColumn(index = 2, title = "现金收取")
    private Double incomeAmount;//现金收取

    @ExcelColumn(index = 3, title = "车位数")
    private Integer incomePark;//现金停车位

    @ExcelColumn(index = 4, title = "现金退费")
    private Double refundAmount;//现金退费

    @ExcelColumn(index = 5, title = "车位数")
    private Integer refundPark;//退费车位数

    @ExcelColumn(index = 6, title = "电子支付")
    private Double electronicPay;//电子支付

    @ExcelColumn(index = 7, title = "车位数")
    private Integer electronicPark;//车位数

    @ExcelColumn(index = 8, title = "收入合计")
    private Double amountTotal;//收入合计

    @ExcelColumn(index = 9, title = "有效车位总数")
    private Integer parkTotal;//车位总数

    private Long parkId;//停车场id

    public MonthlyParkDTO() {
    }

    public MonthlyParkDTO(String payTime, Double incomeAmount, Integer incomePark, Double refundAmount, Integer refundPark, Double electronicPay, Integer electronicPark, Double amountTotal, Integer parkTotal) {
        this.payTime = payTime;
        this.incomeAmount = incomeAmount;
        this.incomePark = incomePark;
        this.refundAmount = refundAmount;
        this.refundPark = refundPark;
        this.electronicPay = electronicPay;
        this.electronicPark = electronicPark;
        this.amountTotal = amountTotal;
        this.parkTotal = parkTotal;
    }
}
