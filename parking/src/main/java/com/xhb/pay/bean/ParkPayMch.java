package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.mybatis.jpa.annotation.Like;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * (ParkPayMch)实体类
 *
 * @author makejava
 * @since 2019-05-14 16:53:12
 */

@Data
@Builder
@TableName("t_pay_mch")
public class ParkPayMch extends BaseDO<ParkPayMch> {
    private static final long serialVersionUID = 205916847885150927L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //1 微信公众号  2 支付宝服务窗 3小程序 支付 4 微信APP支付 5 支付宝APP支付
    @NotNull(message = "1 微信公众号  2 支付宝服务窗 3小程序 支付 4 微信APP支付 5 支付宝APP支付字段不可为null", groups = {Update.class, Delete.class})
    @TableField("mch_type")
    private Integer mchType;

    //威富通商户id
    @NotEmpty
    @NotNull(message = "威富通商户id字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "威富通商户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("swiftpass_mch_id")
    private String swiftpassMchId;

    //关联停车场
    @Length(message = "关联停车场字段的长度最大为-1", groups = {Add.class, Update.class}, max = -1)
    @TableField("park_ids")
    @Like
    private String parkIds;

    //商户密钥
    @NotEmpty
    @NotNull(message = "商户密钥字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "商户密钥字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("mch_secret")
    private String mchSecret;

    //商户名称
    @NotEmpty
    @NotNull(message = "商户名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "商户名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("mch_name")
    private String mchName;


    //公钥
    @Length(message = "公钥字段的长度最大为-1", groups = {Add.class, Update.class}, max = -1)
    @TableField("public_key")
    private String publicKey;

    //密钥
    @Length(message = "密钥字段的长度最大为-1", groups = {Add.class, Update.class}, max = -1)
    @TableField("private_key")
    private String privateKey;

    //加密方式RSA_1_256/MD5
    @Length(message = "加密方式RSA_1_256/MD5字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("sign_type")
    private String signType;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    /**
     * 收款方类型 0 停车费收款 1 物业费收款 2 路边停车预交费
     */
    @TableField("payee_type")
    private Integer payeeType;

    /**
     * 公众号appid
     */
    @TableField("mp_app_id")
    private String mpAppId;

    /**
     * 支付渠道
     */
    @TableField("passageway_type")
    private Integer passagewayType;

    public ParkPayMch() {
    }

    public ParkPayMch(Long id, Integer mchType, String swiftpassMchId, String parkIds, String mchSecret, String mchName, String publicKey, String privateKey, String signType, String groupCode, Integer payeeType, String mpAppId, Integer passagewayType) {
        this.id = id;
        this.mchType = mchType;
        this.swiftpassMchId = swiftpassMchId;
        this.parkIds = parkIds;
        this.mchSecret = mchSecret;
        this.mchName = mchName;
        this.publicKey = publicKey;
        this.privateKey = privateKey;
        this.signType = signType;
        this.groupCode = groupCode;
        this.payeeType = payeeType;
        this.mpAppId = mpAppId;
        this.passagewayType = passagewayType;
    }
}
