package com.xhb.report.action;

import com.fhs.core.result.HttpResult;
import com.fhs.ucenter.api.vo.SysUserVo;
import com.xhb.report.service.BigScreenService;
import com.xhb.report.vo.DateReportVO;
import com.xhb.report.vo.ParkingReportVO;
import com.xhb.report.vo.ParkingVO;
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
 * 大屏报表 控制层
 */
@RestController
@Api(tags = "大屏统计图")
@RequestMapping("/ms/bigScreen")
public class BigScreenAction {

    @Autowired
    private BigScreenService bigScreenService;

    /**
     * 车位使用情况
     *
     * @return
     */
    @ApiOperation("车位情况")
    @GetMapping("/parkingSpaceUsage")
    public HttpResult<ParkingReportVO> parkingSpaceUsage(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.parkingSpaceUsage(groupCode));
    }

    /**
     * 车位使用情况
     *
     * @return
     */
    @ApiOperation("停车场地图")
    @GetMapping("/parkingSpaceUsageMap")
    public HttpResult<ParkingReportVO> parkingSpaceUsageMap(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.parkingSpaceUsageMap(groupCode));
    }

    /**
     * 订单与金额
     *
     * @return
     */
    @ApiOperation("订单与金额")
    @GetMapping("/paymentStatistics")
    public HttpResult<List<ReportVO>> paymentStatistics(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.paymentStatistics(groupCode));
    }

    /**
     * 今日泊位（大屏）
     *
     * @return
     */
    @ApiOperation("今日泊位（大屏）")
    @GetMapping("/berthToday")
    public HttpResult<List<ReportVO>> berthToday(HttpServletRequest request) {
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.berthToday(groupCode));
    }

    /**
     * 今日支付方式
     * @return
     */
    @ApiOperation("今日支付方式")
    @GetMapping("/howToPayToday")
    public HttpResult<List<ReportVO>> howToPayToday(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.howToPayToday(groupCode));
    }

    /**
     * 用户报表
     * @return
     */
    @ApiOperation("用户报表")
    @GetMapping("/userReport")
    public HttpResult<List<ReportVO>> userAndVehicle(){
        return HttpResult.success(bigScreenService.userReport());
    }

    /**
     * 今天停车时长
     * @return
     */
    @ApiOperation("今天停车时长")
    @GetMapping("/parkingTimeToday")
    public HttpResult<List<ReportVO>> parkingTimeToday(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.parkingTimeToday(groupCode));
    }

    /**
     * 实时入场
     * @return
     */
    @ApiOperation("实时入场")
    @GetMapping("/liveAdmission")
    public HttpResult<List<ParkingVO>> liveAdmission(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.liveAdmission(groupCode));
    }

    /**
     * 今日交易额TOP5
     * @return
     */
    @ApiOperation("今日交易额TOP5")
    @GetMapping("/todaySTradingVolumeTOP5")
    public HttpResult<List<ParkingVO>> todaySTradingVolumeTOP5(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.todaySTradingVolumeTOP5(groupCode));
    }

    /**
     * 今日订单TOP5
     * @return
     */
    @ApiOperation("今日订单TOP5")
    @GetMapping("/todaySOrderTOP5")
    public HttpResult<List<ParkingVO>> todaySOrderTOP5(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.todaySOrderTOP5(groupCode));
    }

    /**
     * 今日车流量
     * @return
     */
    @ApiOperation("今日车流量")
    @GetMapping("/trafficFlowToday")
    public HttpResult<List<DateReportVO>> trafficFlowToday(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.trafficFlowToday(groupCode));
    }

    /**
     * 支付时间分布
     * @return
     */
    @ApiOperation("支付时间分布")
    @GetMapping("/paymentTimeDistribution")
    public HttpResult<List<DateReportVO>> paymentTimeDistribution(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.paymentTimeDistribution(groupCode));
    }
    /**
     * 泊位使用率
     * @return
     */
    @ApiOperation("泊位使用率")
    @GetMapping("/berthUtilization")
    public HttpResult<List<DateReportVO>> berthUtilization(HttpServletRequest request){
        String groupCode = ((SysUserVo)request.getSession().getAttribute("sessionUser")).getGroupCode();
        return HttpResult.success(bigScreenService.berthUtilization(groupCode));
    }

}
