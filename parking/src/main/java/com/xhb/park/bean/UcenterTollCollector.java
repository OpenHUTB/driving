package com.xhb.park.bean;

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
 * 收费人员表(UcenterTollCollector)实体类
 *
 * @author makejava
 * @since 2019-04-03 17:52:06
 */

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_ucenter_toll_collector")
public class UcenterTollCollector extends BaseDO<UcenterTollCollector> implements Syncable {
    private static final long serialVersionUID = -71397514868600440L;
    @TableId(value = "collector_id", type = IdType.INPUT)
    private Long collectorId;

    //姓名
    @NotEmpty
    @NotNull(message = "姓名字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "姓名字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("name")
    private String name;

    //停车场id
    @NotNull(message = "停车场id字段不可为null", groups = {Update.class, Delete.class})
    @TableField("park_id")
    private Long parkId;


    //部门id(下拉tree)
    @NotEmpty
    @NotNull(message = "部门id(下拉tree)字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "部门id(下拉tree)字段的长度最大为255", groups = {Add.class, Update.class}, max = 255)
    @TableField("org_id")
    private String orgId;

    //手机号
    @Length(message = "手机号字段的长度最大为18", groups = {Add.class, Update.class}, max = 18)
    @TableField("mobile")
    private String mobile;


    //0未同步 1已同步
    @TableField("is_sync")
    private Integer isSync;

    //密码
    @NotEmpty
    @NotNull(message = "密码字段不可为null", groups = {Update.class, Delete.class})
    @Length(message = "密码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("password")
    private String password;

    //用户名
    @Length(message = "用户名字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("login_name")
    private String loginName;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    /**
     * 是否是路边停车场的收费员
     */
    @TableField("is_road")
    private Integer isRoad;

    //停车场id-路边停车场收费员支持多个车场
    @TableField("park_ids")
    private String parkIds;


    @Override
    public Long getPrimaryVal() {
        return this.collectorId;
    }

    @Override
    public void setId(Long id) {
        this.collectorId = id;
    }

    public Long getId() {
        return this.collectorId;
    }
}
