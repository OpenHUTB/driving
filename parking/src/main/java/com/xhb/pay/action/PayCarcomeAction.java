package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ResultException;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.fhs.ucenter.api.vo.SysUserVo;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.bean.ParkParkingPort;
import com.xhb.park.service.ParkParkingPortService;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.dto.PayCarcomeExportDTO;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ReportTaskService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 车辆出入场
 */
@RestController
@RequestMapping("/ms/pay_carcome")
public class PayCarcomeAction extends ModelSuperAction<PayCarcomeExportDTO> {

    private static final Logger LOG = Logger.getLogger(PayCarcomeAction.class);

    @Autowired
    private PayCarcomeService carcomeService;

    @Autowired
    private TransService transService; //翻译

    @Autowired
    private ParkParkingService parkParkingService; //停车场

    @Autowired
    private ParkParkingPortService parkParkingPortService; //出入口

    @Autowired
    private ReportTaskService reportTaskService; //报表




    /**
     * 查询
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/findPayCarcomePage")
    @RequiresPermissions("pay_carcome:see")
    public Pager findPayCarcomePage(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("sortTzwName", this.formartOrderBy(request));
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        List<PayCarcomeExportDTO> rows = carcomeService.findListData(paramMap);
        transService.transMore(rows);
        //Long total = carcomeService.findCount(paramMap);
        return new Pager(null, rows);
    }
    /**
     * 车辆出入场记录 导出
     *
     * @param request
     * @param response
     */
    @RequestMapping({"payCarcomeExcel"})
    @RequiresPermissions("pay_carcome:see")
    public HttpResult<Boolean> payCarcomeExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        paramMap.put("end", null);
        ParamChecker.isNotNullOrEmpty(paramMap.get("parkId"), "停车场为必选");
        if (carcomeService.findCount(paramMap) <= 0) {
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
        //end
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
        reportTaskService.submitReportTask(reportTask, carcomeService::makeCarcome);
        return HttpResult.success(true);
    }

    /**
     * 入场记录批量导入
     *
     * @param request
     * @param file
     * @return
     */

    @RequestMapping("batchImport")
    public HttpResult<Boolean> batchImport(HttpServletRequest request, @RequestParam("file") MultipartFile file) {
        Long parkId = ConverterUtils.toLong(request.getParameter("parkId"));
        ParamChecker.isNotNullOrEmpty(parkId, "停车场不能为空");
        SysUserVo sysUser = super.getSessionuser(request);
        Map<String, Object> paramMap = new HashMap<>(3);
        paramMap.put("sysUserId", sysUser.getUserId());
        paramMap.put("parkId", parkId);
        paramMap.put("groupCode", sysUser.getGroupCode());
        return HttpResult.success(carcomeService.batchImport(paramMap, file));
    }
}
