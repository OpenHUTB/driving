package com.xhb.report.action;

import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ListUtils;
import com.fhs.common.utils.StringUtil;
import com.fhs.core.base.action.BaseAction;
import com.fhs.core.result.HttpResult;
import com.fhs.ucenter.api.vo.SysUserVo;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import com.xhb.report.service.IndexReportService;
import com.xhb.report.vo.IndexReportParkComeLineVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 首页报表控制器
 */
@RestController
@RequestMapping("/ms/indexReport")
public class IndexReportAction extends BaseAction {

    @Autowired
    private IndexReportService indexReportService;

    @Autowired
    private ParkParkingService parkParkingService;

    /**
     * 首页停车场入场记录折线图
     *
     * @return
     */
    @RequestMapping("/lineData")
    public HttpResult<IndexReportParkComeLineVO> getIndexReportParkComeLineData(HttpServletRequest request) {
        String parkIds = DataPermissonContext.getDataPermissonMap().get("parkIds");
        parkIds = initParkIds(parkIds, request);
        //31代表一个月
        return HttpResult.success(indexReportService.getIndexReportParkComeLineVO(parkIds, 31));
    }

    /**
     * 初始化parkids
     *
     * @param parkIds session获取的
     * @param request request
     * @return 如果parkIds是null代表是管理员登录，则把这个groupcode所有的停车场id拿出来
     */
    private String initParkIds(String parkIds, HttpServletRequest request) {
        if (CheckUtils.isNullOrEmpty(parkIds)) {
            SysUserVo user = (SysUserVo) request.getSession().getAttribute("sessionUser");
            List<ParkParking> parkingList = parkParkingService.findForList(ParkParking.builder().groupCode(user.getGroupCode()).build());
            parkIds = StringUtil.getStrForIn(ListUtils.appendField(parkingList, "parkId"), true);
        }
        return parkIds;
    }

    /**
     * 首页各类信息统计
     *
     * @return
     */
    @RequestMapping("/findCountData")
    public HttpResult<Map<String, Object>> findCountData(HttpServletRequest request) {
        String parkIds = DataPermissonContext.getDataPermissonMap().get("parkIds");
        parkIds = initParkIds(parkIds, request);
        return HttpResult.success(indexReportService.findCountData(parkIds));
    }
}
