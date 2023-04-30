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

import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.validation.constraints.NotNull;

/**
 * (ParkParkingPortLed)实体类
 *
 * @author makejava
 * @since 2019-04-19 15:05:14
 */

@Data
@Builder
@TableName("t_park_parking_port_led")
public class ParkParkingPortLed extends BaseDO<ParkParkingPortLed> implements Syncable {
    private static final long serialVersionUID = -70589314512344529L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //所在出入口
    @TableField("port_id")
    private Long portId;

    //本LED屏最后一次接收数据的时间
    @Length(message = "本LED屏最后一次接收数据的时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("last_recv_time")
    private String lastRecvTime;

    //创建时间
    @Length(message = "创建时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("create_time")
    private String createTime;

    //更新时间
    @Length(message = "更新时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("update_time")
    private String updateTime;

    //创建人
    @Length(message = "创建人字段的长度最大为23", groups = {Add.class, Update.class}, max = 23)
    @TableField("create_user")
    private String createUser;

    //更新人
    @Length(message = "更新人字段的长度最大为23", groups = {Add.class, Update.class}, max = 23)
    @TableField("update_user")
    private String updateUser;

    //描述
    @Length(message = "描述字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("description")
    private String description;

    //状态：0启用；1：禁用
    @Length(message = "状态：0启用；1：禁用字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_disable")
    private Integer isDisable;

    //LED字体颜色
    @NotNull(message = "LED字体颜色字段不可为null", groups = {Update.class, Delete.class})
    @TableField("font_color_1")
    private Integer fontColor1;

    //LED字体颜色
    @NotNull(message = "LED字体颜色字段不可为null", groups = {Update.class, Delete.class})
    @TableField("font_color_2")
    private Integer fontColor2;

    //LED字体颜色
    @NotNull(message = "LED字体颜色字段不可为null", groups = {Update.class, Delete.class})
    @TableField("font_color_3")
    private Integer fontColor3;

    //LED字体颜色
    @NotNull(message = "LED字体颜色字段不可为null", groups = {Update.class, Delete.class})
    @TableField("font_color_4")
    private Integer fontColor4;

    //文字
    @Length(message = "文字字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("text_1")
    private String text1;

    //文字
    @Length(message = "文字字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("text_2")
    private String text2;

    //文字
    @Length(message = "文字字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("text_3")
    private String text3;

    //文字
    @Length(message = "文字字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("text_4")
    private String text4;

    //速度
    @NotNull(message = "速度字段不可为null", groups = {Update.class, Delete.class})
    @TableField("speed_1")
    private Integer speed1;

    //速度
    @NotNull(message = "速度字段不可为null", groups = {Update.class, Delete.class})
    @TableField("speed_2")
    private Integer speed2;

    //速度
    @NotNull(message = "速度字段不可为null", groups = {Update.class, Delete.class})
    @TableField("speed_3")
    private Integer speed3;

    //速度
    @NotNull(message = "速度字段不可为null", groups = {Update.class, Delete.class})
    @TableField("speed_4")
    private Integer speed4;

    //显示类型
    @NotNull(message = "显示类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("show_type_1")
    private Integer showType1;

    //显示类型
    @NotNull(message = "显示类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("show_type_2")
    private Integer showType2;

    //显示类型
    @NotNull(message = "显示类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("show_type_3")
    private Integer showType3;

    //显示类型
    @NotNull(message = "显示类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("show_type_4")
    private Integer showType4;

    //入场动画
    @NotNull(message = "入场动画字段不可为null", groups = {Update.class, Delete.class})
    @TableField("stunt_in_1")
    private Integer stuntIn1;

    //入场动画
    @NotNull(message = "入场动画字段不可为null", groups = {Update.class, Delete.class})
    @TableField("stunt_in_2")
    private Integer stuntIn2;

    //入场动画
    @NotNull(message = "入场动画字段不可为null", groups = {Update.class, Delete.class})
    @TableField("stunt_in_3")
    private Integer stuntIn3;

    //入场动画
    @NotNull(message = "入场动画字段不可为null", groups = {Update.class, Delete.class})
    @TableField("stunt_in_4")
    private Integer stuntIn4;

    //是否同步
    @TableField("is_sync")
    private Integer isSync;

    //出场动画
    @TableField("stunt_out_1")
    private Integer stuntOut1;

    //出场动画
    @TableField("stunt_out_2")
    private Integer stuntOut2;

    //出场动画
    @TableField("stunt_out_3")
    private Integer stuntOut3;

    //出场动画
    @TableField("stunt_out_4")
    private Integer stuntOut4;

    @TableField(exist = false)
    @OneToOne
    @JoinColumn(name = "port_id", referencedColumnName = "id")
    private ParkParkingPort port;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    @TableField("park_id")
    private Long parkId;

    public ParkParkingPortLed() {
    }

    public ParkParkingPortLed(Long id, Long portId, String lastRecvTime, String createTime, String updateTime, String createUser, String updateUser, String description, Integer isDisable, Integer fontColor1, Integer fontColor2, Integer fontColor3, Integer fontColor4, String text1, String text2, String text3, String text4, Integer speed1, Integer speed2, Integer speed3, Integer speed4, Integer showType1, Integer showType2, Integer showType3, Integer showType4, Integer stuntIn1, Integer stuntIn2, Integer stuntIn3, Integer stuntIn4, Integer isSync, Integer stuntOut1, Integer stuntOut2, Integer stuntOut3, Integer stuntOut4, ParkParkingPort port, String groupCode, Long parkId) {
        this.id = id;
        this.portId = portId;
        this.lastRecvTime = lastRecvTime;
        this.createTime = createTime;
        this.updateTime = updateTime;
        this.createUser = createUser;
        this.updateUser = updateUser;
        this.description = description;
        this.isDisable = isDisable;
        this.fontColor1 = fontColor1;
        this.fontColor2 = fontColor2;
        this.fontColor3 = fontColor3;
        this.fontColor4 = fontColor4;
        this.text1 = text1;
        this.text2 = text2;
        this.text3 = text3;
        this.text4 = text4;
        this.speed1 = speed1;
        this.speed2 = speed2;
        this.speed3 = speed3;
        this.speed4 = speed4;
        this.showType1 = showType1;
        this.showType2 = showType2;
        this.showType3 = showType3;
        this.showType4 = showType4;
        this.stuntIn1 = stuntIn1;
        this.stuntIn2 = stuntIn2;
        this.stuntIn3 = stuntIn3;
        this.stuntIn4 = stuntIn4;
        this.isSync = isSync;
        this.stuntOut1 = stuntOut1;
        this.stuntOut2 = stuntOut2;
        this.stuntOut3 = stuntOut3;
        this.stuntOut4 = stuntOut4;
        this.port = port;
        this.groupCode = groupCode;
        this.parkId = parkId;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
