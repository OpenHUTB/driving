package com.xhb.business.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
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
 * 现金券表(BusinessCashCoupon)实体类
 *
 * @author jackwong-wanglei
 * @since 2019-07-16 14:39:27
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_business_cash_coupon")
@TransTypes(types = {"wordbook"})
public class BusinessCashCoupon extends BaseDO<BusinessCashCoupon> implements Syncable {
    private static final long serialVersionUID = 291408599679948865L;

    @TableId(value = "id", type = IdType.ID_WORKER)
    private Long id;

    //商户id
    @NotNull(message = "商户id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("merchant_id")
    private Long merchantId;

    //金额
    @NotNull(message = "金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    //领券人front_user_id
    @Length(message = "领券人front_user_id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("front_user_id")
    private String frontUserId;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("plate_number")
    private String plateNumber;

    //领用时间
    @NotEmpty
    @NotNull(message = "领用时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "领用时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("receive_time")
    private String receiveTime;

    //使用时间
    @Length(message = "使用时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("use_time")
    private String useTime;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //集团编码
    @NotEmpty
    @NotNull(message = "集团编码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //创建人
    @NotEmpty
    @NotNull(message = "创建人字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "创建人字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("create_user")
    private String createUser;


    //昵称
    @Length(message = "昵称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("nick_name")
    private String nickName;

    //发放人id
    @Length(message = "发放人id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("staff_id")
    private Long staffId;

    //状态0 1已发放 2 已使用 3 已过期
    @NotNull(message = "状态0 已发放 1 已使用 2 已过期字段不可为null", groups = {Update.class, Delete.class})
    @TableField("status")
    @Trans(type = "wordbook", key = "coupon_status")
    private Integer status;

    //过期时间
    @NotEmpty
    @NotNull(message = "过期时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "过期时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("out_time")
    private String outTime;

    //入场记录id
    @Length(message = "入场记录id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("enter_id")
    private Long enterId;

    @TableField("is_sync")
    @Trans(type = "wordbook", key = "yesOrNo")
    private Integer isSync;

    //方法人名称
    @TableField(exist = false)
    private String staffName;

    //停车场名称
    @TableField(exist = false)
    private String parkName;

    //商户名称
    @TableField(exist = false)
    private String merchantName;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
