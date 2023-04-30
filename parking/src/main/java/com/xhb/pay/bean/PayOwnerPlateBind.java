package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * pojo
 * @Author: 陈志虎
 * @Description: TODO
 * @DateTime: 2022/4/22 13:35
 **/
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_owner_plate_bind")
public class PayOwnerPlateBind extends BaseDO<PayOwnerPlateBind> {

    private static final long serialVersionUID = -36000725849212529L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    @TableField("name")
    private String name;

    @TableField("car_type")
    @Trans(type = "wordbook", key = "car_type")
    private Integer carType;


    @TableField("mobile")
    private String mobile;


    @TableField("plate_number")
    private String plateNumber;


    @TableField("front_user_id")
    private String frontUserId;


    @TableField("img")
    private String img;

    @TableField("data_source_type")
    private Integer dataSourceType;


    @TableField("collector_id")
    private Long collectorId;

    @TableField("create_date")
    private Integer createDate;

}
