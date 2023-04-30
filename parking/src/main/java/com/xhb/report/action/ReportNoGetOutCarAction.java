package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.ExcelExportTools;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.report.bean.ReportNoGetOutCar;
import com.xhb.report.service.ReportNoGetOutCarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * @Author: Jun
 * @Description: 未出场车辆
 * @Date: 2020-01-17 15:56
 */

@RestController
@RequestMapping("/ms/noGetOutCar")
public class ReportNoGetOutCarAction extends ModelSuperAction<ReportNoGetOutCar> {

    @Autowired
    private ReportNoGetOutCarService noGetOutCarService;

    @Autowired
    private TransService transService;

    /**
     * 未出场车辆统计
     *
     * @param request
     * @return
     */
    @RequestMapping("/getNoOutCarList")
    public Pager<ReportNoGetOutCar> getNoOutCarList(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        List<ReportNoGetOutCar> rows = noGetOutCarService.findNoOutCar(paramMap);
        transService.transMore(rows);
        int total = noGetOutCarService.findNoOutCarCount(paramMap);
        return new Pager<>(total, rows);
    }

    /**
     * 未出场车辆标记出场
     *
     * @return
     */
    @RequestMapping("/carOut")
    public HttpResult<Boolean> carOut(ReportNoGetOutCar noGetOutCar) {
        return HttpResult.success(noGetOutCarService.carOut(noGetOutCar));
    }

    /**
     * 未出场车辆excel导出
     */

    @RequestMapping({"exportReportExcel"})
    public void exportReportExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        paramMap.remove("start");
        paramMap.remove("end");
        List<ReportNoGetOutCar> dataList = noGetOutCarService.findNoOutCar(paramMap);
        transService.transMore(dataList);
        ExcelExportTools.exportExcel(dataList, request, response);
    }


}
