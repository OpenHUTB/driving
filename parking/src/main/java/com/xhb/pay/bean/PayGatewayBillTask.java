package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * (PayGatewayBillTask)实体类
 *
 * @author makejava
 * @since 2019-06-13 12:49:38
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_gateway_bill_task")
public class PayGatewayBillTask extends BaseDO<PayGatewayBillTask> {
    private static final long serialVersionUID = 114526353396270404L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //商户id
    @NotNull(message = "商户id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("mch_id")
    private Long mchId;

    //对账任务日期
    @NotEmpty
    @NotNull(message = "对账任务日期字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "对账任务日期字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("bill_task_date")
    private String billTaskDate;

    //状态0 已创建 1 已下载对账文件 2 已完成
    @NotNull(message = "状态0 已创建 1 已下载对账文件 2 已完成字段不可为null", groups = {Update.class, Delete.class})
    @TableField("status")
    private Integer status;

    //备注
    @Length(message = "备注字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("remark")
    private String remark;

    //错误信息
    @Length(message = "错误信息字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("error_info")
    private String errorInfo;

    //金额不一致的订单总数
    @TableField("inconsistent_amont_nums")
    private Integer inconsistentAmontNums;

    //威富通丢单
    @TableField("swiftpass_miss_nums")
    private Integer swiftpassMissNums;

    //停车场丢单
    @TableField("park_miss_nums")
    private Integer parkMissNums;

    //清算订单数
    @TableField("square_num")
    private Integer squareNum;

    /**
     * 清算总金额
     */
    @TableField("square_amont")
    private Double squareAmont;

    /**
     * 当日总手续费
     */
    @TableField("square_service_charge")
    private Double squareServiceCharge;

    /**
     * 文件id
     */
    @TableField("file_id")
    private String fileId;

    /**
     * 集团编码
     */
    @TableField("group_code")
    private String groupCode;

    /**
     * 商户名称
     */
    @TableField("mch_name")
    private String mchName;

    /**
     * 支付宝清算金额
     */
    @TableField("alipay_square_amont")
    private Double alipaySquareAmont;

    /**
     * 微信清算金额
     */
    @TableField("weixin_square_amont")
    private Double weixinSquareAmont;

    /**
     * 支付宝清算订单数量
     */
    @TableField("alipay_square_num")
    private Integer alipaySquareNum;

    /**
     * 微信清算订单数量
     */
    @TableField("weixin_square_num")
    private Integer weixinSquareNum;


}
