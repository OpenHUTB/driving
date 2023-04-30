package com.xhb.pay.dto;


import com.fhs.common.constant.Constant;
import com.thoughtworks.xstream.annotations.XStreamAlias;
import lombok.Data;

/**
 * 微信小程序，公众号支付表单
 * by jackwong
 */
@Data
@XStreamAlias("xml")
public class WXJsPayDTO extends BaseOrderSwiftpassDTO<WXJsPayDTO> {

    private String service = "pay.weixin.jspay";

    /**
     * 是否是原生js
     */
    @XStreamAlias("is_raw")
    private String isRaw = Constant.INT_TRUE + "";

    /**
     * 是否是小程序 1 为是 其他的为公众号支付
     */
    @XStreamAlias("is_minipg")
    private String isMinipg;
    /**
     * 订单号
     */
    @XStreamAlias("out_trade_no")
    private String outTradeNo;
    /**
     * 终端号 可以为空
     */
    @XStreamAlias("device_info")
    private String deviceInfo;
    /**
     * 操作员id 可以为空
     */
    @XStreamAlias("op_user_id")
    private String opUserId;
    /**
     * 商铺id 可以为空
     */
    @XStreamAlias("op_shop_id")
    private String opShopId;


    /**
     * 商品描述
     */

    private String body;

    /**
     * 公众号openid 测试的时候可以不填写
     */
    @XStreamAlias("sub_openid")
    private String subOpenid;

    /**
     * 公众号 appid 测试的时候可以不填写
     */
    @XStreamAlias("sub_appid")
    private String subAppid;


    /**
     * 商户附加信息，可做扩展参数 可以为空
     */

    private String attach;

    /**
     * 总金额 分为单位
     */
    @XStreamAlias("total_fee")
    private Integer totalFee;

    /**
     * 是否需要开发票
     */
    @XStreamAlias("need_receipt")
    private Boolean needReceipt;

    /**
     * 生成订单的机器ip
     */
    @XStreamAlias("mch_create_ip")
    private String mchCreateIp;

    /**
     * 平台接收回调的url
     */
    @XStreamAlias("notify_url")
    private String notifyUrl;

    /**
     * 订单生成时间 yyyyMMddHHmmss 可以不填写
     */
    @XStreamAlias("time_start")
    private String timeStart;

    /**
     * 订单过期时间 yyyyMMddHHmmss 可以不填写
     */
    @XStreamAlias("time_expire")
    private String timeExpire;

    /**
     * 商品标记 可以不填写
     */
    @XStreamAlias("goods_tag")
    private String goodsTag;


    /**
     * 是否限制信用卡 可以不传 传1 为不能使用信用卡付费
     */
    @XStreamAlias("limit_credit_pay")
    private String limitCreditPay;

}
