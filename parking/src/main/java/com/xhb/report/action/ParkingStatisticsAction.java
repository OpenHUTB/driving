package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.Logger;
import com.fhs.core.result.HttpResult;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.report.service.ParkingStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 停车统计
 */
@RestController
@RequestMapping("/ms/parkingStatistics")
public class ParkingStatisticsAction extends ModelSuperAction<ParkingStatisticsAction> {
    private static final Logger LOG = Logger.getLogger(ParkingStatisticsAction.class);
    @Autowired
    private ParkingStatisticsService parkingStatisticsService;


    /**
     * 获取停车时长折线图数据以及数据表单数据
     *
     * @return
     */
    @RequestMapping("/findCountData")
    public List<Map<String, Object>> findCountData(HttpServletRequest request, String dateFull, String typeF, Long parkIdImport) {
        String parkIds = DataPermissonContext.getDataPermissonMap().get("parkIds");
        String groupCode = super.getSessionuser(request).getGroupCode();
        return parkingStatisticsService.findCountData(dateFull, typeF, parkIdImport, parkIds, groupCode);
    }

    /**
     * 获取停车进出流量统计图数据
     *
     * @param dateFull     年月
     * @param parkIdImport 停车场id
     * @return
     */
    @RequestMapping("/findParkingFlows")
    public HttpResult<Map<String, Object>> findParkingFlows(HttpServletRequest request, String dateFull, Long parkIdImport) {
        String parkIds = DataPermissonContext.getDataPermissonMap().get("parkIds");
        String groupCode = super.getSessionuser(request).getGroupCode();
        return HttpResult.success(parkingStatisticsService.findParkingFlows(dateFull, parkIdImport, parkIds, groupCode));
    }

    /**
     * 获取车流与收入数据
     *
     * @param request
     * @param dateFull     月
     * @param parkIdImport 停车场id
     * @return
     */
    @RequestMapping("/findTrafficIncome")
    public HttpResult<Map<String, Object>> findTrafficIncome(HttpServletRequest request, String dateFull, Long parkIdImport) {
        String groupCode = super.getSessionuser(request).getGroupCode();
        String parkIds = DataPermissonContext.getDataPermissonMap().get("parkIds");
        try {
            return HttpResult.success(parkingStatisticsService.findTrafficIncome(dateFull, parkIdImport, groupCode, parkIds));
        } catch (ParseException e) {
            Map<String, Object> map = new HashMap<>();
            map.put("message", "请求异常请联系管理员");
            LOG.error(e.getMessage());
            return HttpResult.error(map);
        }
    }

}
