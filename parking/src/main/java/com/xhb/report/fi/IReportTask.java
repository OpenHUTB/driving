package com.xhb.report.fi;


import com.xhb.report.bean.ReportTask;

import java.io.File;

/**
 * <per>
 *
 * @author wangjie
 * @Date 2019/6/4 15:07
 * </per>
 */
@FunctionalInterface
public interface IReportTask {
    /**
     * 执行一个任务
     *
     * @param task 任务
     */
    File runTask(ReportTask task);
}
