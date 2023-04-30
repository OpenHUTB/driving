package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.xhb.park.bean.ParkParking;
import lombok.*;

/**
 * 网关支付订单(PayGatewayOrder)实体类
 *
 * @author jackwong
 * @since 2019-03-06 19:56:44
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_gateway_order")
@EqualsAndHashCode
public class PayGatewayOrder extends BaseDO<PayGatewayOrder> {
    private static final long serialVersionUID = -99340408483124019L;
    @TableId(value = "order_no", type = IdType.INPUT)
    private String orderNO;

    //订单详情
    @TableField("body")
    private String body;
    //停车场id
    @Trans(type = TransType.SIMPLE,target = ParkParking.class,fields = "parkName")
    @TableField("park_id")
    private Long parkId;
    //总金额-分
    @TableField("total_amount")
    private Integer totalAmount;
    //支付方式
    @Trans(type = "wordbook", key = "pay_type")
    @TableField("pay_type")
    private Integer payType;
    //扩展参数
    @TableField("attach")
    private String attach;
    //商品标签
    @TableField("goods_tag")
    private String goodsTag;
    //发起支付使用的商户id
    @TableField("mch_id")
    private Long mchId;
    //超时时间
    @TableField("out_time")
    private String outTime;
    //支付状态 0 未支付 1 已支付 2 已超时
    @Trans(type = "wordbook", key = "pay_status")
    @TableField("pay_status")
    private Integer payStatus;
    //0 没有退款 1 有退款
    @Trans(type = "wordbook", key = "is_refund")
    @TableField("is_refund")
    private Integer isRefund;
    //威富通商户id
    @TableField("swiftpass_mch_id")
    private String swiftpassMchId;
    //openid/支付宝 byuserid
    @TableField("open_id")
    private String openId;
    //是否对过账
    @TableField("is_reconciliation")
    private String isReconciliation;
    //对账日期
    @TableField("reconciliation_date")
    private String reconciliationDate;
    //结算金额
    @TableField("settlement_amount")
    private Double settlementAmount;
    //手续费金额
    @TableField("service_charge")
    private Double serviceCharge;
    //订单类型 0临停缴费 1 月卡物业费 2 月租费用 3路边停车缴费
    @Trans(type = "wordbook", key = "order_type")
    @TableField("order_type")
    private String orderType;
    //第三方收单机构订单号
    @TableField("pay_order_no")
    private String payOrderNo;

    /**
     * 支付信息
     */
    @TableField("pay_info")
    private String payInfo;

    /**
     * 支付时间
     */
    @TableField("pay_time")
    private String payTime;

    /**
     * 集团编码
     */
    @TableField("group_code")
    private String groupCode;


}
