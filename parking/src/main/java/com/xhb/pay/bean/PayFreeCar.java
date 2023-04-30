package com.xhb.pay.bean;

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
 * 免费车配置(PayFreeCar)实体类
 *
 * @author jackwong
 * @since 2019-03-29 12:10:51
 */

@Data
@Builder
@TableName("t_pay_free_car")
public class PayFreeCar extends BaseDO<PayFreeCar> implements Syncable {
    private static final long serialVersionUID = -35520860312195994L;

    @NotNull(message = "${column.comment}字段不可为null", groups = {Update.class, Delete.class})
    @TableId("id")
    private Long id;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("plate_number")
    private String plateNumber;

    //0什么开头的 1 什么结尾的
    @NotEmpty
    @NotNull(message = "0什么开头的 1 什么结尾的字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "0什么开头的 1 什么结尾的字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("free_type")
    private String freeType;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //备注
    @Length(message = "备注字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remark")
    private String remark;

    //0 未同步 1已同步
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    public PayFreeCar() {
    }

    public PayFreeCar(Long id, String plateNumber, String freeType, Long parkId, String remark, Integer isSync, String groupCode) {
        this.id = id;
        this.plateNumber = plateNumber;
        this.freeType = freeType;
        this.parkId = parkId;
        this.remark = remark;
        this.isSync = isSync;
        this.groupCode = groupCode;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
