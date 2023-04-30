package com.xhb.report.action;

import com.fhs.core.result.HttpResult;
import com.fhs.ucenter.api.vo.SysUserVo;
import com.xhb.report.service.HomeService;
import com.xhb.report.vo.ReportVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 首页统计图 控制层
 */
@RestController
@Api(tags = "首页统计图")
@RequestMapping("/ms/home")
public class HomeAction{

    @Autowired
    private HomeService homeService;


    /**
     * 今日泊位（首页）
     *
     * @return
     */
    @ApiOperation("今日泊位（首页）")
    @GetMapping("/berthTodaySimpleness")
    public HttpResult<List<ReportVO>> berthTodaySimpleness(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(homeService.berthTodaySimpleness(groupCode));
    }

    /**
     * 今日收费
     *
     * @return
     */
    @ApiOperation("今日收费")
    @GetMapping("/chargeToday")
    public HttpResult<List<ReportVO>> chargeToday(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(homeService.chargeToday(groupCode));
    }


    /**
     * 今日欠费
     *
     * @return
     */
    @ApiOperation("今日欠费")
    @GetMapping("/arrearsToday")
    public HttpResult<List<ReportVO>> arrearsToday(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(homeService.arrearsToday(groupCode));
    }


}
