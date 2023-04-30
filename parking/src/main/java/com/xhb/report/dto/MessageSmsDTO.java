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
 * 短信通知报表
 *
 * @author wangjie
 * @Date 2019/6/6 14:40
 * </per>
 */
@Data
@TransTypes(types = {"wordbook"})
@ExcelTable(sheetName = "短信通知报表", workbookType = WorkbookType.SXLSX, excludeParent = true)
public class MessageSmsDTO extends BaseDO<MessageSmsDTO> {

    @ExcelColumn(index = 0, title = "日期")
    private String createTime;//时间

    @ExcelColumn(index = 1, title = "停车场名称")
    private String parkName;//所在车场

    @ExcelColumn(index = 2, title = "短信类型")
    @Trans(type = "wordbook", key = "message_type")
    private String messageType;//短信类型

    @ExcelColumn(index = 3, title = "短信数量")
    private Integer smsCount;//短信数量

    @ExcelColumn(index = 4, title = "集团编号")
    private String groupCode;//集团编号

    public MessageSmsDTO() {
    }

    public MessageSmsDTO(String createTime, String parkName, String messageType, Integer smsCount, String groupCode) {
        this.createTime = createTime;
        this.parkName = parkName;
        this.messageType = messageType;
        this.smsCount = smsCount;
        this.groupCode = groupCode;
    }
}
