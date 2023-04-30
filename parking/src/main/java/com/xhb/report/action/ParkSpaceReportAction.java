package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.result.HttpResult;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkSpace;
import com.xhb.park.service.ParkSpaceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ms/parkSpaceReport")
/**
 * 已使用车位和未使用车位统计
 */
public class ParkSpaceReportAction extends ModelSuperAction<ParkSpace> {

    @Autowired
    private ParkSpaceService parkSpaceService;

    /**
     * 查询车位的使用情况数量 饼状图
     */
    @RequestMapping("/findParkingSpaceNum")
    public HttpResult<List<ParkSpace>> findParkingSpaceNum(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getParameterMap(request);
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        paramMap.put("groupCode", getSessionuser(request).getGroupCode());
        return HttpResult.success(parkSpaceService.findParkingSpaceNum(paramMap));
    }
}
