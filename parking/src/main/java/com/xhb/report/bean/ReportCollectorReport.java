package com.xhb.report.bean;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fhs.core.base.bean.BaseDO;
import lombok.Builder;
import lombok.Data;

/**
 * <per>
 * 收费员记录信息
 *
 * @author wangjie
 * @Date 2019/6/18 18:04
 * </per>
 */
@Data
@Builder
@TableName("t_report_collector_report")
public class ReportCollectorReport extends BaseDO<ReportCollectorReport> {

    @TableId(value = "id", type = IdType.INPUT)
    private Long id;//

    @TableField("park_id")
    private Long parkId;//停车场id

    @TableField("collector_id")
    private String collectorId;//收费员id

    @TableField("report_date")
    private String reportDate;//日期

    public ReportCollectorReport() {
    }

    public ReportCollectorReport(Long id, Long parkId, String collectorId, String reportDate) {
        this.id = id;
        this.parkId = parkId;
        this.collectorId = collectorId;
        this.reportDate = reportDate;
    }
}
