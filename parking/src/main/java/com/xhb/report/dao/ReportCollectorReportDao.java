package com.xhb.report.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.report.bean.ReportCollectorReport;

/**
 * <per>
 *
 * @author wangjie
 * @Date 2019/6/18 18:15
 * </per>
 */
@MapperDefinition(domainClass = ReportCollectorReport.class)
public interface ReportCollectorReportDao extends BaseDao<ReportCollectorReport> {
}
