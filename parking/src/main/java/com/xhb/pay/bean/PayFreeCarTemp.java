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
 * 临时免费车(PayFreeCarTemp)实体类
 *
 * @author jackwong
 * @since 2019-03-29 12:49:45
 */

@Data
@Builder
@TableName("t_pay_free_car_temp")
public class PayFreeCarTemp extends BaseDO<PayFreeCarTemp> implements Syncable, Discountable {
    private static final long serialVersionUID = -24680098704618419L;

    //id
    @NotNull(message = "id字段不可为null", groups = {Update.class, Delete.class})
    @TableId("id")
    private Long id;

    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;

    //开始时间-到时分
    @NotEmpty
    @NotNull(message = "开始时间-到时分字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "开始时间-到时分字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_time")
    private String startTime;

    //结束时间-到时分
    @NotEmpty
    @NotNull(message = "结束时间-到时分字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "结束时间-到时分字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_time")
    private String endTime;

    //备注
    @NotEmpty
    @NotNull(message = "备注字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "备注字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("remark")
    private String remark;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    /**
     * 打几折 10代表1折 100代表 10折
     */
    @TableField("radio")
    private Integer radio;

    /**
     * 是否已经下发
     */
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    public PayFreeCarTemp() {
    }

    public PayFreeCarTemp(Long id, String plateNumber, String startTime, String endTime, String remark, Long parkId, Integer radio, Integer isSync, String groupCode) {
        this.id = id;
        this.plateNumber = plateNumber;
        this.startTime = startTime;
        this.endTime = endTime;
        this.remark = remark;
        this.parkId = parkId;
        this.radio = radio;
        this.isSync = isSync;
        this.groupCode = groupCode;
    }

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
