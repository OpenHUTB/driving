package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.IdHelper;
import com.fhs.context.UserContext;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ResultException;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.park.service.ParkParkingPortService;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.form.PayCarcomeForm;
import com.xhb.pay.service.PayCarcomeHistoryService;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ReportTaskService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ms/pay_carcome_history")
public class PayCarcomeHistoryAction extends ModelSuperAction<PayCarcomeExportDTO> {
    @Autowired
    private PayCarcomeHistoryService payCarcomeHistoryService;
    @Autowired
    private ParkParkingService parkParkingService;
    @Autowired
    private ParkParkingPortService parkParkingPortService;
    @Autowired
    private ReportTaskService reportTaskService;
    @Autowired
    private PayCarcomeService payCarcomeService;
    @Autowired
    private IdHelper idHelper;

    /**
     * 查询车辆进出列表
     */
    @GetMapping("/queryPager")
    @RequiresPermissions("pay_carcome:see")
    public Pager queryPayCarcomeHistoryPage(PayCarcomeForm payCarcomeForm, HttpServletRequest request) {
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", super.getParameterMap(request));
        payCarcomeForm.setGroupCode(UserContext.getSessionuser().getGroupCode());
        payCarcomeForm.setAdmin(UserContext.getSessionuser().getIsAdmin());
        Object obj = DataPermissonContext.getDataPermissonMap().get("parkIds");
        List<PayCarcomeExportDTO> list = payCarcomeHistoryService.queryPayCarcomePage(payCarcomeForm,obj);
        Pager<PayCarcomeExportDTO> pager = new Pager<>(null, list);
        return pager;
    }

    /**
     * 查询车辆进出详情
     */
    @GetMapping("/detail")
    @RequiresPermissions("pay_carcome:see")
    public PayCarcomeExportDTO queryPayCarcomeHistory(Long id) {
        return payCarcomeHistoryService.queryPayCarcome(id);
    }

    /**
     * 车辆出入场记录 导出
     *
     * @param request
     */
    @RequestMapping({"/payCarcomeHistoryExcel"})
    @RequiresPermissions("pay_carcome:see")
    public HttpResult<Boolean> payCarcomeHistoryExcel(HttpServletRequest request) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        paramMap.put("end", null);
        ParamChecker.isNotNullOrEmpty(paramMap.get("parkId"), "停车场为必选");
        if (payCarcomeHistoryService.findCount(paramMap) <= 0) {
            throw new ResultException(new HttpResult(ReportTaskService.RESULT_STATUS, null, "没有相关数据，无法导出！"));
        }
        //start名称拼接
        StringBuffer strName = new StringBuffer();
        ParkParking parkParking = parkParkingService.findBeanById(paramMap.get("parkId"));
        strName.append(super.getSessionuser(request).getUserName() + "-" + parkParking.getParkName());
        ParkParkingPort parkParkingPort = parkParkingPortService.findBeanById(paramMap.get("portId"));
        if (parkParkingPort != null) {
            strName.append("-" + parkParkingPort.getPortName());
        }
        String accessTimeMin = paramMap.get("accessTimeMin").toString();
        if (!accessTimeMin.isEmpty()) {
            strName.append("-最小时间:" + accessTimeMin);
        }
        String accessTimeMax = paramMap.get("accessTimeMax").toString();
        if (!accessTimeMax.isEmpty()) {
            strName.append("-最大时间:" + accessTimeMax);
        }
        String plateNumber = paramMap.get("plateNumber").toString();
        if (!plateNumber.isEmpty()) {
            strName.append("-车牌号:" + plateNumber);
        }
        ReportTask reportTask = new ReportTask();
        reportTask.setReportName(strName.toString());
        reportTask.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
        reportTask.setReportStatus(ReportTaskService.STATUS_GENERATING);
        reportTask.setReportType(ReportTaskService.REPORTTYPE_EXPORT);
        reportTask.setGroupCode(super.getSessionuser(request).getGroupCode());
        reportTask.setParamMap(paramMap);
        reportTask.preInsert(super.getSessionuser(request).getUserId());
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM");
        reportTask.setTimeDescribe(sf.format(new Date()));
        reportTaskService.submitReportTask(reportTask, payCarcomeHistoryService::makeCarcomeHistory);
        return HttpResult.success(true);
    }

    /**
     * 删除车辆进出信息
     */
    @PostMapping("/delete/{id}")
    @RequiresPermissions("pay_carcome:see")
    public HttpResult<Boolean> delData2PayCarcomeHistory(@PathVariable("id")Long id){
        payCarcomeHistoryService.delData2PayCarcomeHistory(id);
        return HttpResult.success(true);
    }

    /**
     * 修改车辆进出信息
     */
    @PostMapping("/modify")
    @RequiresPermissions("pay_carcome:see")
    public HttpResult<Boolean> updateData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm){
        payCarcomeHistoryService.updateData2PayCarcomeHistory(payCarcomeForm);
        return HttpResult.success(true);
    }

    /**
     * 新增车辆进出信息
     */
    @PostMapping("/save")
    @RequiresPermissions("pay_carcome:see")
    public HttpResult<Boolean>  addData2PayCarcomeHistory(PayCarcomeForm payCarcomeForm){
        payCarcomeForm.setId(idHelper.nextId());
        payCarcomeForm.setGroupCode(UserContext.getSessionuser().getGroupCode());
        payCarcomeHistoryService.addData2PayCarcomeHistory(payCarcomeForm);
        return HttpResult.success(true);
    }

}
