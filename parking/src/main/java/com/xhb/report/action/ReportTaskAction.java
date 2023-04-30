package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.xhb.report.bean.ReportTask;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * <per>
 * 表单任务
 *
 * @author wangjie
 * @Date 2019/6/5 17:10
 * </per>
 */
@RestController
@RequestMapping("/ms/reportTask")
public class ReportTaskAction extends ModelSuperAction<ReportTask> {

}
