package com.xhb.report.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.utils.*;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.dao.ParkParkingDao;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.dao.PayCarcomeDao;
import com.xhb.pay.dao.PayGatewayOrderDao;
import com.xhb.pay.dao.PayMonthlyRecordDao;
import com.xhb.pay.dao.PayTempOrderDao;
import com.xhb.report.dao.IndexReportDao;
import com.xhb.report.service.IndexReportService;
import com.xhb.report.vo.IndexReportParkComeLineVO;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.*;

/**
 * 首页报表服务
 */
@Service
public class IndexReportServiceImpl implements IndexReportService, InitializingBean {

    private static Logger LOG = Logger.getLogger(IndexReportServiceImpl.class);

    @Autowired
    private IndexReportDao indexReportDao;

    @Autowired
    private ParkParkingService parkParkingService;

    @Autowired
    private PayTempOrderDao payTempOrderDao;    //临时订单表
    @Autowired
    private PayGatewayOrderDao payGatewayOrderDao; //网关支付订单表
    @Autowired
    private PayMonthlyRecordDao payMonthlyRecordDao; //月卡表
    @Autowired
    private ParkParkingDao parkParkingDao;  //停车场表
    @Autowired
    private PayCarcomeDao payCarcomeDao;    //进出信息表


    private Map<String, CountData> countDataMap = new HashMap<>();


    @Override
    public IndexReportParkComeLineVO getIndexReportParkComeLineVO(String parkIds, int preDays) {
        Date today = new Date();
        Date preDay = DateUtils.getSpecifiedNDayBefore(today, preDays);
        // key parkid val=>map  key 日期  val 进场记录数
        Map<String, Map<String, Integer>> parkIdCountInfo = new HashMap<>();
        List<Map<String, Object>> parkIdComeCountList = indexReportDao.getParkIncomeCountList(parkIds, DateUtils.formartDate(preDay, DateUtils.DATETIME_PATTERN_DATE), DateUtils.formartDate(today, DateUtils.DATETIME_PATTERN_DATE));
        //每一条包含parkid，日期，进场车辆 三个字段
        for (Map<String, Object> countInifoMap : parkIdComeCountList) {
            if (!parkIdCountInfo.containsKey(countInifoMap.get("park_id"))) {
                parkIdCountInfo.put(ConverterUtils.toString(countInifoMap.get("park_id")), new HashMap<>());
            }
            parkIdCountInfo.get(countInifoMap.get("park_id")).put(ConverterUtils.toString(countInifoMap.get("days")), ConverterUtils.toInt(countInifoMap.get("countNumber")));
        }
        LambdaQueryWrapper<ParkParking> wrapper = new LambdaQueryWrapper();
        if (parkIds != null) {
            wrapper.in(ParkParking::getParkId, parkIds.replace("'", "").split(","));
        }
        List<ParkParking> parkParkingList = parkParkingService.selectListMP(wrapper);
        List<String> days = DateUtils.getBeforeDateStrByHowDays(preDays);
        List<IndexReportParkComeLineVO.OneParkData> parkDataList = new ArrayList<>();
        for (ParkParking park : parkParkingList) {
            Map<String, Integer> parkCountMap = parkIdCountInfo.get(park.getParkId());
            IndexReportParkComeLineVO.OneParkData oneParkData = new IndexReportParkComeLineVO.OneParkData();
            oneParkData.name = park.getParkName();
            List<Integer> dayCountDataList = new ArrayList<>();
            if (parkCountMap == null) {
                parkCountMap = new HashMap<>();
            }
            for (String day : days) {
                dayCountDataList.add(parkCountMap.containsKey(day) ? parkCountMap.get(day) : 0);
            }
            oneParkData.data = dayCountDataList;
            parkDataList.add(oneParkData);
        }
        IndexReportParkComeLineVO result = new IndexReportParkComeLineVO();
        result.setParkNameList(ListUtils.appendField(parkParkingList, "parkName"));
        result.setParkDataList(parkDataList);
        result.setDateList(days);
        return result;
    }

    @Override
    public Map<String, Object> findCountData(String parkIds) {
        //创建一个线程池并指定线程个数
        ExecutorService cachedThreadPool = Executors.newFixedThreadPool(countDataMap.size());
        final CountDownLatch countDownLatch = new CountDownLatch(countDataMap.size());
        final Map<String, Object> result = new ConcurrentHashMap<>();
        /**
         * 创建13个线程，使用多线程查询数据库
         */
        for (String countType : countDataMap.keySet()) {

            cachedThreadPool.submit(new Runnable() {
                @Override
                public void run() {
                    try {
                        result.put(countType, countDataMap.get(countType).findCount(parkIds));
                    } catch (Exception e) {
                        LOG.error("统计首页报表出错", e);
                    }
                    //每循环一次，调用countDown()方法，线程数减1
                    countDownLatch.countDown();
                }
            });
        }

        try {
            /**
             * 调用await()方法后，当所有的线程执行完毕后，再返还数据
             */
            countDownLatch.await(10, TimeUnit.SECONDS);
            if (!cachedThreadPool.isShutdown()) {
                cachedThreadPool.shutdown();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public void afterPropertiesSet() throws Exception {

        //获取今日临时订单数
        countDataMap.put("todayTempOrderTotal", payTempOrderDao::findTodayTempOrderCount);
        //获取临时订单数
        countDataMap.put("tempOrderTotal", payTempOrderDao::findTempOrderCount);
        //获得网关支付总金额
        countDataMap.put("moneyTotal", payGatewayOrderDao::findSettlementAmountCount);
        //获得今日网关支付金额
        countDataMap.put("todayMoneyTotal", payGatewayOrderDao::findTodaySettlementAmountCount);
        //获取今日网关支付订单数量
        countDataMap.put("todayGatewayOrderTotal", payGatewayOrderDao::findTodayOrderCount);
        //获得总的网关支付定单数量
        countDataMap.put("gatewayOrderTotal", payGatewayOrderDao::findOrderCount);
        //获得今日新增月卡数量
        countDataMap.put("todayMonthlyTotal", payMonthlyRecordDao::findTodayMonthlyCount);
        //获得月卡数量信息总数
        countDataMap.put("monthlyTotal", payMonthlyRecordDao::findMonthlyCount);
        //获得停车场数量
        countDataMap.put("parkingTotal", this::parkCount);
        //今日出场
        countDataMap.put("todayAppearance", this::todayOutCount);
        //今日入场
        countDataMap.put("todayAdmission", this::todayEnterCount);
        //总入场
        countDataMap.put("admission", this::enterCount);
        //总出场
        countDataMap.put("appearance", this::outCount);
    }

    /**
     * 今日出场记录总数
     *
     * @param parkIds 停车场ids
     * @return 今日出场记录总数
     */
    private Number todayOutCount(String parkIds) {
        return payCarcomeDao.findByTypeAndTimeCount(1, parkIds);
    }

    /**
     * 今日入场记录总数
     *
     * @param parkIds 停车场ids
     * @return 今日入场记录总数
     */
    private Number todayEnterCount(String parkIds) {
        return payCarcomeDao.findByTypeAndTimeCount(0, parkIds);
    }

    /**
     * 出场信息
     *
     * @param parkIds 停车场ids
     * @return 出场信息
     */
    private Number outCount(String parkIds) {
        return payCarcomeDao.findByTypeCount(1, parkIds);
    }

    /**
     * 入场信息
     *
     * @param parkIds 停车场ids
     * @return 入场信息
     */
    private Number enterCount(String parkIds) {
        return payCarcomeDao.findByTypeCount(0, parkIds);
    }

    /**
     * 停车场总数
     *
     * @param parkIds 停车场ids
     * @return 入场信息
     */
    private Number parkCount(String parkIds) {
        if (CheckUtils.isNullOrEmpty(parkIds)) {
            return parkParkingDao.selectCountJpa(ParkParking.builder().build());
        }
        LambdaQueryWrapper<ParkParking> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(ParkParking::getParkId, parkIds.replace("'", "").split(","));
        return parkParkingDao.selectCount(queryWrapper);
    }


}

@FunctionalInterface
interface CountData {
    /**
     * 根据停车场id统计数据
     *
     * @param parkIds 停车场ids
     * @return 数据
     */
    Number findCount(String parkIds);
}
