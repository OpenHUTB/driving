package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.xhb.park.bean.Syncable;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 月租户充值记录表(PayMonthlyRecord)实体类
 *
 * @author makejava
 * @since 2019-04-03 18:41:12
 */

@Data
@Builder
@TableName("t_pay_monthly_record")
public class PayMonthlyRecord extends BaseDO<PayMonthlyRecord> implements Syncable {
    private static final long serialVersionUID = -93623463059570183L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //客户名称
    @NotEmpty
    @NotNull(message = "客户名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "客户名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("cus_name")
    private String cusName;

    //客户电话
    @NotEmpty
    @NotNull(message = "客户电话字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "客户电话字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("cus_mobile")
    private String cusMobile;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    //开始时间
    @NotEmpty
    @NotNull(message = "开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_date")
    private String startDate;

    //结束日期
    @NotEmpty
    @NotNull(message = "结束日期字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "结束日期字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_date")
    private String endDate;


    //停车场id
    @TableField("park_id")
    private Long parkId;

    //是否同步到车场
    @TableField("is_sync")
    private Integer isSync;

    //租赁类型
    @Length(message = "租赁类型字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("monthly_type")
    private String monthlyType;

    //交费金额
    @TableField("fee_amonth")
    private Double feeAmonth;

    //月租户类型
    @Length(message = "月租户类型字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("lease_type_id")
    private String leaseTypeId;

    //车辆类型
    @Length(message = "车辆类型字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("car_type")
    private String carType;

    @TableField("monthly_rule_id")
    private String monthlyRuleId;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;


    public PayMonthlyRecord() {
    }

    public PayMonthlyRecord(Long id, String cusName, String cusMobile, String plateNumber, String startDate, String endDate, Long parkId, Integer isSync, String monthlyType, Double feeAmonth, String leaseTypeId, String carType, String monthlyRuleId, String groupCode) {
        this.id = id;
        this.cusName = cusName;
        this.cusMobile = cusMobile;
        this.plateNumber = plateNumber;
        this.startDate = startDate;
        this.endDate = endDate;
        this.parkId = parkId;
        this.isSync = isSync;
        this.monthlyType = monthlyType;
        this.feeAmonth = feeAmonth;
        this.leaseTypeId = leaseTypeId;
        this.carType = carType;
        this.monthlyRuleId = monthlyRuleId;
        this.groupCode = groupCode;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
