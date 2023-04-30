package com.xhb.report.service.impl;

import com.fhs.common.utils.ConverterUtils;
import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.config.EConfig;
import com.fhs.core.db.DataSource;
import com.xhb.common.FileUploader;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.fi.IReportTask;
import com.xhb.report.fi.ReportWord;
import com.xhb.report.service.ReportTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * <per>
 * 生成报表任务
 *
 * @author wangjie
 * @Date 2019/6/4 14:29
 * </per>
 */
@Service("reportTaskService")
@DataSource("park")
public class ReportTaskServiceImpl extends BaseServiceImpl<ReportTask> implements ReportTaskService {

    private ExecutorService taskPool;

    @Autowired
    private FileUploader fileUploader;

    /**
     * 执行生成报表任务
     *
     * @param taskDO DO
     * @param task   执行这个任务需要执行的代码
     */
    @Override
    public void submitReportTask(final ReportTask taskDO, final IReportTask task) {
        if (taskPool == null) {
            taskPool = Executors.newFixedThreadPool(ConverterUtils.toInt(EConfig.getOtherConfigPropertiesValue("reportTaskThreadsNum"), 5));
        }
        //insert task 2 db
        taskPool.execute(() -> {
            taskDO.setId(idHelper.nextId());
            insert(taskDO);
            File file = task.runTask(taskDO);
            String fileId = fileUploader.updateFile(file);
            taskDO.setReportStatus(STATUS_GENERATED);
            taskDO.setExcelFileId(fileId);
            updateById(taskDO);
        });
    }

    @Override
    public void submitReportTaskWord(ReportTask taskDO, ReportWord task) {
        if (taskPool == null) {
            taskPool = Executors.newFixedThreadPool(ConverterUtils.toInt(EConfig.getOtherConfigPropertiesValue("reportTaskThreadsNum"), 5));
        }
        taskPool.execute(() -> {
            insert(taskDO);
            String fileId = task.getFileId(taskDO);
            taskDO.setReportStatus(STATUS_GENERATED);
            taskDO.setExcelFileId(fileId);
            updateById(taskDO);
        });
    }


}
