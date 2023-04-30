package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.Syncable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 内部用户账户退款(PayInsideRefund)实体类
 *
 * @author makejava
 * @since 2019-05-31 17:06:10
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_inside_refund")
@TransTypes(types = {"wordbook", Constant.USER_INFO})
public class PayInsideRefund extends BaseDO<PayInsideRefund> implements Syncable {
    private static final long serialVersionUID = 150566794324241914L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    @NotNull(message = "内部客户id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("inside_id")
    private Long insideId;

    //是否是月租户
    @NotNull(message = "是否是月租户字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_contract")
    @Trans(type = Constant.WORD_BOOK, key = "yesOrNo")
    private Integer isContract;

    @NotNull(message = "parkId字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    @NotNull(message = "是否同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    @Trans(type = Constant.WORD_BOOK, key = "is_sync")
    private Integer isSync;

    //月租户充值记录id，月租户退款必填
    @TableField("contract_id")
    private Long contractId;

    //退款金额
    @NotNull(message = "退款金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("refund_amont")
    private Double refundAmont;

    @Length(message = "备注字段的长度最大为215", groups = {Add.class, Update.class}, max = 215)
    @TableField("remark")
    private String remark;

    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;


    //接收退款的客户名称
    @NotEmpty
    @NotNull(message = "接收退款的客户名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "接收退款的客户名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("refund_cus_name")
    private String refundCusName;

    //手续费
    @TableField("service_amount")
    private Double serviceAmount;

    //扣除赠送的费用的金额
    @TableField("deduct_give_amount")
    private Double deductGiveAmount;

    //月租结束日期提前到哪天
    @TableField("monthly_end_date")
    private String monthlyEndDate;

    //车位数
    @TableField("lot_num")
    private Integer lotNum;

    //内部客户姓名
    @TableField(exist = false)
    private String ownerName;

    //内部客户电话
    @TableField(exist = false)
    private String ownerMobile;

    //内部客户车牌号
    @TableField(exist = false)
    private String plateNums;

    //停车场名称
    @TableField(exist = false)
    private String parkName;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
