package com.xhb.report.service.impl;

import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.report.dao.BigScreenDao;
import com.xhb.report.service.HomeService;
import com.xhb.report.vo.ParkingReportVO;
import com.xhb.report.vo.ParkingVO;
import com.xhb.report.vo.ReportVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 首页报表接口实现类
 */
@Service
public class HomeServiceImpl implements HomeService {

    @Autowired
    private BigScreenDao bigScreenDao;


    /**
     * 今日泊位 首页用
     *
     * @return
     */
    @Override
    public List<ReportVO> berthTodaySimpleness(String groupCode) {
        String parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        Map<String, Object> map = bigScreenDao.berthTodaySimpleness(parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        for (String key : map.keySet( )) {
            reportVOS.add(ReportVO.builder().key(key).content(map.get(key)).build());
        }
        return reportVOS;
    }

    /**
     * 今日收费
     *
     * @return
     */
    @Override
    public List<ReportVO> chargeToday(String groupCode) {
        String parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        Map<String, Object> map = bigScreenDao.chargeToday(year, month, day,parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        for (String key : map.keySet( )) {
            reportVOS.add(ReportVO.builder().key(key).content(map.get(key)).build());
        }
        return reportVOS;
    }

    /**
     * 今日欠费
     *
     * @return
     */
    @Override
    public List<ReportVO> arrearsToday(String groupCode) {
        String parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        Map<String, Object> map = bigScreenDao.arrearsToday(new SimpleDateFormat("yyyyMMdd").format(new Date()),parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        for (String key : map.keySet( )) {
            reportVOS.add(ReportVO.builder().key(key).content(map.get(key)).build());
        }
        return reportVOS;
    }

}
