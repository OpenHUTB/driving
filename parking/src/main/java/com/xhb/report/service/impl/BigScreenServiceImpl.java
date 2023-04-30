package com.xhb.report.service.impl;

import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.DateUtils;
import com.fhs.ucenter.api.vo.SysUserVo;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.report.dao.BigScreenDao;
import com.xhb.report.service.BigScreenService;
import com.xhb.report.vo.DateReportVO;
import com.xhb.report.vo.ParkingReportVO;
import com.xhb.report.vo.ParkingVO;
import com.xhb.report.vo.ReportVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisConnectionUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * 大屏报表接口实现类
 */
@Service
public class BigScreenServiceImpl implements BigScreenService {

    @Autowired
    private BigScreenDao bigScreenDao;
    @Autowired
    private RedisTemplate redisTemplate;
    private final String BERTH = "berth";

    /**
     * 停车场地图
     *
     * @return
     */
    @Override
    public ParkingReportVO parkingSpaceUsageMap(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }

        ParkingReportVO parkingReportVO = bigScreenDao.parkingSpaceUsageCount(parkIds,groupCode);
        parkingReportVO.setParkingList(bigScreenDao.parkingSpaceUsageList(parkIds));
        return parkingReportVO;
    }

    /**
     * 车厂车位情况
     *
     * @return
     */
    @Override
    public ParkingReportVO parkingSpaceUsage(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        return bigScreenDao.parkingSpaceUsageCount(parkIds,groupCode);
    }

    /***
     * 订单笔数
     * @return
     */
    @Override
    public List<ReportVO> paymentStatistics(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        Map<String, Object> map = bigScreenDao.paymentStatistics(year, month, day, parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        map.keySet( ).forEach(key -> reportVOS.add(ReportVO.builder( ).key(key).content(map.get(key)).build( )));
        return reportVOS;
    }

    /**
     * 今日泊位
     *
     * @return
     */
    @Override
    public List<ReportVO> berthToday(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        Map<String, Object> map = bigScreenDao.berthToday(year, month, day, parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        map.keySet( ).forEach(key -> reportVOS.add(ReportVO.builder( ).key(key).content(map.get(key)).build( )));
        return reportVOS;
    }

    /**
     * 今日支付方式
     *
     * @return
     */
    @Override
    public List<ReportVO> howToPayToday(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        Map<String, Object> map = bigScreenDao.howToPayToday(year, month, day, parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        map.keySet( ).forEach(key -> reportVOS.add(ReportVO.builder( ).key(key).content(map.get(key)).build( )));
        return reportVOS;
    }

    /**
     * 用户报表
     *
     * @return
     */
    @Override
    public List<ReportVO> userReport() {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        Map<String, Object> userReport = bigScreenDao.userReport(year, month, day, new SimpleDateFormat("yyyy-MM-dd").format(instance.getTime( )), parkIds);
        Map<String, Object> admissionToday = bigScreenDao.admissionToday(year, month, day, parkIds);
        List<ReportVO> reportVOS = new ArrayList<>( );

        userReport.keySet( ).forEach(key -> reportVOS.add(ReportVO.builder( ).key(key).content(userReport.get(key)).build( )));
        admissionToday.keySet( ).forEach(key -> reportVOS.add(ReportVO.builder( ).key(key).content(admissionToday.get(key)).build( )));
        return reportVOS;
    }

    /**
     * 实时入场
     *
     * @return
     */
    @Override
    public List<ParkingVO> liveAdmission(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        return bigScreenDao.liveAdmission(year, month, day, parkIds,groupCode);
    }


    /**
     * 今日交易额TOP5
     *
     * @return
     */
    @Override
    public List<ParkingVO> todaySTradingVolumeTOP5(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        double max = 0l;
        List<ParkingVO> parkingVOS = bigScreenDao.todaySTradingVolumeTOP5(year, month, day, parkIds,groupCode);
        if (parkingVOS.size( ) > 1) {
            max = Double.parseDouble(parkingVOS.get(0).getValue( ));
        }
        double finalMax = max;
        parkingVOS.forEach(vo -> vo.setDayMax(finalMax));
        return parkingVOS;
    }

    /**
     * 今日停车时长
     *
     * @return
     */
    @Override
    public List<ReportVO> parkingTimeToday(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        Map<String, Object> map = bigScreenDao.parkingTimeToday(year, month, day, parkIds,groupCode);
        List<ReportVO> reportVOS = new ArrayList<>( );
        if (CheckUtils.isNotEmpty(map)) {
            map.keySet( ).forEach(key -> reportVOS.add(ReportVO.builder( ).key(key).content(map.get(key)).build( )));
        }
        return reportVOS;
    }

    /**
     * 今日订单TOP5
     *
     * @return
     */
    @Override
    public List<ParkingVO> todaySOrderTOP5(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        return bigScreenDao.todaySOrderTOP5(year, month, day, parkIds,groupCode);
    }

    /**
     * 今日车流量
     *
     * @return
     */
    @Override
    public List<DateReportVO> trafficFlowToday(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        int hour = instance.get(Calendar.HOUR_OF_DAY);
        List<DateReportVO> dateReportVOS = bigScreenDao.trafficFlowToday(year, month, day, parkIds,groupCode);
        return dateReportVOS.subList(0, hour);
    }


    /**
     * 付款时间分布
     *
     * @return
     */
    @Override
    public List<DateReportVO> paymentTimeDistribution(String groupCode) {
        String parkIds = null;
        if (DataPermissonContext.getDataPermissonMap( ) != null) {
            parkIds = DataPermissonContext.getDataPermissonMap( ).get("parkIds");
        }
        Calendar instance = Calendar.getInstance( );
        int year = instance.get(Calendar.YEAR);
        int month = instance.get(Calendar.MONTH) + 1;
        int day = instance.get(Calendar.DATE);
        return bigScreenDao.paymentTimeDistribution(year, month, day, parkIds,groupCode);
    }

    /**
     * 泊位使用率
     *
     * @return
     */
    @Override
    public List<DateReportVO> berthUtilization(String groupCode) {
        Map<Integer, Map<Object, Map<String, Object>>> hourMap = redisTemplate.opsForHash( ).entries(BERTH); //redis中取出的值   key 是小时
        if (hourMap == null || hourMap.size( ) == 0) {
            return null;
        }
        List<DateReportVO> resultList = new ArrayList<>( );     //返回前端的结果集
        Map<Integer, Map<String, Object>> resultMap = new HashMap<>( );      //可以转换为 返回前端的结果集list的map
        Map<String, String> dataPermissonMap = DataPermissonContext.getDataPermissonMap( );
        String parkIds = null;
        if (dataPermissonMap != null) {
            parkIds = dataPermissonMap.get("parkIds");
            if (parkIds != null) {            //如果请求者的 停车场ID不等于空
                int nwoHour = Calendar.getInstance( ).get(Calendar.HOUR_OF_DAY);
                for (Integer hour : hourMap.keySet( )) {        //取出每个时间段的map
                    if (hour < nwoHour) {
                        Map<Object, Map<String, Object>> parkIdMap = hourMap.get(hour);  //pokeIdMap存放的是这个小时中的 所有的停车场的数据， key是停车场id
                        if (!resultMap.containsKey(hour)) {               //为防止空指针先进行判断
                            Map<String, Object> sumMap = new HashMap<>( );      //这个map用于计算该时间的各单位的车位和占有率之和
                            sumMap.put("count", "0");
                            sumMap.put("re", "0");
                            resultMap.put(hour, sumMap);        //没有的话创建一个空的
                        }
                        for (String id : parkIds.split(",")) {
                            if (parkIdMap.containsKey(id)) {         //判断map中是否有这个停车场的数据，没有的话掠过下一轮
                                Map<String, Object> valueMap = parkIdMap.get(id);//有的话取出来进行计算
                                Map<String, Object> sumMap = resultMap.get(hour);
                                Long re = Long.parseLong(sumMap.get("re").toString( )) + Long.parseLong(valueMap.get("re").toString( ));
                                Long count = Long.parseLong(sumMap.get("count").toString( )) + (Long) valueMap.get("count");
                                sumMap.put("re", re);
                                sumMap.put("count", count);
                            }
                        }
                        String division = null;
                        Map<String, Object> sumMap = resultMap.get(hour);//取出这个小时的进行总和计算
                        Integer re = Integer.valueOf(sumMap.get("re").toString());
                        Integer count = Integer.valueOf(sumMap.get("count").toString());
                        if (count == 0){
                            division = "0.00";
                        }else {
                            division = division(re,count,"%.4f");
                        }
                        resultList.add(DateReportVO.builder( ).hour(hour).proportion(division).build( ));
                    }
                }
                Collections.sort(resultList);
                return resultList;

            } else {      //
                int nwoHour = Calendar.getInstance( ).get(Calendar.HOUR_OF_DAY);
                for (Integer hour : hourMap.keySet( )) {        //取出每个时间段的map
                    if (hour < nwoHour) {
                        Map<Object, Map<String, Object>> parkIdMap = hourMap.get(hour);  //pokeIdMap存放的是这个小时中的 所有的停车场的数据， key是停车场id
                        if (!resultMap.containsKey(hour)) {               //为防止空指针先进行判断
                            Map<String, Object> sumMap = new HashMap<>( );      //这个map用于计算该时间的各单位的车位和占有率之和
                            sumMap.put("count", "0");
                            sumMap.put("re", "0");
                            resultMap.put(hour, sumMap);        //没有的话创建一个空的
                        }
                        for (Object id : parkIdMap.keySet( )) {
                            Map<String, Object> valueMap = parkIdMap.get(id); //计算所有
                            Map<String, Object> sumMap = resultMap.get(hour);
                            Long re = Long.parseLong(sumMap.get("re").toString( )) + Long.parseLong(valueMap.get("re").toString( ));
                            Long count = Long.parseLong(sumMap.get("count").toString( )) + (Long) valueMap.get("count");
                            sumMap.put("re", re);
                            sumMap.put("count", count);
                        }
                        String division = null;
                        Map<String, Object> sumMap = resultMap.get(hour);//取出这个小时的进行总和计算
                        Integer re = Integer.valueOf(sumMap.get("re").toString());
                        Integer count = Integer.valueOf(sumMap.get("count").toString());
                        if (count == 0){
                            division = "0.00";
                        }else {
                            division = division(re,count,"%.4f");
                        }
                        resultList.add(DateReportVO.builder( ).hour(hour).proportion(division).build());
                    }
                }
                Collections.sort(resultList);
                return resultList;
            }
        }
        return null;
    }
    public String division(int v1, int v2, String  scale) {
        Double aFloat = (Double.valueOf(String.format(scale, ((double) v1 / v2))))*100;
        if (aFloat.toString().length()>5){
            return aFloat.toString().substring(0,5);
        }
        return String.valueOf(aFloat);

    }


    /**
     * 记录当前时间泊位使用率
     *
     * @return
     */
    @Scheduled(cron = "0 0 */1 * * ?")
    public void recordBerth() {
        Calendar instance = Calendar.getInstance( );
        int hour = instance.get(Calendar.HOUR_OF_DAY);
        List<Map<String, Object>> hourList = bigScreenDao.recordBerth();
        Map<Object, Map<String, Object>> pakeMap = new HashMap<>( );
        hourList.forEach(map -> pakeMap.put(map.get("id"), map));
        redisTemplate.opsForHash( ).put(BERTH, hour, pakeMap);
        redisTemplate.expire(BERTH, 1, TimeUnit.DAYS);
    }

}
