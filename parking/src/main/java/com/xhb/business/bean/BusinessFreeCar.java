package com.xhb.business.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.Syncable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 商户-免费停车车牌管理(BusinessFreeCar)实体类
 *
 * @author jackwong-wanglei
 * @since 2019-07-16 14:51:49
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_business_free_car")
@TransTypes(types = {"wordbook", "sysUser"})
public class BusinessFreeCar extends BaseDO<BusinessFreeCar> implements Syncable {
    private static final long serialVersionUID = -22649613185215360L;
    @TableId(value = "id", type = IdType.ID_WORKER)
    private Long id;

    //商户id
    @NotEmpty
    @NotNull(message = "商户id字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "商户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("merchant_id")
    private Long merchantId;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //营业员id
    @NotNull(message = "营业员id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("staff_id")
    private Long staffId;

    //集团编码
    @NotEmpty
    @NotNull(message = "集团编码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //开始时间
    @NotEmpty
    @NotNull(message = "开始时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "开始时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("start_time")
    private String startTime;

    //结束时间
    @NotEmpty
    @NotNull(message = "结束时间字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "结束时间字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("end_time")
    private String endTime;

    //备注
    @Length(message = "备注字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remarks")
    private String remarks;


    //车牌号
    @NotEmpty
    @NotNull(message = "车牌号字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车牌号字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("plate_number")
    private String plateNumber;


    @TableField("is_sync")
    @Trans(type = "wordbook", key = "yesOrNo")
    private Integer isSync;

    //营业员名称
    @TableField(exist = false)
    private String staffName;

    //修改人
    @TableField(exist = false)
    private String updateName;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
