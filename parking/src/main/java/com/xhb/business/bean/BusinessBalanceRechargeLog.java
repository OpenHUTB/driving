package com.xhb.business.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.Syncable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

/**
 * 商户余额充值记录表(t_business_balance_recharge_log)实体类
 *
 * @author makejava
 * @since 2019-05-22 17:59:34
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_business_balance_recharge_log")
@TransTypes(types = {"wordbook", Constant.USER_INFO})
public class BusinessBalanceRechargeLog extends BaseDO<BusinessBalanceRechargeLog> implements Syncable {
    private static final long serialVersionUID = -93047282092878671L;
    @TableId(value = "id", type = IdType.ID_WORKER)
    private Long id;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //商户id
    @TableField("merchant_id")
    private Long merchantId;

    //充值金额
    @NotNull(message = "充值金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("recharge_money")
    private Double rechargeMoney;


    //赠送金额
    @TableField("give_money")
    private Double giveMoney;

    //商户余额
    @TableField(exist = false)
    private Double balance;

    @TableField("is_sync")
    private Integer isSync;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
