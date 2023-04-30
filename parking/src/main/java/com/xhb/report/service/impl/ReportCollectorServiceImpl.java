package com.xhb.report.service.impl;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.DateUtils;
import com.fhs.common.utils.StringUtil;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import com.xhb.report.bean.ReportCollectorReport;
import com.xhb.report.service.ReportCollectorReportService;
import com.xhb.report.service.TollCollectorReportService;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * <per>
 * 开机启动任务，查询并插入收费员信息
 *
 * @author wangjie
 * @Date 2019/6/18 18:20
 * </per>
 */
@Service
@DependsOn("persistentEnhancerScaner")
public class ReportCollectorServiceImpl implements ApplicationListener<ApplicationReadyEvent> {


    @Autowired
    private ParkParkingService parkParkingService;

    @Autowired
    private ReportCollectorReportService reportCollectorReportService;

    @Autowired
    private TollCollectorReportService tollCollectorReportService;


    /**
     * 获取收费人员信息
     */
    public void reportCollector() {
        List<ParkParking> parkParkingList = parkParkingService.select();
        for (ParkParking parkParking : parkParkingList) {
            LambdaQueryWrapper<ReportCollectorReport> wrapper = new LambdaQueryWrapper();
            wrapper.eq(ReportCollectorReport::getParkId, parkParking.getParkId());
            if (reportCollectorReportService.selectListMP(wrapper).size() == 0) {
                String startTime = tollCollectorReportService.selectMinDate(parkParking.getParkId());
                List<String> reportDateList = null;
                if (CheckUtils.isNotEmpty(startTime)) {
                    reportDateList = getDays(startTime, DateUtils.formartDate(new Date(), DateUtils.DATETIME_PATTERN_DATE));
                    for (String s : reportDateList) {
                        tollCollectorReportService.insertCollectorReport(s, parkParking.getParkId());
                    }
                }
            }
        }
    }

    /**
     * 返回日期集合
     *
     * @param startTime
     * @param endTime
     * @return
     */
    public static List<String> getDays(String startTime, String endTime) {

        // 返回的日期集合
        List<String> days = new ArrayList<String>();
        DateFormat dateFormat = new SimpleDateFormat(DateUtils.DATETIME_PATTERN_DATE);
        try {
            Date start = dateFormat.parse(startTime);
            Date end = dateFormat.parse(endTime);
            Calendar tempStart = Calendar.getInstance();
            tempStart.setTime(start);
            Calendar tempEnd = Calendar.getInstance();
            tempEnd.setTime(end);
            tempEnd.add(Calendar.DATE, +1);// 日期加1(包含结束)
            while (tempStart.before(tempEnd)) {
                days.add(dateFormat.format(tempStart.getTime()));
                tempStart.add(Calendar.DAY_OF_YEAR, 1);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return days;
    }


    @Override
    public void onApplicationEvent(ApplicationReadyEvent applicationReadyEvent) {
       // 暂时没用
       /* new Thread(() -> {
            this.reportCollector();
        }).start();*/
    }
}
