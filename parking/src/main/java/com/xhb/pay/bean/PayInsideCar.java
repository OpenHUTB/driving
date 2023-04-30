package com.xhb.pay.bean;

import com.alibaba.fastjson.annotation.JSONField;
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
 * 内部车管理(PayInsideCar)实体类
 *
 * @author makejava
 * @since 2019-05-22 10:12:37
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TransTypes(types = {"wordbook"})
@TableName("t_pay_inside_car")
public class PayInsideCar extends BaseDO<PayInsideCar> implements Syncable {
    private static final long serialVersionUID = 741751734158531972L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //内部名称
    @NotEmpty
    @NotNull(message = "内部名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "内部名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("inside_name")
    private String insideName;

    //一级分类
    @Length(message = "一级分类字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("first_type")
    private String firstType;

    //二级分类
    @Length(message = "二级分类字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("second_type")
    private String secondType;

    //三级分类
    @Length(message = "三级分类字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("three_type")
    private String threeType;

    //车主名称
    @NotEmpty
    @NotNull(message = "车主名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车主名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("owner_name")
    private String ownerName;

    //车主电话
    @NotEmpty
    @NotNull(message = "车主电话字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "车主电话字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("owner_mobile")
    private String ownerMobile;

    //房间号
    @Length(message = "房间号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("room_num")
    private String roomNum;

    //区域名称
    @Length(message = "区域名称字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("region_id")
    private String regionId;

    //占用车位数
    @NotNull(message = "占用车位数字段不可为null", groups = {Update.class, Delete.class})
    @TableField("lot_num")
    private Integer lotNum;

    //内部类型
    @NotNull(message = "内部类型字段不可为null", groups = {Update.class, Delete.class})
    @TableField("lease_type_id")
    private Long leaseTypeId;

    //余额
    @TableField("balance")
    private Double balance;

    //次数
    @TableField("time_number")
    private Integer timeNumber;

    //开始日期
    @NotEmpty
    @NotNull(message = "开始日期字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "开始日期字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("start_date")
    private String startDate;

    //结束日期
    @NotEmpty
    @NotNull(message = "结束日期字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "结束日期字段的长度最大为20", groups = {Add.class, Update.class}, max = 20)
    @TableField("end_date")
    private String endDate;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;

    //是否同步
    @NotNull(message = "是否同步字段不可为null", groups = {Update.class, Delete.class})
    @TableField("is_sync")
    private Integer isSync;

    //租赁类型
    @NotEmpty
    @NotNull(message = "租赁类型字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "租赁类型字段的长度最大为2", groups = {Add.class, Update.class}, max = 2)
    @Trans(type = "wordbook", key = "monthly_type")
    @TableField("monthly_type")
    private String monthlyType;

    //集团编码
    @TableField("group_code")
    private String groupCode;

    //车牌号 以逗号分隔
    @Length(message = "车牌号 以逗号分隔字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("plate_nums")
    private String plateNums;

    //收费规则
    @NotNull(message = "收费规则字段不可为null", groups = {Update.class, Delete.class})
    @TableField("rule_id")
    private Long ruleId;

    //前段用户id
    @Length(message = "前段用户id字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("front_user_id")
    private String frontUserId;

    //1 后台系统 2 公众号/支付宝 3 APP 4 小程序
    @TableField("from_type")
    private Integer fromType;

    //备注
    @Length(message = "备注字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("remark")
    private String remark;

    //收费员id(路边停车)
    @TableField("collector_id")
    private String collectorId;

    //月租户类型名称
    @TableField(exist = false)
    private String leaseTypeName;

    //计费类型名称
    @TableField(exist = false)
    private String monthlyRuleName;

    //客户状态 0 未充值 1 已充值 2 已到期
    @TableField(exist = false)
    private Integer state;

    @TableField("img")
    private String img;



    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
