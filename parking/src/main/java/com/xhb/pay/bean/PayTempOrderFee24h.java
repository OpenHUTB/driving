package com.xhb.pay.bean;

import java.util.Date;
import java.io.Serializable;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.*;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.mybatis.jpa.annotation.*;
import com.fhs.core.group.*;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.*;

import lombok.*;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * (PayTempOrderFee24h)实体类
 *
 * @author makejava
 * @since 2019-06-28 15:28:16
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_temp_order_fee_24h")
public class PayTempOrderFee24h extends BaseDO<PayTempOrderFee24h> {
    private static final long serialVersionUID = -74821455138549513L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //临时车开始时间
    @Length(message = "临时车开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_time")
    private String startTime;

    //临时车结束时间
    @Length(message = "临时车结束时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_time")
    private String endTime;

    //多少个24小时
    @NotNull(message = "多少个24小时字段不可为null", groups = {Update.class, Delete.class})
    @TableField("one_24h_nums")
    private Integer one24hNums;

    //临时订单id
    @NotNull(message = "临时订单id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("temp_order_id")
    private Long tempOrderId;

    //总金额
    @NotNull(message = "总金额字段不可为null", groups = {Update.class, Delete.class})
    @TableField("total")
    private Double total;


    //月租前开始时间
    @Length(message = "月租前开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("monthly_first_start_time")
    private String monthlyFirstStartTime;

    //月租前结束时间
    @Length(message = "月租前结束时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("monthly_first_end_time")
    private String monthlyFirstEndTime;

    //月租后开始时间
    @Length(message = "月租后开始时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("monthly_second_start_time")
    private String monthlySecondStartTime;

    //月租后结束时间
    @TableField("monthly_second_end_time")
    private String monthlySecondEndTime;

    @TableField("one_24h_max_fee")
    private Double one24HMaxFee;


}
