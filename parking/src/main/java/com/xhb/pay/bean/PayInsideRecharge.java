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
 * 充值记录表(PayInsideRecharge)实体类
 *
 * @author makejava
 * @since 2019-05-22 17:59:34
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_inside_recharge")
@TransTypes(types = {"wordbook", Constant.USER_INFO, "pagex"})
public class PayInsideRecharge extends BaseDO<PayInsideRecharge> implements Syncable {
    private static final long serialVersionUID = -93047282092878671L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //充值金额
    @NotNull(message = "充值金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    //赠送金额
    @TableField("give_amount")
    private Double giveAmount;

    //备注
    @Length(message = "备注字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("remark")
    private String remark;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @TableField("is_sync")
    @Trans(type = Constant.WORD_BOOK, key = "is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //是否是月租户充值
    @NotNull(message = "是否是月租户充值字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_contract")
    @Trans(type = Constant.WORD_BOOK, key = "yesOrNo")
    private Integer isContract;

    //内部车id
    @NotNull(message = "内部车id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("inside_id")
    private Long insideId;

    //1 后台系统 2 公众号/支付宝 3 APP 4 小程序 5 收费员收取现金
    @NotNull(message = "1 后台系统 2 公众号/支付宝 3 APP 4 小程序字段不可为null", groups = {Update.class, Delete.class})
    @TableField("from_type")
    @Trans(type = Constant.WORD_BOOK, key = "from_type")
    private Integer fromType;

    //收费员id(路边停车)
    @TableField("collector_id")
    @Trans(type = "pagex", key = "ucenter_toll_collector")
    private Long collectorId;

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
