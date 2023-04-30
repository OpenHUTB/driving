package com.xhb.park.bean;

import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.serializer.ToStringSerializer;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Delete;
import com.fhs.core.group.Update;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import javax.validation.constraints.NotNull;

/**
 * 停车场表(ParkParking)实体类
 *
 * @author jackwong
 * @since 2019-03-13 15:10:42
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_park_parking")
public class ParkParking extends BaseDO<ParkParking> implements Syncable {
    private static final long serialVersionUID = 549884519901167810L;
    @TableId(value = "id", type = IdType.INPUT)
    @JSONField(serializeUsing = ToStringSerializer.class)
    private Long parkId;

    //停车场名称
    @NotEmpty
    @NotNull(message = "停车场名称字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "停车场名称字段的长度最大为100", groups = {Add.class, Update.class}, max = 100)
    @TableField("park_name")
    private String parkName;



    //本停车场停车位数
    @NotEmpty
    @NotNull(message = "本停车场停车位数字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "本停车场停车位数字段的长度最大为11", groups = {Add.class, Update.class}, max = 3)
    @TableField("space_count")
    private Integer spaceCount;



    //停车场经度  停车场中心的
    @Length(message = "停车场经度  停车场中心的字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("longitude")
    private String longitude;

    //停车场纬度  停车场中心的
    @Length(message = "停车场纬度  停车场中心的字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("latitude")
    private String latitude;

    //车场的具体位置，哪条街，哪个路
    @Length(message = "车场的具体位置，哪条街，哪个路字段的长度最大为512", groups = {Add.class, Update.class}, max = 512)
    @TableField("address")
    private String address;


    //停车场类型
    @Length(message = "停车场类型字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("park_type")
    private String parkType;


    //停车场网络状态，1正常 ，0 断网
    @Length(message = "停车场网络状态，1正常 ，0 断网字段的长度最大为11", groups = {Add.class, Update.class}, max = 11)
    @TableField("network_state")
    private String networkState;




    //父停车场编号
    @Length(message = "父停车场编号字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("parent_park_id")
    private Long parentParkId;


    //省份
    @Length(message = "省份字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("provinceid")
    private String provinceid;

    //市
    @Length(message = "市字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("cityid")
    private String cityid;

    //区县
    @Length(message = "区县字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("areaid")
    private String areaid;

    //密钥
    @Length(message = "密钥字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("secret")
    private String secret;

    //黑名单提示
    @Length(message = "黑名单提示字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("black_list_remark")
    private String blackListRemark;

    //免费时长:分钟
    @TableField("free_time")
    private Integer freeTime;



    //提前付费后出场限制时间
    @TableField("exit_time")
    private Integer exitTime;

    //是否已经下发
    @TableField("is_sync")
    private Integer isSync;

    //每日最多多少钱
    @TableField("one_day_max_fee")
    private Double oneDayMaxFee;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //月租可以往前选择多少天
    @Length(message = "月租可以往前选择多少天字段的长度最大为3", groups = {Add.class, Update.class}, max = 3)
    @TableField("monthly_pre_days")
    private Integer monthlyPreDays;

    //月租可以往后选择多少天
    @Length(message = "月租可以往后选择多少天字段的长度最大为3", groups = {Add.class, Update.class}, max = 3)
    @TableField("monthly_after_days")
    private Integer monthlyAfterDays;

    //月租到期提醒方式
    @TableField("monthly_notice_type")
    private Integer monthlyNoticeType;

    //月租到期提前多少天提醒
    @TableField("monthly_notice_days")
    private Integer monthlyNoticeDays;

    //最多绑定多少个车牌号
    @TableField("max_bind_plate_num")
    private Integer maxBindPlateNum;

    //月租到期缓冲天数
    @TableField("buffer_days")
    private Integer bufferDays;

    //24小时内最高收费
    @TableField("one_24h_max_fee")
    private Double one24hMaxFee;

    //场中场类型 0 单个车场 1 场中场同经营主体  2 场中场不同经营主体
    @Length(message = "场中场类型 0 单个车场 1 场中场同经营主体  2 场中场不同经营主体字段的长度最大为1", groups = {Add.class, Update.class}, max = 1)
    @TableField("big_park_type")
    private String bigParkType;


    //停车位统计(0 临停月租分开统计 1混合统计 )
    @TableField("spaces_census")
    private Integer spacesCensus;

    //是否选车位
    @TableField("is_select_space")
    private String isSelectSpace;

    @TableField("max_monthly_lotnum")
    private Integer maxMonthlyLotnum;

    /**
     * 是否是路边停车场
     */
    @TableField("is_road")
    private Integer isRoad;

    /**
     * 路边收费开始时间
     */
    @TableField("fee_start_time")
    private String freeStartTime;

    /**
     * 路边收费结束时间
     */
    @TableField("fee_end_time")
    private String freeEndTime;

    /**
     * 如果是路边停车场的话是否有硬件
     */
    @TableField("is_hardware")
    private Integer isHardware;

    @Override
    public Long getPrimaryVal() {
        return this.parkId;
    }


    @Override
    public void setId(Long id) {
        this.parkId = id;
    }

    public Long getId() {
        return this.parkId;
    }
}
