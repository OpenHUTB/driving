package com.xhb.pay.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.park.bean.Syncable;
import com.xhb.park.bean.UcenterTollCollector;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 手动抬杆(PayHandLiftRod)实体类
 *
 * @author makejava
 * @since 2019-06-10 11:56:32
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_pay_hand_lift_rod")
public class PayHandLiftRod extends BaseDO<PayHandLiftRod> implements Syncable {
    private static final long serialVersionUID = 600681155028586201L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    @Trans(type = TransType.SIMPLE,target = ParkParking.class,fields = "parkName")
    private Long parkId;

    //出入口id
    @Length(message = "出入口id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("port_id")
    @Trans(type = TransType.SIMPLE,target = ParkParkingPort.class,fields = "portName")
    private Long portId;

    //收费员id
    @NotNull(message = "收费员id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("collector_id")
    @Trans(type = TransType.SIMPLE,target = UcenterTollCollector.class,fields = "name",alias = "user")
    private Long collectorId;

    //手动抬杆原因
    @NotEmpty
    @NotNull(message = "手动抬杆原因字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "手动抬杆原因字段的长度最大为500", groups = {Add.class, Update.class}, max = 500)
    @TableField("remark")
    private String remark;

    //是否已经同步
    @NotNull(message = "是否已经同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //集团编码
    @NotEmpty
    @NotNull(message = "集团编码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    @TableField("cash_pay")
    private Double cashPay;

    //车牌号
    @Length(message = "车牌号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("plate_number")
    private String plateNumber;

    @TableField("img_path")
    private String imgPath;

    @Length(message = "照片字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("img_id")
    private String imgId;



    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
