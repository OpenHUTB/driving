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
 * 临时用户收费规则表(ParkTempRule)实体类
 *
 * @author jackwong
 * @since 2019-03-13 20:23:54
 */
@Data
@Builder
@TableName("t_park_temp_rule")
public class ParkTempRule extends BaseDO<ParkTempRule> implements Syncable {
    private static final long serialVersionUID = 298102401090910604L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //规则名称
    @NotEmpty
    @NotNull(message = "规则名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "规则名称字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("rule_name")
    private String ruleName;

    //车场编码
    @NotNull(message = "车场编码字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //白天开始时间 HH:mm
    @Length(message = "开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_time")
    private String startTime;

    //白天结束时间 HH:mm
    @Length(message = "结束时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_time")
    private String endTime;

    //单价
    @TableField("price")
    private Double price;

    //车型 0：轿车 1：大客车 2 ：卡车 3 ：其他
    @NotEmpty
    @NotNull(message = "车型 0：轿车 1：大客车 2 ：卡车 3 ：其他字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车型 0：轿车 1：大客车 2 ：卡车 3 ：其他字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("car_type")
    private String carType;

    //规则描述
    @Length(message = "规则描述字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("description")
    private String description;

    //0:临时用户 1：app用户
    @Length(message = "0:临时用户 1：app用户字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("user_type")
    private String userType;

    //星期数据 用|隔开
    @Length(message = "星期数据 用|隔开字段的长度最大为256", groups = {Add.class, Update.class}, max = 256)
    @TableField("week_data")
    private String weekData;

    //计费类型目前四种(0:整天规则 1：白天+晚上 2：普通整天+休息整天 3：白天+晚上+休息白天+休息晚上 4: 包时段规则)
    @Length(message = "计费类型目前四种(0:整天规则 1：白天+晚上 2：普通整天+休息整天 3：白天+晚上+休息白天+休息晚上)字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("charge_type")
    private String chargeType;

    //普通整天单价
    @TableField("all_day_charge")
    private Double allDayCharge;

    //休息天整天单价
    @TableField("day_rest_charge")
    private Double dayRestCharge;

    //白天单价
    @TableField("day_charge")
    private Double dayCharge;

    //晚上单价
    @TableField("night_charge")
    private Double nightCharge;

    //是否已下发
    @TableField("is_sync")
    private Integer isSync;

    //是否禁用
    @Length(message = "是否禁用字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_disable")
    private String isDisable;

    /**
     * 休息日白天收费单价
     */
    @TableField("rest_day_charge")
    private Double restDayCharge;

    /**
     * 休息日晚上收费单价
     */
    @TableField("rest_night_charge")
    private Double restNightCharge;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //时段小时数
    @TableField("time_hours")
    private Integer timeHours;

    //时段收费金额
    @TableField("time_charge")
    private Double timeCharge;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }

    public ParkTempRule() {
    }

    public ParkTempRule(Long id, String ruleName, Long parkId, String startTime, String endTime, Double price, String carType, String description, String userType, String weekData, String chargeType, Double allDayCharge, Double dayRestCharge, Double dayCharge, Double nightCharge, Integer isSync, String isDisable, Double restDayCharge, Double restNightCharge, String groupCode, Integer timeHours, Double timeCharge) {
        this.id = id;
        this.ruleName = ruleName;
        this.parkId = parkId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.carType = carType;
        this.description = description;
        this.userType = userType;
        this.weekData = weekData;
        this.chargeType = chargeType;
        this.allDayCharge = allDayCharge;
        this.dayRestCharge = dayRestCharge;
        this.dayCharge = dayCharge;
        this.nightCharge = nightCharge;
        this.isSync = isSync;
        this.isDisable = isDisable;
        this.restDayCharge = restDayCharge;
        this.restNightCharge = restNightCharge;
        this.groupCode = groupCode;
        this.timeHours = timeHours;
        this.timeCharge = timeCharge;
    }
}
