package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

/**
 * 内部客户网络支付订单(PayInsideCarOnlinePayTempOrder)实体类
 *
 * @author makejava
 * @since 2019-05-25 15:38:01
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_inside_car_online_pay_temp_order")
public class PayInsideCarOnlinePayTempOrder extends BaseDO<PayInsideCarOnlinePayTempOrder> {
    private static final long serialVersionUID = 287019896948588371L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //前段用户id
    @Length(message = "前段用户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("front_user_id")
    private String frontUserId;

    //物业费
    @TableField("property_fee")
    private Double propertyFee;

    //0 未缴纳 1 已缴纳 2 已退款
    @TableField("property_fee_status")
    private Integer propertyFeeStatus;

    //物业费gateway订单号
    @Length(message = "物业费gateway订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("property_fee_order_no")
    private String propertyFeeOrderNo;

    //车位数量
    @TableField("lot_num")
    private Integer lotNum;

    //开始生效日期
    @Length(message = "开始生效日期字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("start_date")
    private String startDate;

    //结束生效日期
    @Length(message = "结束生效日期字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("end_date")
    private String endDate;

    //停车费费用
    @TableField("monthly_fee")
    private Double monthlyFee;

    //0 未缴纳 1已缴纳 2已退款
    @TableField("monthly_fee_status")
    private Integer monthlyFeeStatus;

    //停车费订单号
    @Length(message = "停车费订单号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("monthly_fee_order_no")
    private String monthlyFeeOrderNo;

    //物业费支付时间
    @Length(message = "物业费支付时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("property_fee_pay_time")
    private String propertyFeePayTime;

    //物业费退款时间
    @Length(message = "物业费退款时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("property_fee_return_time")
    private String propertyFeeReturnTime;

    //停车费付款时间
    @Length(message = "停车费付款时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("monthly_fee_pay_time")
    private String monthlyFeePayTime;

    //停车费退款时间
    @Length(message = "停车费退款时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("monthly_fee_return_time")
    private String monthlyFeeReturnTime;

    //车位ids
    @Length(message = "车位ids字段的长度最大为1024", groups = {Add.class, Update.class}, max = 1024)
    @TableField("lot_ids")
    private String lotIds;

    //计费规则id
    @TableField("monthly_rule_id")
    private Long monthlyRuleId;

    //内部客户id
    @TableField("inside_id")
    private Long insideId;

    //月租户交费记录id
    @TableField("contract_id")
    private Long contractId;

    //超时时间
    @Length(message = "超时时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("time_out_time")
    private String timeOutTime;

    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //几个月
    @TableField("month_num")
    private Double monthNum;

    //用户姓名
    @Length(message = "用户姓名字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("name")
    private String name;

    //手机号
    @Length(message = "手机号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("mobile")
    private String mobile;

    //用“，”分割的车位号字符串
    @TableField(exist = false)
    private String lotNos;


}
