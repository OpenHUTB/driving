package com.xhb.pay.vo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fhs.core.base.bean.SuperBean;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

/**
 * @Author: 陈志虎
 * @Description: TODO
 * @DateTime: 2022/4/22 10:15
 **/

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TransTypes(types = {"pagex", "wordbook"})
public class VehicleEntryVo extends SuperBean<VehicleEntryVo> {

    @ApiModelProperty("id")
    private Long id;

    //所在车场
    @ApiModelProperty("所在停车场")
    private Long parkId;

    @ApiModelProperty("车辆类型")
    @Trans(type = "wordbook", key = "record_type")
    private Integer recordType;

    @ApiModelProperty("入场记录id")
    private Long enterId;


    @ApiModelProperty("出/入场时间")
    private String accessTime;

    @ApiModelProperty("预留手机号码状态,如果为true：则代表已经手机号码，false：则代表没有手机号码")
    private boolean mobileStatus;

    @ApiModelProperty("当前车牌号欠费数量")
    private String parkArrearsCount;

    @ApiModelProperty("当前车牌欠费总金额")
    private String parkArrearsMoney;

    @ApiModelProperty("当前车牌号在本停车场的欠费单数量")
    private String localPrakArrearsCount;

    @ApiModelProperty("当前车牌号在本停车场的欠费总金额")
    private String localPrakArrearsMoeney;

}
