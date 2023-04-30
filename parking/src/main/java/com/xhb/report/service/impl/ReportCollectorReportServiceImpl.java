package com.xhb.report.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.report.bean.ReportCollectorReport;
import com.xhb.report.service.ReportCollectorReportService;
import org.springframework.stereotype.Service;

/**
 * <per>
 * 收费员记录信息
 *
 * @author wangjie
 * @Date 2019/6/18 18:18
 * </per>
 */
@Service("reportCollectorReportService")
@DataSource("park")
public class ReportCollectorReportServiceImpl extends BaseServiceImpl<ReportCollectorReport> implements ReportCollectorReportService {
}
