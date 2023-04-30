package com.xhb.report.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import com.fhs.core.trans.Trans;
import com.fhs.core.trans.TransType;
import com.xhb.park.bean.ParkParkingPort;
import lombok.Builder;
import lombok.Data;

import java.util.Map;

/**
 * <per>
 * 报表任务
 *
 * @author wangjie
 * @Date 2019/6/4 14:12
 * </per>
 */
@Data
@Builder
@TableName("t_report_task")
public class ReportTask extends BaseDO<ReportTask> {

    @TableId(value = "id", type = IdType.INPUT)
    private Long id;//

    @TableField("park_id")
    @Trans(type = TransType.SIMPLE,target = ParkParkingPort.class,fields = "portName")
    private Long parkId;//停车场

    @TableField("report_status")
    private Integer reportStatus;//下载表单状态

    @TableField("time_describe")
    private String timeDescribe;//时间

    @TableField("excel_file_id")
    private String excelFileId;//生成文件路径

    @TableField("report_type")
    private Integer reportType;//报表类型

    @TableField("report_name")
    private String reportName;//报表名称

    @TableField("group_code")
    private String groupCode;//集团编号

    @TableField(exist = false)
    private Map<String, Object> paramMap;

    public ReportTask() {

    }

    public ReportTask(Long id, Long parkId, Integer reportStatus, String timeDescribe, String excelFileId, Integer reportType, String reportName, String groupCode, Map<String, Object> paramMap) {
        this.id = id;
        this.parkId = parkId;
        this.reportStatus = reportStatus;
        this.timeDescribe = timeDescribe;
        this.excelFileId = excelFileId;
        this.reportType = reportType;
        this.reportName = reportName;
        this.groupCode = groupCode;
        this.paramMap = paramMap;
    }
}
