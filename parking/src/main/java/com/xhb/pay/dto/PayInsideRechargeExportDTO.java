package com.xhb.pay.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import lombok.Data;

/**
 * <per>
 * 内部客户充值记录
 *
 * @author wangy
 * @Date 2019/6/26 14:40
 * </per>
 */
@Data
@TransTypes(types = {"sysUser", "wordbook"})
@ExcelTable(sheetName = "内部客户充值记录", workbookType = WorkbookType.SXLSX, excludeParent = true, includeAllField = false)
public class PayInsideRechargeExportDTO extends BaseDO<PayInsideRechargeExportDTO> {

    //内部客户Id
    private Long insideId;

    //停车场名称
    @ExcelColumn(index = 0, title = "停车场名称")
    private String parkName;

    //内部客户姓名
    @ExcelColumn(index = 1, title = "内部客户姓名")
    private String ownerName;

    //内部客户电话
    @ExcelColumn(index = 2, title = "内部客户电话")
    private String ownerMobile;

    @ExcelColumn(index = 3, title = "房间号")
    private String roomNum;

    //内部客户车牌号
    @ExcelColumn(index = 4, title = "内部客户车牌号")
    private String plateNums;

    //车位信息
    @ExcelColumn(index = 5, title = "车位信息")
    private String plateInfo;

    //充值金额
    @ExcelColumn(index = 6, title = "充值金额")
    private Double amount;

    //赠送金额
    @ExcelColumn(index = 7, title = "赠送金额")
    private Double giveAmount;

    //是否是月租户充值
    @ExcelColumn(index = 8, title = "是否是月租")
    @Trans(type = "wordbook", key = "yesOrNo")
    private String isContract;

    //1 后台系统 2 公众号/支付宝 3 APP 4 小程序
    @ExcelColumn(index = 9, title = "充值方式")
    @Trans(type = "wordbook", key = "from_type")
    private String fromType;

    @ExcelColumn(index = 10, title = "操作人")
    private String createUserName;

    @ExcelColumn(index = 11, title = "操作时间")
    private String createTime;
}
