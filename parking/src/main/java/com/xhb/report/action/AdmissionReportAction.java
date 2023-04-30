package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.result.HttpResult;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.report.dto.TempParkDTO;
import com.xhb.report.service.AdmissionReportService;
import com.xhb.report.vo.AdmissionReportParkComeLineVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 停车场出入场记录 报表控制器
 */
@RestController
@RequestMapping("/ms/admissionReport")
public class AdmissionReportAction extends ModelSuperAction<TempParkDTO> {

    @Autowired
    private AdmissionReportService admissionReportService;

    /**
     * 停车场出入场记录折线图
     * 按日期
     *
     * @param request
     * @return
     */
    @RequestMapping("/dateReport")
    public HttpResult<AdmissionReportParkComeLineVO> dateReport(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getParameterMap(request);
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        paramMap.put("groupCode", getSessionuser(request).getGroupCode());
        return HttpResult.success(admissionReportService.findCountDate(paramMap));
    }

    /**
     * 按天
     *
     * @param request
     * @return
     */
    @RequestMapping("/dayReport")
    public HttpResult<AdmissionReportParkComeLineVO> dayReport(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getParameterMap(request);
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        paramMap.put("groupCode", getSessionuser(request).getGroupCode());
        return HttpResult.success(admissionReportService.findCountDay(paramMap));
    }

    /**
     * 查询总数
     *
     * @param request
     * @return
     */
    @RequestMapping("/findOutEnterCount")
    public HttpResult<Map<String, Object>> findOutEnterCount(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getParameterMap(request);
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        paramMap.put("groupCode", getSessionuser(request).getGroupCode());
        return HttpResult.success(admissionReportService.findOutEnterCount(paramMap));
    }


}
