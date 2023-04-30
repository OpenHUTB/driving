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
 * 前段用户绑定车牌号(UcenterFrontUserBindPlate)实体类
 *
 * @author makejava
 * @since 2019-05-24 15:40:51
 */

@Data
@Builder
@TableName("t_ucenter_front_user_bind_plate")
public class UcenterFrontUserBindPlate extends BaseDO<UcenterFrontUserBindPlate> {
    private static final long serialVersionUID = -72616348311341984L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //前段用户id
    @NotEmpty
    @NotNull(message = "前段用户id字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "前段用户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("front_user_id")
    private String frontUserId;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;


    public UcenterFrontUserBindPlate() {
    }

    public UcenterFrontUserBindPlate(Long id, String frontUserId, String plateNumber) {
        this.id = id;
        this.frontUserId = frontUserId;
        this.plateNumber = plateNumber;
    }
}
