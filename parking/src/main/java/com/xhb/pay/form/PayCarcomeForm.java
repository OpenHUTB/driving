package com.xhb.pay.form;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.mvel2.util.Make;

/**
 * 车辆进出列表的条件查询需要此form
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PayCarcomeForm {
    //ID
    private Long id;
    //停车场Id
    private Long parkId;
    //进/出场时间
    private String accessTime;
    //出入口ID
    private Long portId;
    //最小出入场时间
    private String accessTimeMin;
    //最大出入场时间
    private String accessTimeMax;
    //车牌号
    private String plateNumber;
    //是否为有效依据
    private Integer isValid;
    //集团编码
    private String groupCode;
    //页数
    private Integer page;
    //显示条数
    private Integer rows;
    //从第几条显示
    private Long num;
    //车辆类型
    private Integer carType;
    //服务器插入时间
    private String syncTime;
    //出入场记录
    private Integer type;
    //车辆级别
    private Integer recordType;
    //照片服务器保存查看id
    private String img;
    //备注
    private String remark;
    //是否同步
    private Integer isSync;
    //更新时间
    private String updateTime;
    //有权限查看的停车场
    private String parkIds;
    //用户权限
    private Integer admin;

}
