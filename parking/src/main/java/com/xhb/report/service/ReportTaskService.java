package com.xhb.report.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.fi.IReportTask;
import com.xhb.report.fi.ReportWord;

/**
 * <per>
 * 表单生成任务
 *
 * @author wangjie
 * @Date 2019/6/4 14:28
 * </per>
 */
public interface ReportTaskService extends BaseService<ReportTask> {

    /**
     * 生成中
     */
    int STATUS_GENERATING = 0;

    /**
     * 已生成
     */
    int STATUS_GENERATED = 1;

    /**
     * 返回状态
     */
    int RESULT_STATUS = 400;

    /**
     * 车辆出入场导出
     */
    int REPORTTYPE_EXPORT = 2;

    /**
     * 临时订单导出
     */
    int PAYTEMPORDER_EXPORT = 1;

    /**
     * 内部客户充值导出
     */
    int PAYINSIDERECHARGE_EXPORT = 3;

    /**
     * OA报表导出
     */
    int PAYINSIDERECHARGE_OAPARKMONTH = 4;

    /**
     * 添加一个任务道线程池去执行，执行完系统自动会将任务状态改为已完成
     *
     * @param taskDO DO
     * @param task   执行这个任务需要执行的代码
     */
    void submitReportTask(ReportTask taskDO, IReportTask task);

    /**
     * 添加一个任务道线程池去执行，执行完系统自动会将任务状态改为已完成，生成Word
     *
     * @param taskDO DO
     * @param task   执行这个任务需要执行的代码
     */
    void submitReportTaskWord(ReportTask taskDO, ReportWord task);


}
