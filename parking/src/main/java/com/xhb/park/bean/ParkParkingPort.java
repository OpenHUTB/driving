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
 * 进出口管理(ParkParkingPort)实体类
 *
 * @author jackwong
 * @since 2019-03-13 20:22:11
 */

@Data
@Builder
@TableName("t_park_parking_port")
public class ParkParkingPort extends BaseDO<ParkParkingPort> implements Syncable {
    private static final long serialVersionUID = 742527678487829363L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //所在停车场
    @NotNull(message = "所在停车场字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //实际位置

    @Length(message = "实际位置字段的长度最大为64", groups = {Add.class, Update.class}, max = 64)
    @TableField("real_location")
    private String realLocation;

    @Length(message = "${column.comment}字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("port_type")
    private String portType;

    //进出口的IP地址:拍照摄像头ip
    @NotEmpty
    @NotNull(message = "拍照摄像头ip字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "进出口的IP地址:拍照摄像头ip字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("port_ip")
    private String portIp;

    //经度 进出口点的 以百度为准
    @Length(message = "经度 进出口点的 以百度为准字段的长度最大为50", groups = {Add.class, Update.class}, max = 50)
    @TableField("longitude")
    private String longitude;

    //纬度 进出口点的
    @Length(message = "纬度 进出口点的字段的长度最大为50", groups = {Add.class, Update.class}, max = 50)
    @TableField("latitude")
    private String latitude;

    //使用功能类别(0:停车场内;1:停车场入口;2:停车场出口)
    @NotEmpty
    @NotNull(message = "使用功能类别(0:停车场内;1:停车场入口;2:停车场出口)字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "使用功能类别(0:停车场内;1:停车场入口;2:停车场出口)字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("port_fun_type")
    private String portFunType;

    //出入口控制状态(0:正常;1:异常)
    @NotEmpty
    @NotNull(message = "出入口控制状态(0:正常;1:异常)字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "出入口控制状态(0:正常;1:异常)字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_disable")
    private String isDisable;

    //控制类型
    @Length(message = "控制类型字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("control_type")
    private String controlType;


    //描述
    @Length(message = "描述字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("description")
    private String description;


    //进出口名称
    @Length(message = "进出口名称字段的长度最大为100", groups = {Add.class, Update.class}, max = 100)
    @TableField("port_name")
    private String portName;

    //出入口图片
    @Length(message = "出入口图片字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("img")
    private String img;

    //(1-主闸机, 0-副闸机)来自于字典表
    @Length(message = "(1-主闸机, 0-副闸机)来自于字典表字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("is_main")
    private String isMain;

    //摄像头端口
    @Length(message = "摄像头端口字段的长度最大为10", groups = {Add.class, Update.class}, max = 10)
    @TableField("camera_port")
    private String cameraPort;

    //0 未下发 1 已下发
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //是否仅月租
    @TableField("is_only_monthly")
    private String isOnlyMonthly;

    /**
     * 是否必须收费才能过去
     */
    @TableField("is_mast_fee")
    private String isMastFee;

    /**
     * 扩展ip
     */
    @TableField("extends_ip")
    private String extendsIp;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }


    public ParkParkingPort() {
    }

    public ParkParkingPort(Long id, Long parkId, String realLocation, String portType, String portIp, String longitude, String latitude, String portFunType, String isDisable, String controlType, String description, String portName, String img, String isMain, String cameraPort, Integer isSync, String groupCode, String isOnlyMonthly, String isMastFee, String extendsIp) {
        this.id = id;
        this.parkId = parkId;
        this.realLocation = realLocation;
        this.portType = portType;
        this.portIp = portIp;
        this.longitude = longitude;
        this.latitude = latitude;
        this.portFunType = portFunType;
        this.isDisable = isDisable;
        this.controlType = controlType;
        this.description = description;
        this.portName = portName;
        this.img = img;
        this.isMain = isMain;
        this.cameraPort = cameraPort;
        this.isSync = isSync;
        this.groupCode = groupCode;
        this.isOnlyMonthly = isOnlyMonthly;
        this.isMastFee = isMastFee;
        this.extendsIp = extendsIp;
    }
}
