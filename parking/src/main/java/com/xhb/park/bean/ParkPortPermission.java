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
 * (ParkPortPermission)实体类
 *
 * @author Jun
 * @since 2020-12-02 14:12:54
 */

@Data
@Builder
@TableName("t_park_port_permission")
public class ParkPortPermission extends BaseDO<ParkPortPermission> {
    private static final long serialVersionUID = -15972240607243025L;
    @TableId(value = "id", type = IdType.INPUT)
    private Integer id;

    //出入口ip
    @NotNull(message = "出入口ip字段不可为null", groups = {Update.class, Delete.class})
    @TableField("port_ip")
    private String portIp;

    //允许进出的月租户所属车场ids
    @NotEmpty
    @NotNull(message = "允许进出的月租户所属车场ids字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "允许进出的月租户所属车场ids字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("auth_park_ids")
    private String authParkIds;

    //不允许进入提示语音
    @Length(message = "不允许进入提示语音字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("tips")
    private String tips;


    public ParkPortPermission() {
    }

    public ParkPortPermission(Integer id, String portIp, String authParkIds, String tips) {
        this.id = id;
        this.portIp = portIp;
        this.authParkIds = authParkIds;
        this.tips = tips;
    }
}
