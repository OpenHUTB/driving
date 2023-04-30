package com.xhb.pay.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.fhs.core.trans.TransTypes;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.park.bean.ParkSpecialPassType;
import com.xhb.park.bean.UcenterTollCollector;
import com.xhb.pay.bean.PayTempOrderHistory;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiParam;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 特殊放行
 *
 * @author Administrator -> yutao
 * @date 2022-04-25
 */
@ApiModel("特殊放行请求参数")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TransTypes(types = {"wordbook"})
public class PaySpecialPassDTO extends BaseDO<PaySpecialPassDTO> {

    private Long id;

    private String parkName;

    private String portName;

    private String userName;

    @Trans(type = TransType.SIMPLE,target = UcenterTollCollector.class,fields = "name",alias = "user")
    private  Long collectorId;

    private Integer parkTime;

    private Double lossAmount;

    private String describ;

    private String createTime;

    @Trans(type = "wordbook", key = "is_sync")
    private Integer isSync;

    @ApiParam(value = "车牌号")
    private String plateNumber;

    @Trans(type = TransType.SIMPLE,target = ParkParking.class,fields = "parkName")
    @ApiParam(value = "停车场id")
    private Long parkId;

    @Trans(type = TransType.SIMPLE,target = PayTempOrderHistory.class,fields = "totalAmount")
    @ApiParam(value = "临时订单id")
    private Long tempOrderId;

    @ApiParam(value = "放行原因分类")
    @Trans(type = TransType.SIMPLE,target = ParkSpecialPassType.class,fields = "describ")
    private String type;

    @ApiParam(value = "备注")
    private String remark;
}
