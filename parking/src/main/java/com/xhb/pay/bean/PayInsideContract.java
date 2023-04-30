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
 * 内部车承包时间段表(PayInsideContract)实体类
 *
 * @author makejava
 * @since 2019-05-22 17:53:07
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_inside_contract")
@TransTypes(types = {"wordbook", Constant.USER_INFO, "pagex"})
public class PayInsideContract extends BaseDO<PayInsideContract> implements Syncable {
    private static final long serialVersionUID = 513378389351769816L;
    @TableId(value = "id", type = IdType.NONE)
    private Long id;

    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    @NotEmpty
    @NotNull(message = "开始时间字段不可为null", groups = {Update.class, Delete.class})
    @TableField("start_date")
    private String startDate;

    @NotEmpty
    @NotNull(message = "结束时间字段不可为null", groups = {Update.class, Delete.class})
    @TableField("end_date")
    private String endDate;

    //0 按月充 1 按天充
    @NotEmpty
    @NotNull(message = "0 按月充 1 按天充字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_by_month")
    private String isByMonth;

    @NotNull(message = "价格字段不可为null", groups = {Update.class, Delete.class})
    @TableField("amount")
    private Double amount;

    //租赁月数-自己填写(默认年12，季3，月1)
    @TableField("lease_month_num")
    private Double leaseMonthNum;

    //是否同步
    @NotNull(message = "是否同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //赠送月数
    @TableField("give_month_mum")
    private Integer giveMonthMum;

    //赠送天数
    @TableField("give_day_num")
    private Integer giveDayNum;

    //1 后台系统 2 公众号/支付宝 3 APP 4 小程序 5 收费员收取现金
    @NotNull(message = "1 后台系统 2 公众号/支付宝 3 APP 4 小程序字段不可为null", groups = {Update.class, Delete.class})
    @TableField("from_type")
    private Integer fromType;

    //集团编码
    @NotEmpty
    @NotNull(message = "集团编码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //内部车id
    @NotNull(message = "内部车id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("inside_id")
    private Long insideId;

    //备注
    @Length(message = "备注字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remark")
    private String remark;

    //是否提醒过缴费
    @TableField("is_notice")
    private Integer isNotice;

    //收费规则id
    @TableField("rule_id")
    private Long ruleId;

    //车位数
    @TableField("lot_num")
    private Integer lotNum;

    //收费员id(路边停车)
    @TableField("collector_id")
    @Trans(type = "pagex", key = "ucenter_toll_collector")
    private String collectorId;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
