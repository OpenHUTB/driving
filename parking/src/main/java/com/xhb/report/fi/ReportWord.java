package com.xhb.report.fi;

import com.xhb.report.bean.ReportTask;

/**
 * <per>
 *
 * @author yutao
 * @Date 2019/10/15 15:07
 * </per>
 */
@FunctionalInterface
public interface ReportWord {

    /**
     * 执行一个任务,返回文件Id
     *
     * @param task 任务
     */
    String getFileId(ReportTask task);

}
