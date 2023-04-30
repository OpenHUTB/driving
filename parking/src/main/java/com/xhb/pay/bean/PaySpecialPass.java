package com.xhb.pay.bean;

import java.io.Serializable;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.*;

import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.mybatis.jpa.annotation.*;
import com.fhs.core.group.*;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.*;

import com.xhb.park.bean.Syncable;
import lombok.*;
import com.fhs.core.base.bean.BaseDO;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * 特殊放行纪录(PaySpecialPass)实体类
 *
 * @author makejava
 * @since 2019-05-13 15:15:35
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TransTypes(types = {"wordbook"})
@TableName("t_pay_special_pass")
public class PaySpecialPass extends BaseDO<PaySpecialPass> implements Syncable {
    private static final long serialVersionUID = 259336222914640808L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //是否已经同步
    @NotNull(message = "是否已经同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    @Trans(type = "wordbook", key = "is_sync")
    private Integer isSync;

    //收费员id
    @NotNull(message = "收费员id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("collector_id")
    private Long collectorId;


    //入场纪录id
    @TableField("enter_id")
    private Long enterId;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    //异常抬杆原因
    @NotEmpty
    @NotNull(message = "异常抬杆原因字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "异常抬杆原因字段的长度最大为500", groups = {Add.class, Update.class}, max = 500)
    @TableField("remark")
    private String remark;

    //停车时长(分钟数)
    @TableField("park_time")
    private Integer parkTime;


    //出场纪录id
    @TableField("out_id")
    private Long outId;

    //出口id
    @TableField("out_port_id")
    private Long outPortId;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    /**
     * 放行原因分类
     */
    @TableField("type")
    private Long type;

    /**
     * 临时订单id
     */
    @TableField("temp_order_id")
    private Long tempOrderId;

    /**
     * 特殊放行损失金额
     */
    @TableField("loss_amount")
    private Double lossAmount;

    @TableField("img_id")
    private String imgId;

    @TableField("img_path")
    private String imgPath;
    /**
     * '创建时期（yyyyMMdd）'
     */
    @TableField("create_date")
    private Integer createDate;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
