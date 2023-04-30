package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ResultException;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.bean.PayTempOrder;
import com.xhb.pay.dto.PayTempOrderDTO;
import com.xhb.pay.service.PayTempOrderReportService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ReportTaskService;
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
import java.util.concurrent.CompletableFuture;

/**
 * 临时入场出厂缴费(PayTempOrder)表控制层
 *
 * @author jackwong
 * @since 2019-03-07 13:03:09
 */
@RestController
@RequestMapping("/ms/pay_temp_order")
public class PayTempOrderAction extends ModelSuperAction<PayTempOrder> {

    private static final Logger LOG = Logger.getLogger(PayTempOrderAction.class);

    @Autowired
    private PayTempOrderReportService payTempOrderReportService;

    @Autowired
    private TransService transService;

    @Autowired
    private ReportTaskService reportTaskService;

    @Autowired
    private ParkParkingService parkParkingService;


    /**
     * 临时订单导出
     *
     * @param request
     * @param response
     */
    @RequestMapping({"exportReportExcel"})
    @RequiresPermissions("pay_temp_order:see")
    public HttpResult<Boolean> exportReportExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        ParamChecker.isNotNullOrEmpty(paramMap.get("parkId"), "停车场为必选");
        if (payTempOrderReportService.findPayTempOrderCount(paramMap) <= 0) {
            throw new ResultException(new HttpResult(ReportTaskService.RESULT_STATUS, null, "没有相关数据，无法导出！"));
        }
        ParkParking parkParking = parkParkingService.findBeanById(paramMap.get("parkId"));
        StringBuffer excelName = new StringBuffer();
        excelName.append(super.getSessionuser(request).getUserName() + "-" + parkParking.getParkName());
        if (CheckUtils.isNotEmpty(paramMap.get("orderStatus"))) {
            PayTempOrderDTO payTempOrderDTO = new PayTempOrderDTO();
            payTempOrderDTO.setOrderStatus(paramMap.get("orderStatus").toString());
            transService.transOne(payTempOrderDTO);
            excelName.append("-" + payTempOrderDTO.getTransMap().get("orderStatusName"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("plateNumber"))) {
            excelName.append("-车牌号:" + paramMap.get("plateNumber"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("enterTimeMin"))) {
            excelName.append("-最小出入场时间:" + paramMap.get("enterTimeMin"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("enterTimeMax"))) {
            excelName.append("-最大出入场时间:" + paramMap.get("enterTimeMax"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("payTimeMin"))) {
            excelName.append("-最小支付时间:" + paramMap.get("payTimeMin"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("payTimeMax"))) {
            excelName.append("-最大支付时间:" + paramMap.get("payTimeMax"));
        }
        //创建准备生成报表基本数据
        ReportTask reportTask = new ReportTask();
        reportTask.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
        reportTask.setReportName(excelName.toString());
        reportTask.setReportStatus(ReportTaskService.STATUS_GENERATING);
        reportTask.setReportType(ReportTaskService.PAYTEMPORDER_EXPORT);
        reportTask.setGroupCode(super.getSessionuser(request).getGroupCode());
        reportTask.setParamMap(paramMap);
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        reportTask.setTimeDescribe(sf.format(new Date()).substring(0, 7));
        reportTask.preInsert(super.getSessionuser(request).getUserId());

        paramMap.put("end", null);
        reportTaskService.submitReportTask(reportTask, payTempOrderReportService::makeMonthReport);
        return HttpResult.success(true);
    }


    @RequestMapping("/findPayTempOrderPage")
    @RequiresPermissions("pay_temp_order:see")
    public Pager findPayTempOrderPage(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        String parkIds = DataPermissonContext.getDataPermissonMap().get("parkIds");
        paramMap.put("parkIds", parkIds);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        String formatParam = formartOrderBy(request);
        paramMap.put("sortTzwName", formatParam);
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        //并行执行
        Integer total = 0;
        List<PayTempOrderDTO> rows = new ArrayList<>();
        CompletableFuture<Integer> number = CompletableFuture.supplyAsync(() -> getTotal(paramMap));
        CompletableFuture<List<PayTempOrderDTO>> listCompletableFuture = CompletableFuture.supplyAsync(() -> getData(paramMap));
        try {
            total = number.get();
            rows = listCompletableFuture.get();
        } catch (Exception e) {
            LOG.error("临时订单获取数据错误:", e);
        }
        transService.transMore(rows);
        Pager<PayTempOrderDTO> pager = new Pager<>(total, rows);
        return pager;
    }

    /**
     * 获得数据
     *
     * @param paramMap
     * @return
     */
    private List<PayTempOrderDTO> getData(Map<String, Object> paramMap) {
        return payTempOrderReportService.findPayTempOrderList(paramMap);
    }

    /**
     * 总条数
     *
     * @param paramMap
     * @return
     */
    private int getTotal(Map<String, Object> paramMap) {
        return payTempOrderReportService.findPayTempOrderCount(paramMap);
    }
}
