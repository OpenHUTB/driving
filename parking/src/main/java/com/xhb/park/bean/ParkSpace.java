package com.xhb.park.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import com.mybatis.jpa.annotation.DataPermisson;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.validation.constraints.NotNull;

/**
 * (ParkSpace)实体类
 *
 * @author makejava
 * @since 2019-04-19 16:01:15
 */

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@TableName("t_park_space")
public class ParkSpace extends BaseDO<ParkSpace> implements Syncable {
    private static final long serialVersionUID = -25811432866465672L;
    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    //空闲车位
    @NotNull(message = "空闲车位字段不可为null", groups = {Update.class})
    @TableField("free_space")
    private Integer freeSpace;

    //已使用车位
    @NotNull(message = "已使用车位字段不可为null", groups = {Update.class})
    @TableField("used_space")
    private Integer usedSpace;

    @TableField("is_sync")
    private Integer isSync;

    @TableField("park_id")
    @DataPermisson("parkIds")
    private Long parkId;

    //停车场名称-db中不存在此字段
    @TableField(exist = false)
    @OneToOne
    @JoinColumn(name = "park_id", referencedColumnName = "id")
    private ParkParking parkParking;

    //集团编码
    @Length(message = "集团编码字段的长度最大为32", groups = {Add.class, Update.class}, max = 32)
    @TableField("group_code")
    private String groupCode;

    //停车场名称
    @TableField(exist = false)
    private String parkName;

    //月租专属车位剩余数量
    @TableField("used_space_monthly")
    private Integer usedSpaceMonthly;


    @Override
    public Long getPrimaryVal() {
        return this.id;
    }
}
