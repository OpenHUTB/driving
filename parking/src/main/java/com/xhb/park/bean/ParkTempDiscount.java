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
 * 临时优惠规则(ParkTempDiscount)实体类
 *
 * @author make Jun
 * @since 2020-03-18 15:27:09
 */

@Data
@Builder
@TableName("t_park_temp_discount")
public class ParkTempDiscount extends BaseDO<ParkTempDiscount> implements Syncable {
    private static final long serialVersionUID = 396732662812525811L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //优惠名称
    @NotEmpty
    @NotNull(message = "优惠名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "优惠名称字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("discount_name")
    private String discountName;

    //生效时间
    @NotEmpty
    @NotNull(message = "生效时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "生效时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("start_date")
    private String startDate;

    //失效时间
    @NotEmpty
    @NotNull(message = "失效时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "失效时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("end_date")
    private String endDate;

    //车辆类型
    @NotNull(message = "车辆类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("car_type")
    private Integer carType;

    //匹配规则
    @NotEmpty
    @NotNull(message = "匹配规则字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "匹配规则字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("match_rule")
    private String matchRule;

    //匹配正则
    @NotEmpty
    @NotNull(message = "匹配正则字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "匹配正则字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("match_regular")
    private String matchRegular;

    //测试车牌号
    @Length(message = "测试车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("test_plate_num")
    private String testPlateNum;

    //优惠金额
    @NotNull(message = "优惠金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("discount_amount")
    private Double discountAmount;

    //是否启用
    @NotEmpty
    @NotNull(message = "是否启用字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "是否启用字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_disable")
    private Integer isDisable;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //状态:0:未下发 1 ：已下发
    @NotNull(message = "状态:0:未下发 1 ：已下发字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    public ParkTempDiscount() {
    }

    public ParkTempDiscount(Long id, Long parkId, String discountName, String startDate, String endDate, Integer carType, String matchRule, String matchRegular, String testPlateNum, Double discountAmount, Integer isDisable, String groupCode, Integer isSync) {
        this.id = id;
        this.parkId = parkId;
        this.discountName = discountName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.carType = carType;
        this.matchRule = matchRule;
        this.matchRegular = matchRegular;
        this.testPlateNum = testPlateNum;
        this.discountAmount = discountAmount;
        this.isDisable = isDisable;
        this.groupCode = groupCode;
        this.isSync = isSync;
    }

    @Override
    public void setIsSync(Integer isSync) {
        this.isSync = isSync;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
