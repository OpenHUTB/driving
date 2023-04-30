package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.ExcelExportTools;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ResultException;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.UcenterTollCollector;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ReportTaskService;
import com.xhb.report.service.TempOrderReportService;
import com.xhb.report.service.TollCollectorReportService;
import com.xhb.report.vo.DailyReportVo;
import com.xhb.report.vo.TollCollectorReportVo;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 收费员线下收费报表
 */
@RestController
@RequestMapping("/ms/tollCollector")
public class TollCollectorReportAction extends ModelSuperAction<UcenterTollCollector> {

    private static final Logger LOG = Logger.getLogger(TollCollectorReportAction.class);

    @Autowired
    private TollCollectorReportService tollCollectorReportService;

    @Autowired
    private TempOrderReportService tempOrderReportService;

    @Autowired
    private ReportTaskService reportTaskService;

    /**
     * 收费员线下收费报表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/underLineData")
    @RequiresPermissions("toll_collector_report:see")
    public Pager findPager(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        List<TollCollectorReportVo> rows = tollCollectorReportService.findListData(paramMap);
        int total = new Integer(paramMap.get("total").toString());
        Pager<TollCollectorReportVo> pager = new Pager<>(total, rows);
        return pager;
    }


    /**
     * 导出线下收费列表文件
     *
     * @param request
     * @param response
     */
    @RequestMapping({"exportReportExcel"})
    @RequiresPermissions("toll_collector_report:see")
    public void exportReportExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        List<TollCollectorReportVo> dataList = tollCollectorReportService.findListData(paramMap);
        ExcelExportTools.exportExcel(dataList, request, response);
    }

    /**
     * 日报表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/dailyReport")
    @RequiresPermissions("daily_report:see")
    public Object findDailyReport(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        if (CheckUtils.isNullOrEmpty(paramMap.get("payTime"))) {
            return new ArrayList<DailyReportVo>();
        }
        List<DailyReportVo> dateList = tollCollectorReportService.findDailyReport(paramMap);
        return dateList;
    }

    /**
     * 导出月报表/临时订单详情
     *
     * @param request
     * @param response
     */
    @RequestMapping({"exportDailyReportExcel"})
    @RequiresPermissions("daily_report:see")
    public HttpResult<Boolean> exportDailyReportExcel(HttpServletRequest request, HttpServletResponse response) {

        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        ReportTask reportTask = new ReportTask();
        ParamChecker.isNotNullOrEmpty(paramMap.get("payTime"), "时间为必选");
        ParamChecker.isNotNullOrEmpty(paramMap.get("parkId"), "停车场为必选");
        reportTask.setTimeDescribe(paramMap.get("payTime").toString());
        reportTask.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
        //判断当前月份是否有数据，无数据不生成报表
        DailyReportVo dailyReportVo = tempOrderReportService.findMonthData(paramMap);
        if (dailyReportVo == null) {
            throw new ResultException(new HttpResult(ReportTaskService.RESULT_STATUS, null, "没有相关数据，无法生成报表！"));
        }
        //查看报表是否已经生成
        reportTask.setReportType(0);
        ReportTask tempReportTask = reportTaskService.selectBean(reportTask);
        if (tempReportTask != null) {
            if (tempReportTask.getReportStatus() == ReportTaskService.STATUS_GENERATING) {
                throw new ResultException(new HttpResult(ReportTaskService.RESULT_STATUS, null, "excel文件正在生成，请稍后在报表夹下载！"));
            } else if (tempReportTask.getReportStatus() == ReportTaskService.STATUS_GENERATED) {
                throw new ResultException(new HttpResult(ReportTaskService.RESULT_STATUS, null, "excel文件已生成，请在报表夹下载！"));
            }
        }
        //创建准备生成报表基本数据
        reportTask.setReportStatus(ReportTaskService.STATUS_GENERATING);
        reportTask.setReportType(ReportTaskService.STATUS_GENERATING);
        reportTask.setGroupCode(super.getSessionuser(request).getGroupCode());
        reportTask.setParamMap(paramMap);
        reportTask.setReportName("月报表");
        reportTask.setCreateUser(super.getSessionuser(request).getUserId());
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        reportTask.setCreateTime(sf.format(new Date()));
        reportTask.setUpdateTime(sf.format(new Date()));
        reportTaskService.submitReportTask(reportTask, tempOrderReportService::makeMonthReport);
        return HttpResult.success(true);
    }

}
