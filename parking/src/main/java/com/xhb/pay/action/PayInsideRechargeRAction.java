package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.exception.ResultException;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.bean.PayInsideRecharge;
import com.xhb.pay.dto.PayInsideRechargeExportDTO;
import com.xhb.pay.service.PayInsideRechargeService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ReportTaskService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 内部客户充值记录表(PayInsideRecharge)表控制层
 *
 * @author makejava
 * @since 2019-05-23 19:13:09
 */
@RestController
@RequestMapping("/ms/pay_inside_recharge_r")
public class PayInsideRechargeRAction extends ModelSuperAction<PayInsideRecharge> {

    private static final Logger LOG = Logger.getLogger(PayInsideRechargeRAction.class);

    @Autowired
    private PayInsideRechargeService rechargeService;

    @Autowired
    private ReportTaskService reportTaskService;

    @Autowired
    private ParkParkingService parkParkingService;

    @Autowired
    private TransService transService;


    /**
     * 内部客户充值记录 分页 条件查询
     *
     * @param request  过滤条件：停车场，客户姓名，电话，车牌号，起止时间
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("findPageByRecharge")
    @RequiresPermissions("pay_inside_recharge_r:see")
    public Object findPageByRecharge(HttpServletRequest request, HttpServletResponse response) {
        //返回数据
        Map<String, Object> resultMap = new HashMap<String, Object>();
        //接受参数
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        if (DataPermissonContext.getDataPermissonMap() != null) {
            paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        }
        paramMap.put("sortTzwName", this.formartOrderBy(request));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        List<PayInsideRechargeExportDTO> dataList = rechargeService.findDateList(paramMap);
        List<PayInsideRecharge> payInsideRechargeList = new ArrayList<>();
        if (dataList.isEmpty()) {
            resultMap.put("total", 0);
            resultMap.put("rows", 0);
            //设置空
            resultMap.put("footer", payInsideRechargeList);
            return resultMap;
        }
        int count = rechargeService.findCount(paramMap);
        transService.transMore(dataList);
        //构建 总计
        PayInsideRecharge payInsideRecharge = rechargeService.findSum(paramMap);
        payInsideRecharge.setPlateNums("合计：");
        payInsideRechargeList.add(payInsideRecharge);
        resultMap.put("total", count);
        resultMap.put("rows", dataList);
        resultMap.put("footer", payInsideRechargeList);
        return resultMap;
    }

    /**
     * 内部客户充值记录导出
     *
     * @param request
     * @return
     */
    @RequestMapping("rechargeExportExcel")
    @RequiresPermissions("pay_inside_recharge_r:see")
    public HttpResult<Boolean> rechargeExportExcel(HttpServletRequest request) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        ParamChecker.isNotNullOrEmpty(paramMap.get("parkId"), "停车场为必选");
        paramMap.put("end", null);
        if (rechargeService.findCount(paramMap) <= 0) {
            throw new ResultException(new HttpResult(ReportTaskService.RESULT_STATUS, null, "没有相关数据，无法导出！"));
        }
        ParkParking parkParking = parkParkingService.findBeanById(paramMap.get("parkId"));
        StringBuffer excelName = new StringBuffer();
        excelName.append(super.getSessionuser(request).getUserName() + "-" + parkParking.getParkName());
        if (CheckUtils.isNotEmpty(paramMap.get("ownerName"))) {
            excelName.append("-客户姓名:" + paramMap.get("ownerName"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("ownerMobile"))) {
            excelName.append("-电话:" + paramMap.get("ownerMobile"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("plateNums"))) {
            excelName.append("-车牌号:" + paramMap.get("plateNums"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("createTimeMin"))) {
            excelName.append("-最小充值时间:" + paramMap.get("createTimeMin"));
        }
        if (CheckUtils.isNotEmpty(paramMap.get("createTimeMax"))) {
            excelName.append("-最大充值时间:" + paramMap.get("createTimeMax"));
        }
        //创建准备生成报表基本数据
        ReportTask reportTask = new ReportTask();
        reportTask.setParkId(ConverterUtils.toLong(paramMap.get("parkId")));
        reportTask.setReportName(excelName.toString());
        reportTask.setReportStatus(ReportTaskService.STATUS_GENERATING);
        reportTask.setReportType(ReportTaskService.PAYINSIDERECHARGE_EXPORT);
        reportTask.setGroupCode(super.getSessionuser(request).getGroupCode());
        reportTask.setParamMap(paramMap);
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        reportTask.setTimeDescribe(sf.format(new Date()).substring(0, 7));
        reportTask.preInsert(super.getSessionuser(request).getUserId());
        reportTaskService.submitReportTask(reportTask, rechargeService::makeReport);
        return HttpResult.success(true);
    }


}

