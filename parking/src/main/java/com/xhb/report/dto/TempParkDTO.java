package com.xhb.report.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 临时停车收费全览
 *
 * @author wangjie
 * @Date 2019/6/13 11:31
 * </per>
 */
@Data
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "临停", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class TempParkDTO extends BaseDO<TempParkDTO> {

    @ExcelColumn(index = 1, title = "日期")
    private String payTime;//日期

    @ExcelColumn(index = 2, title = "现金合计")
    private Double amountTotal;//现金合计

    @ExcelColumn(index = 3, title = "现金支付")
    private Double pavilionAmount;//现金支付

    @ExcelColumn(index = 4, title = "手动抬杆现金")
    private Double liftingRodAmount;//手动抬杆现金

    @ExcelColumn(index = 5, title = "网络支付")
    private Double electronicPayment;//网络支付

    @ExcelColumn(index = 6, title = "出场车次")
    private Integer outCarNumber;//出场车次

    public TempParkDTO() {
    }

    public TempParkDTO(String payTime, Double amountTotal, Double pavilionAmount, Double liftingRodAmount, Double electronicPayment, Integer outCarNumber) {
        this.payTime = payTime;
        this.amountTotal = amountTotal;
        this.pavilionAmount = pavilionAmount;
        this.liftingRodAmount = liftingRodAmount;
        this.electronicPayment = electronicPayment;
        this.outCarNumber = outCarNumber;
    }

}
