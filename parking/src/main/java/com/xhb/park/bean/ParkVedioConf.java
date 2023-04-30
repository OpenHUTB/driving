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

import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

/**
 * (ParkVedioConf)实体类
 *
 * @author makejava
 * @since 2019-04-23 10:47:26
 */

@Data
@Builder
@TableName("t_park_vedio_conf")
public class ParkVedioConf extends BaseDO<ParkVedioConf> implements Syncable {
    private static final long serialVersionUID = -75604024367569186L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //token
    @Length(message = "token字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("token")
    private String token;

    //出入口id
    @Length(message = "出入口id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("port_id")
    private Long portId;

    //备注
    @Length(message = "备注字段的长度最大为500", groups = {Add.class, Update.class}, max = 500)
    @TableField("remark")
    private String remark;

    //0启用1禁用
    @TableField("is_disable")
    private Integer isDisable;

    //流类型
    @Length(message = "流类型字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("v_type")
    private String vType;

    //停车场id
    @TableField("park_id")
    private Long parkId;

    //是否同步过
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    @TableField(exist = false)
    @OneToOne
    @JoinColumn(name = "port_id", referencedColumnName = "id")
    private ParkParkingPort port;

    public ParkVedioConf() {
    }

    public ParkVedioConf(Long id, String token, Long portId, String remark, Integer isDisable, String vType, Long parkId, Integer isSync, String groupCode, ParkParkingPort port) {
        this.id = id;
        this.token = token;
        this.portId = portId;
        this.remark = remark;
        this.isDisable = isDisable;
        this.vType = vType;
        this.parkId = parkId;
        this.isSync = isSync;
        this.groupCode = groupCode;
        this.port = port;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
