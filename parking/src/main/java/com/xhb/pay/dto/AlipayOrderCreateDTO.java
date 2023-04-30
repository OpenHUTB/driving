package com.xhb.pay.dto;


import com.fasterxml.jackson.annotation.JsonInclude;
import com.fhs.core.base.bean.BaseObject;

import lombok.Data;
import org.beetl.core.misc.NumberUtil;
import org.springframework.util.NumberUtils;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;

/**
 * 支付宝官方创建订单DTO
 * by jackwong wanglei
 */
@Data
public class AlipayOrderCreateDTO extends BaseObject<AlipayOrderCreateDTO> {
    //	订单标题
    private String subject;
    //商户操作员编号
    private String operator_id;
    //商户门店编号
    private String alipay_store_id;
    //对交易或商品的描述
    private String body;

    private String buyer_id;
    private String product_code;
    //商户订单号
    private String merchant_order_no;
    //该笔订单允许的最晚付款时间，逾期将关闭交易。
    private String timeout_express;
    //禁用渠道，用户不可用指定渠道支付
    private String disable_pay_channels;
    //卖家支付宝用户ID
    private String seller_id;
    //商户机具终端编号
    private String terminal_id;
    private String store_id;
    private String enable_pay_channels;
    //可打折金额
    private double discountable_amount;
    //订单号
    private String out_trade_no;
    //订单总金额，单位为元，精确到小数点后两位
    private String total_amount;

    private String buyer_logon_id;
    //不可打折金额
    private int undiscountable_amount;
}