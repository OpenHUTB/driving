package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.ExcelExportTools;
import com.fhs.common.utils.Logger;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.report.dto.UnattendedDTO;
import com.xhb.report.service.UnattendedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 未出场车辆报表
 */
@RestController
@RequestMapping("/ms/unattendedsAction")
public class UnattendedsAction extends ModelSuperAction<UnattendedsAction> {

    private static final Logger LOG = Logger.getLogger(UnattendedsAction.class);

    @Autowired
    private UnattendedService unattendedService;

    @Autowired
    private TransService transService;

    /**
     * 未出场车辆统计
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/findUnattended")
    public Pager<UnattendedDTO> findUnattended(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        List<UnattendedDTO> rows = unattendedService.findUnattended(paramMap);
        transService.transMore(rows);
        paramMap.put("end", null);
        int total = unattendedService.findUnattended(paramMap).size();
        return new Pager<>(total, rows);
    }

    /**
     * 把选中行，修改为已支付
     *
     * @param unattendedDTO 停车场ID，车牌号，accessTime（入场时间）
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/carOut")
    public HttpResult<Boolean> carOut(UnattendedDTO unattendedDTO, HttpServletRequest request, HttpServletResponse response) {
        unattendedService.carOut(unattendedDTO);
        return HttpResult.success(true);
    }

    @RequestMapping({"exportReportExcel"})
    public void exportReportExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        paramMap.remove("start");
        paramMap.remove("end");
        List<UnattendedDTO> dataList = unattendedService.findUnattended(paramMap);
        transService.transMore(dataList);
        ExcelExportTools.exportExcel(dataList, request, response);
    }

}
