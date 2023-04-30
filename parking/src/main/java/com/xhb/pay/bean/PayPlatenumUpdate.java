package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 修改车牌号表(PayPlatenumUpdate)实体类
 *
 * @author makeliujun
 * @since 2019-10-08 17:44:37
 */

@Data
@Builder

@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_platenum_update")
public class PayPlatenumUpdate extends BaseDO<PayPlatenumUpdate> {
    private static final long serialVersionUID = -36000725849212324L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //出入场记录id
    @TableField("carcome_id")
    private Long carcomeId;

    //旧车牌号码
    @Length(message = "旧车牌号码字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("old_plate_num")
    private String oldPlateNum;

    //新车牌号码
    @Length(message = "新车牌号码字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("new_plate_num")
    private String newPlateNum;

    //收费员id
    @TableField("collector_id")
    private Long collectorId;

    //备注，修改车牌原因等
    @Length(message = "备注，修改车牌原因等字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remark")
    private String remark;

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

    /**
     * 旧的车辆信息
     */
    @TableField("old_car_type")
    @Trans(type = "wordbook", key = "car_type")
    private Integer oldCarType;

    /**
     * 新的车辆信息
     */
    @TableField("car_type")
    @Trans(type = "wordbook", key = "car_type")
    private Integer carType;


}
