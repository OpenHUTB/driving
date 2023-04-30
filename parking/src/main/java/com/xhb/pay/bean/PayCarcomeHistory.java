package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.*;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.Syncable;
import com.xhb.pay.service.PayCarcomeService;
import lombok.*;
import org.hibernate.validator.constraints.Length;
import org.springframework.beans.BeanUtils;

import javax.validation.constraints.NotNull;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_carcome_history")
@EqualsAndHashCode
@TransTypes(types = {"wordbook"})
public class PayCarcomeHistory extends BaseDO<PayCarcomeHistory> implements Syncable {
    private static final long serialVersionUID = -81558607196377853L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //所在车场
    @NotNull(message = "所在车场字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;


    //出入口id
    @NotNull(message = "出入口id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("port_id")
    private Long portId;

    //照片服务器保存查看id
    @Length(message = "照片厂端保存地址256", groups = {Add.class, Update.class}, max = 256)
    @TableField(exist = false)
    private String imgPath;

    //照片
    @Length(message = "照片字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField(exist = false)
    private String img;

    //车颜色
    @Length(message = "车颜色字段的长度最大为45", groups = {Add.class, Update.class}, max = 45)
    @TableField(exist = false)
    private String carColor;

    // 1:大车 2:中车 3:小车
    @TableField("car_type")
    @Trans(type = "wordbook", key = "car_type")
    private Integer carType;

    //服务器插入时间
    @Length(message = "服务器插入时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField(exist = false)
    private String syncTime;


    //车牌号码
    @Length(message = "车牌号码字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    //0 入库 1 已创建订单 2 已支付
    @NotNull(message = "0 入库 1 已创建订单 2 已支付字段不可为null", groups = {Update.class, Delete.class})
    @TableField("status")
    @Trans(type = Constant.WORD_BOOK, key = "car_status")
    private Integer status;

    //备注，修改车牌原因等
    @Length(message = "备注，修改车牌原因等字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField(exist = false)
    private String remark;

    //0未同步 1 已同步
    @NotNull(message = "0未同步 1 已同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //0 入场记录 1 出场记录
    @NotNull(message = "0 入场记录 1 出场记录字段不可为null", groups = {Update.class, Delete.class})
    @TableField("type")
    private Integer type;

    //0临时车 1月租车 2 免费车
    @NotNull(message = "记录类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("record_type")
    @Trans(type = "wordbook", key = "record_type")
    private Integer recordType;

    /**
     * 进场或者是离场时间
     */
    @TableField("access_time")
    private String accessTime;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //区域Id
    @TableField(exist = false)
    private Long regionId;

    //车位Id
    @TableField(exist = false)
    private Long roadLotId;

    @TableField("version")
    @Version
    private Integer version;

    @TableField(exist = false)
    private String portName;

    @TableField(exist = false)
    private String oldPlateNum;

    @TableField(exist = false)
    private Integer oldCarType;

    /**
     * 场中场多主体运营钱归谁
     */
    @TableField(exist = false)
    private Long receivingParkId;

    /**
     * 当做过滤条件的时候用
     * 在哪些port中找符合条件的出入场纪录
     * 本字段必须可以in的
     */
    @TableField(exist = false)
    private String portIds;

    @TableField(exist = false)
    private String likePlateNumber;

    @TableField("is_valid")
    private Integer isValid;

    public Integer getCarType() {
        if (this.parkId == null) {
            return null;
        }
        if (this.carType == null) {
            return PayCarcomeService.CAR_TYPE_LITTLE;
        }
        return this.carType;
    }

    @Override
    public Long getPrimaryVal() {
        return id;
    }

    @Override
    public String getCreateTime() {
        if (this.accessTime == null) {
            return null;
        }
        return this.accessTime;
    }

    /**
     * 当获取优惠活动，或者免费车，获取包月车辆的时候，使用这个parkid
     * 这个会优先取钱实际是哪个park就用哪个park
     *
     * @return parkid
     */
    public Long getRealParkId() {
        if (this.receivingParkId != null) {
            return this.receivingParkId;
        }
        return this.parkId;
    }

    //这里写死是因为用不到了
    public String getCarcolor() {
        if (this.id != null) {
            return "1";
        }
        return null;
    }

    /**
     * 转换为扩展表数据
     * @return
     */
    public PayCarcomeExt toExt(){
        PayCarcomeExt ext = new PayCarcomeExt();
        BeanUtils.copyProperties(this,ext);
        return ext;
    }

    /**
     * '进/出场时间（小时）'
     */
    @TableField(exist = false)
    private Integer accessTimeHour;
    /**
     * 进/出场时间（天）
     */
    @TableField(exist = false)
    private Integer accessTimeDay;
    /**
     * '进/出场时间（月）'
     */
    @TableField(exist = false)
    private Integer accessTimeMonth;
    /**
     * '进/出场时间（年）'
     */
    @TableField(exist = false)
    private Integer accessTimeYear;
    /**
     * '进/出场时间（年月）'
     */
    @TableField(exist = false)
    private Integer accessTimeDt;
    /**
     * '进/出场时间（年月）'
     */
    @TableField(exist = false)
    private Integer accessTimeDate;

}
