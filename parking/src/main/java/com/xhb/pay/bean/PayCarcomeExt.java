package com.xhb.pay.bean;

import java.io.Serializable;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.*;
import com.baomidou.mybatisplus.annotation.*;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import com.mybatis.jpa.annotation.*;
import com.fhs.core.group.*;
import com.fhs.common.constant.Constant;
import com.fhs.core.base.bean.BaseDO;
import javax.validation.constraints.*;

import com.xhb.park.bean.Syncable;
import lombok.*;
import com.fhs.core.base.bean.BaseDO;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * 车辆入场记录扩展字段表(PayCarcomeExt)实体类
 *
 * @author wanglei
 * @since 2022-04-19 16:09:38
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_pay_carcome_ext")
public class PayCarcomeExt extends BaseDO<PayCarcomeExt> implements Syncable {
    private static final long serialVersionUID = -32394780357157702L;
    @TableId(value = "id", type = IdType.UUID)
    private Long id;

    //照片厂端保存路径
    @Length(message = "照片厂端保存路径字段的长度最大为256", groups = {Add.class, Update.class}, max = 256)
    @TableField("img_path")
    private String imgPath;

    //照片服务器保存查看id
    @Length(message = "照片服务器保存查看id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("img")
    private String img;

    //车颜色
    @Length(message = "车颜色字段的长度最大为45", groups = {Add.class, Update.class}, max = 45)
    @TableField("car_color")
    private String carColor;

    //备注，修改车牌原因等
    @Length(message = "备注，修改车牌原因等字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remark")
    private String remark;

    //0未同步 1 已同步
    @TableField("is_sync")
    private Integer isSync;

    //如果有人修改是哪个收费员修改的
    @TableField("update_collector_id")
    private Long updateCollectorId;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //区域id
    @TableField("region_id")
    private Long regionId;

    //车位id
    @TableField("road_lot_id")
    private Long roadLotId;

    //服务器插入时间
    @Length(message = "服务器插入时间字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("sync_time")
    private String syncTime;

    //所在车场
    @TableField("park_id")
    private Long parkId;

    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
