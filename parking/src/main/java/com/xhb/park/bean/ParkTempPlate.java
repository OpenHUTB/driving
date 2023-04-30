package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import lombok.Builder;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

/**
 * 临时牌照生成表(ParkTempPlate)实体类
 *
 * @author makelj
 * @since 2019-06-18 10:47:28
 */

@Data
@Builder
@TableName("t_park_temp_plate")
public class ParkTempPlate extends BaseDO<ParkTempPlate> {
    private static final long serialVersionUID = -94576660907784927L;
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @Length(message = "${column.comment}字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("front_user_id")
    private String frontUserId;

    //临时车牌号
    @Length(message = "临时车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_num")
    private String plateNum;


    public ParkTempPlate() {
    }

    public ParkTempPlate(Integer id, String frontUserId, String plateNum) {
        this.id = id;
        this.frontUserId = frontUserId;
        this.plateNum = plateNum;
    }
}