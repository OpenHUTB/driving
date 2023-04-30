package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.context.UserContext;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ResultException;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.bean.PayTempOrderHistory;
import com.xhb.pay.dto.PayTempOrderDTO;
import com.xhb.pay.form.PayTempOrderForm;
import com.xhb.pay.service.PayTempOrderHistoryService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ReportTaskService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ms/pay_temp_order_history")
public class PayTempOrderHistoryAction extends ModelSuperAction<PayTempOrderHistory> {
    @Autowired
    private PayTempOrderHistoryService payTempOrderHistoryService;

    @Autowired
    private ReportTaskService reportTaskService;

    @Autowired
    private TransService transService;

    @Autowired
    private ParkParkingService parkParkingService;

    /**
     * 查询临时订单管理列表
     *
     *
     */
    @GetMapping("/queryPager")
    @RequiresPermissions("pay_temp_order:see")
    public Pager queryPayTempOderHistoryPage(PayTempOrderForm payTempOrderForm,HttpServletRequest request){
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", super.getParameterMap(request));
        payTempOrderForm.setGroupCode(UserContext.getSessionuser().getGroupCode());
        payTempOrderForm.setAdmin(UserContext.getSessionuser().getIsAdmin());
        Object obj = DataPermissonContext.getDataPermissonMap().get("parkIds");
        List<PayTempOrderDTO> list = payTempOrderHistoryService.queryTempOrderPage(payTempOrderForm,obj);
        Pager<PayTempOrderDTO> pager = new Pager<>(null, list);
        return pager;
    }

    /**
     * 查询临时订单详情
     */
    @GetMapping("/detail")
    @RequiresPermissions("pay_temp_order:see")
    public PayTempOrderDTO queryPayTempOderHistory(Long id){
        return payTempOrderHistoryService.queryTempOrder(id);
    }

    /**
     * 临时订单导出
     *
     * @param request
     */
    @RequestMapping({"/exportReportHistoryExcel"})
    @RequiresPermissions("pay_temp_order:see")
    public HttpResult<Boolean> exportReportExcel(HttpServletRequest request) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        ParamChecker.isNotNullOrEmpty(paramMap.get("parkId"), "停车场为必选");
        if (payTempOrderHistoryService.findPayTempOrderCount(paramMap) <= 0) {
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
        reportTaskService.submitReportTask(reportTask, payTempOrderHistoryService::makeMonthReport);
        return HttpResult.success(true);
    }

}
