package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 月租用户收费规则表(ParkMonthlyRule)实体类
 *
 * @author jackwong
 * @since 2019-03-13 20:21:12
 */

@Data
@Builder
@TableName("t_park_monthly_rule")
public class ParkMonthlyRule extends BaseDO<ParkMonthlyRule> implements Syncable {
    private static final long serialVersionUID = -26620701430966454L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //规则名称
    @NotEmpty
    @NotNull(message = "规则名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "规则名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("rule_name")
    private String ruleName;

    //车场id
    @NotNull(message = "车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //开始时间
    @NotEmpty
    @NotNull(message = "开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_time")
    private String startTime;

    //结束时间
    @NotEmpty
    @NotNull(message = "结束时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "结束时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_time")
    private String endTime;

    //车型 0：轿车 1：大客车 2 ：卡车 3 ：其他
    @NotEmpty
    @NotNull(message = "车型 0：轿车 1：大客车 2 ：卡车 3 ：其他字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车型 0：轿车 1：大客车 2 ：卡车 3 ：其他字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("car_type")
    private String carType;

    //月租类型 类型:0:月全租  1：月白租 2：月晚租   类型:3:季全租  4：季白租 5：季晚租   类型:6：年全租  7：年白租 8：年晚租 9：免费用户
    @NotEmpty
    @NotNull(message = "月租类型 类型:0:月全租  1：月白租 2：月晚租   类型:3:季全租  4：季白租 5：季晚租   类型:6：年全租  7：年白租 8：年晚租 9：免费用户字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "月租类型 类型:0:月全租  1：月白租 2：月晚租   类型:3:季全租  4：季白租 5：季晚租   类型:6：年全租  7：年白租 8：年晚租 9：免费用户字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("monthly_type")
    private String monthlyType;

    //时段小时数
    @TableField("time_hours")
    private Integer timeHours;

    //时段收费金额
    @TableField("time_charge")
    private Double timeCharge;

    //状态:0:可用 1 ：禁用
    @NotEmpty
    @NotNull(message = "状态:0:可用 1 ：禁用字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "状态:0:可用 1 ：禁用字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_disable")
    private String isDisable;

    //规则描述
    @Length(message = "规则描述字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("description")
    private String description;


    //是否同步 0 未下发 1 已下发
    @NotNull(message = "是否同步 0 未下发 1 已下发字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //费用配置json
    @NotEmpty
    @NotNull(message = "费用配置json字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "费用配置json字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("lease_type_sett")
    private String leaseTypeSett;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //一个车位一个月物业费多少钱
    @TableField("property_fee")
    private Double propertyFee;

    //一个车位一个月停车费多少钱
    @TableField(exist = false)
    private Double monthlyFee;

    //最小包月时间
    @TableField("min_date")
    private String minDate;

    //最大包月时间
    @TableField("max_date")
    private String maxDate;

    //最小租赁月数
    @TableField("min_month")
    private String minMonth;

    //是否仅后台显示此规则
    @TableField("is_ms_only")
    private String isMsOnly;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    public ParkMonthlyRule() {
    }

    public ParkMonthlyRule(Long id, String ruleName, Long parkId, String startTime, String endTime, String carType, String monthlyType, Integer timeHours, Double timeCharge, String isDisable, String description, Integer isSync, String leaseTypeSett, String groupCode, Double propertyFee, Double monthlyFee, String minDate, String maxDate, String minMonth, String isMsOnly) {
        this.id = id;
        this.ruleName = ruleName;
        this.parkId = parkId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.carType = carType;
        this.monthlyType = monthlyType;
        this.timeHours = timeHours;
        this.timeCharge = timeCharge;
        this.isDisable = isDisable;
        this.description = description;
        this.isSync = isSync;
        this.leaseTypeSett = leaseTypeSett;
        this.groupCode = groupCode;
        this.propertyFee = propertyFee;
        this.monthlyFee = monthlyFee;
        this.minDate = minDate;
        this.maxDate = maxDate;
        this.minMonth = minMonth;
        this.isMsOnly = isMsOnly;
    }
}
