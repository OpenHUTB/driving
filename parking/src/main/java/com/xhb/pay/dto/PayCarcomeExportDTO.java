package com.xhb.pay.dto;

import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.fhs.core.trans.TransTypes;
import com.github.liaochong.myexcel.core.WorkbookType;
import com.github.liaochong.myexcel.core.annotation.ExcelColumn;
import com.github.liaochong.myexcel.core.annotation.ExcelTable;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.pay.bean.PayCarcomeExt;
import lombok.Data;

import java.util.Map;

/**
 * <per>
 * 车辆出入场记录
 *
 * @author wangy
 * @Date 2019/6/26 14:40
 * </per>
 */
@Data
@TransTypes(types = {"pagex", "wordbook"})
@ExcelTable(sheetName = "车辆出入场记录", workbookType = WorkbookType.SXLSX, excludeParent = true, includeAllField = false)
public class PayCarcomeExportDTO extends BaseDO<PayCarcomeExportDTO> {

    @Trans(type = TransType.SIMPLE,target = PayCarcomeExt.class,fields = {"syncTime","updateTime","remark","isSync"})
    private Long id;

    @Trans(type = TransType.SIMPLE,target = ParkParking.class,fields = "parkName")
    private Long parkId; //停车名称


    @Trans(type = TransType.SIMPLE,target = ParkParkingPort.class,fields = "portName")
    private Long portId; //出入口名称

    @ExcelColumn(index = 0, title = "停车名称")
    private String parkName;

    @ExcelColumn(index = 1, title = "出入口名称")
    private String portName;

    @ExcelColumn(index = 2, title = "车辆颜色")
    @Trans(type = "wordbook", key = "car_color")
    private String carColor; //车辆颜色

    @ExcelColumn(index = 3, title = "车牌号")
    private String plateNumber; //车牌号

    @ExcelColumn(index = 4, title = "状态")
    @Trans(type = "wordbook", key = "car_status")
    private String status; //状态

    @ExcelColumn(index = 5, title = "类型")
    @Trans(type = "wordbook", key = "record_type")
    private String recordType; //类型

    @ExcelColumn(index = 6, title = "车辆类型")
    @Trans(type = "wordbook", key = "car_type")
    private String carType; //车辆类型

    @ExcelColumn(index = 7, title = "数据类型")
    @Trans(type = "wordbook", key = "enter_or_exit")
    private String type; //数据类型

    @ExcelColumn(index = 8, title = "出场时间")
    private String accessTime; //出场时间

    @ExcelColumn(index = 9, title = "服务器插入时间")
    private String syncTime; //服务器插入时间

    @ExcelColumn(index = 10, title = "更新时间")
    private String updateTime; //更新时间

    @ExcelColumn(index = 11, title = "是否下发")
    @Trans(type = "wordbook", key = "yesOrNo")
    private String isSync;//是否已下发

    @ExcelColumn(index = 12, title = "备注")
    private String remark; //备注

    //照片厂端保存路径
    private String imgPath;

    //照片服务器保存查看id
    private String img;


    public PayCarcomeExportDTO() {
    }

    public PayCarcomeExportDTO(Long id, Long parkId, Long portId, String carColor, String plateNumber, String status, String recordType, String carType, String type, String accessTime, String syncTime, String updateTime, String isSync, String remark, String imgPath, String img) {
        this.id = id;
        this.parkId = parkId;
        this.portId = portId;
        this.carColor = carColor;
        this.plateNumber = plateNumber;
        this.status = status;
        this.recordType = recordType;
        this.carType = carType;
        this.type = type;
        this.accessTime = accessTime;
        this.syncTime = syncTime;
        this.updateTime = updateTime;
        this.isSync = isSync;
        this.remark = remark;
        this.imgPath = imgPath;
        this.img = img;
    }

    public String getIsSyncName() {
        Map<String, String> transMap = super.getTransMap();
        if (transMap != null){
            String isSync = transMap.get("isSync");
            if (isSync != null){
                switch(isSync){
                    case "0":
                        return "未同步";
                    case "1":
                        return "同步";
                }
            }
        }
        return null;
    }
}
