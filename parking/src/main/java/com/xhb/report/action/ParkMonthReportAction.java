package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.result.HttpResult;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ParkMonthReportService;
import com.xhb.report.service.ReportTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.*;


/**
 * OA 对接月报表
 *
 * @author yutao
 * @since 2019-09-28 09:22:11
 */
@RestController
@RequestMapping("/parkMonthReport/")
public class ParkMonthReportAction extends ModelSuperAction<ReportTask> {

    @Autowired
    private ParkMonthReportService parkMonthReportService;

    @Autowired
    private ReportTaskService reportTaskService;

    /**
     * OA 数据获取
     *
     * @param parkId
     * @param dateTime
     * @return
     */
    @RequestMapping("findCountData")
    public Map<String, Object> findCountData(Long parkId, String dateTime) {
        long a = System.currentTimeMillis();//获取当前系统时间(毫秒)
        Map<String, Object> countData = parkMonthReportService.findCountData(parkId, dateTime);
        System.out.print("使用多线程去跑---------- 程序执行时间为：");
        System.out.println(System.currentTimeMillis() - a + "毫秒");
        return countData;
    }

    /**
     * OA报表导出
     *
     * @return
     */
    @RequestMapping("OAParkMonthWord")
    public HttpResult<Boolean> OAParkMonthExcel(HttpServletRequest request, Long parkId, String dateTime) {
        ParamChecker.isNotNullOrEmpty(parkId, "停车场为必选");
        ParamChecker.isNotNullOrEmpty(dateTime, "日期为必选");
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("parkId", parkId);
        paramMap.put("dateTime", dateTime);

        ReportTask reportTask = new ReportTask();
        reportTask.setReportName(dateTime + "-OA报表");
        reportTask.setParkId(parkId);
        reportTask.setReportStatus(ReportTaskService.STATUS_GENERATING);
        reportTask.setReportType(ReportTaskService.PAYINSIDERECHARGE_OAPARKMONTH);
        reportTask.setGroupCode(super.getSessionuser(request).getGroupCode());
        reportTask.setParamMap(paramMap);
        reportTask.preInsert(super.getSessionuser(request).getUserId());
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM");
        reportTask.setTimeDescribe(sf.format(new Date()));
        reportTaskService.submitReportTaskWord(reportTask, parkMonthReportService::makeReportWord);
        return HttpResult.success(true);
    }

}
