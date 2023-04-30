package com.xhb.report.service.impl;

import com.fhs.common.constant.Constant;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.JsonUtils;
import com.fhs.common.utils.Logger;
import com.xhb.business.dao.BusinessBalanceRechargeLogDao;
import com.xhb.business.dao.BusinessCashCouponDao;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.dao.ParkParkingDao;
import com.xhb.pay.dao.*;
import com.xhb.pay.dto.CarcomeCountDTO;
import com.xhb.pay.dto.FlowAnalyseDTO;
import com.xhb.pay.service.PayCarcomeService;
import com.xhb.report.bean.ReportTask;
import com.xhb.report.service.ParkMonthReportService;
import com.xhb.road.dao.PayAdvancePayOrderDao;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.*;

/**
 * OA 对接月报表
 *
 * @author yutao
 * @since 2019-09-28 09:22:11
 */
@Service
public class ParkMonthReportServiceImpl implements ParkMonthReportService, InitializingBean {

    private static Logger LOG = Logger.getLogger(ParkMonthReportServiceImpl.class);

    @Autowired
    private PayTempOrderDao payTempOrderDao;

    @Autowired
    private PayInsideContractDao payInsideContractDao;

    @Autowired
    private PayInsideRechargeDao payInsideRechargeDao;

    @Autowired
    private BusinessBalanceRechargeLogDao businessBalanceRechargeLogDao;

    @Autowired
    private PayHandLiftRodDao payHandLiftRodDao;

    @Autowired
    private PayCarcomeDao payCarcomeDao;

    @Autowired
    private BusinessCashCouponDao businessCashCouponDao;

    @Autowired
    private PayInsideCarDao payInsideCarDao;

    @Autowired
    private ParkParkingDao parkParkingDao;

    @Autowired
    private PayAdvancePayOrderDao payAdvancePayOrderDao;

    private Map<String, CountData> countDataMap = new HashMap<>();


    /**
     * 按照年月份，停车场查询: 总收入概况
     */
    public Map<String, Object> findIncomeInfo(Long parkId, String dateTime) {
        //天数
        int monthDays = getDaysByYearMonth(dateTime.substring(0, 4), dateTime.substring(5, 7));
        Map<String, Object> resultMap = new HashMap<>();
        //临停线上支付
        Map<String, Object> monthOnlineRevenueMap = payTempOrderDao.getMonthRevenueByOnline(parkId, dateTime, Constant.INT_TRUE);
        resultMap.put("monthOnlineRevenue", monthOnlineRevenueMap.get("amount"));
        //手动抬杆
        resultMap.put("monthRod", payHandLiftRodDao.getMonthRod(parkId, dateTime));
        //岗亭人工 = 临停线下 + 手动抬杆
        Map<String, Object> monthOnlineRevenueCashMap = payTempOrderDao.getMonthRevenueByOnline(parkId, dateTime, Constant.INT_FALSE);
        resultMap.put("monthRevenueCash", new BigDecimal(ConverterUtils.toDouble(monthOnlineRevenueCashMap.get("amount"))).add(new BigDecimal(ConverterUtils.toDouble(resultMap.get("monthRod")))).doubleValue());
        //临停合计 = 临停线上支付 + 岗亭人工 + 预支付
        resultMap.put("stopTotalAmount", new BigDecimal(ConverterUtils.toDouble(resultMap.get("monthOnlineRevenue")))
                .add(new BigDecimal(ConverterUtils.toDouble(resultMap.get("monthRevenueCash"))))
                .add(new BigDecimal(payAdvancePayOrderDao.getMonthAdvance(parkId, dateTime))).doubleValue());
        //日均临停收入 = 临停合计 / 天数
        resultMap.put("stopTotalAmountDays", new BigDecimal(ConverterUtils.toDouble(resultMap.get("stopTotalAmount"))).divide(new BigDecimal(monthDays), 2, RoundingMode.HALF_UP).doubleValue());
        //包月
        resultMap.put("monthCard", payInsideRechargeDao.getMonthRecharge(parkId, dateTime));
        //商户充值
        resultMap.put("monthMerchant", businessBalanceRechargeLogDao.getMonthMerchant(parkId, dateTime));
        //临停数量 = 临停线上支付订单 + 现金订单
        resultMap.put("stopTotalCount", ConverterUtils.toInt(monthOnlineRevenueMap.get("count")) + ConverterUtils.toInt(monthOnlineRevenueCashMap.get("count")));
        //日平均临停数量
        resultMap.put("stopTotalCountDays", ConverterUtils.toInt(resultMap.get("stopTotalCount")) / monthDays);
        //总合计 = 临停合计 + 包月  + 商户充值
        resultMap.put("totalAmount", new BigDecimal(ConverterUtils.toDouble(resultMap.get("stopTotalAmount")))
                .add(new BigDecimal(ConverterUtils.toDouble(resultMap.get("monthCard"))))
                .add(new BigDecimal(ConverterUtils.toDouble(resultMap.get("monthMerchant"))))
                .doubleValue());
        //新增内部客户
        resultMap.put("insideCarCount", payInsideCarDao.findInsideCarCount(parkId, dateTime));
        //临时订单产生的费用
        Double tempOrderSum = payTempOrderDao.findTempOrderPayActualAmountSum(parkId, dateTime) / monthDays;
        //包月每天产生的费用
        Double monthCarSum = payInsideContractDao.findDailyParameterCost(parkId, dateTime, monthDays);
        //每个车位产生费用 = (临时订单费用 + 包月) / 有效车位
        ParkParking parkParking = parkParkingDao.selectById(parkId);
        Integer parkingLot = parkParking != null ? parkParking.getSpaceCount() : 1;
        resultMap.put("parkingLot", parkingLot);
        resultMap.put("parkingLotCost", new BigDecimal(tempOrderSum).add(new BigDecimal(monthCarSum)).divide(new BigDecimal(parkingLot), 2, RoundingMode.HALF_UP).doubleValue());

        //以下都为上个月
        String lastMonth = getLastYearMonth(dateTime);
        //临停线上支付
        Map<String, Object> lastMonthOnlineRevenueMap = payTempOrderDao.getMonthRevenueByOnline(parkId, lastMonth, Constant.INT_FALSE);
        resultMap.put("lastMonthOnlineRevenue", lastMonthOnlineRevenueMap.get("amount"));
        //岗亭人工 = 临停线下 + 手动抬杆
        Map<String, Object> lastMonthRevenueCashMap = payTempOrderDao.getMonthRevenueByOnline(parkId, lastMonth, Constant.INT_FALSE);
        resultMap.put("lastMonthRevenueCash", new BigDecimal(ConverterUtils.toDouble(lastMonthRevenueCashMap.get("amount"))).add(new BigDecimal(payHandLiftRodDao.getMonthRod(parkId, lastMonth))).doubleValue());
        //临停合计 = 临停线上支付 + 岗亭人工 + 预支付
        resultMap.put("lastStopTotalAmount", new BigDecimal(ConverterUtils.toDouble(resultMap.get("lastMonthOnlineRevenue")))
                .add(new BigDecimal(ConverterUtils.toDouble(resultMap.get("lastMonthRevenueCash"))))
                .add(new BigDecimal(payAdvancePayOrderDao.getMonthAdvance(parkId, lastMonth))).doubleValue());
        //包月
        resultMap.put("lastMonthCard", payInsideRechargeDao.getMonthRecharge(parkId, lastMonth));
        //临停数量 = 临停线上支付订单 + 现金订单
        resultMap.put("lastStopTotalCount", ConverterUtils.toInt(lastMonthOnlineRevenueMap.get("count")) + ConverterUtils.toInt(lastMonthRevenueCashMap.get("count")));
        //日平均临停数量
        int lastMonthDays = getDaysByYearMonth(lastMonth.substring(0, 4), lastMonth.substring(5, 7));
        resultMap.put("lastStopTotalCountDays", ConverterUtils.toInt(resultMap.get("lastStopTotalCount")) / lastMonthDays);
        return resultMap;
    }

    /**
     * 根据 年、月 获取对应的月份 的 天数
     *
     * @param year  yyyy
     * @param month MM
     * @return
     */
    public static int getDaysByYearMonth(String year, String month) {
        Calendar a = Calendar.getInstance();
        a.set(Calendar.YEAR, Integer.parseInt(year));
        a.set(Calendar.MONTH, Integer.parseInt(month) - 1);
        a.set(Calendar.DATE, 1);
        a.roll(Calendar.DATE, -1);
        int maxDate = a.get(Calendar.DATE);
        return maxDate;
    }

    /**
     * 获取上一个月
     *
     * @param dateTime yyyy-MM
     * @return
     */
    public static String getLastYearMonth(String dateTime) {
        DateFormat format2 = new SimpleDateFormat("yyyy-MM");
        Date date = new Date();
        try {
            date = format2.parse(dateTime);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM");
        c.add(Calendar.MONTH, -1);
        String time = format.format(c.getTime());
        return time;
    }

    /**
     * 每日收入趋势 (应收，实收)
     */
    public List<Map<String, Object>> findEverydayIncome(Long parkId, String dateTime) {
        return payTempOrderDao.findEverydayIncome(parkId, dateTime, null);
    }

    /**
     * 临停收入趋势图（实收）
     */
    public Map<String, Double> findStopIncome(Long parkId, String dateTime) {
        Map<String, Double> resultMap = new TreeMap<String, Double>();
        //临停停车收入
        List<Map<String, Object>> networkOrderList = payTempOrderDao.findEverydayIncome(parkId, dateTime, 0);
        //手动抬杆
        List<Map<String, Object>> rodList = payHandLiftRodDao.geDaysRodByMonth(parkId, dateTime);
        //预付费
        List<Map<String, Object>> advanceList = payAdvancePayOrderDao.getDaysAdvanceByMonth(parkId, dateTime);
        //临停收入 = 临停停车收入 + 手动抬杆 + 预付费
        //循环存放数据
        for (Map<String, Object> stringObjectMap : networkOrderList) {
            resultMap.put(ConverterUtils.toString(stringObjectMap.get("date")), ConverterUtils.toDouble(stringObjectMap.get("actualAmount")));
        }
        return packageResult(advanceList, packageResult(rodList, resultMap));
    }

    //封装数据
    private Map<String, Double> packageResult(List<Map<String, Object>> listMap, Map<String, Double> resultMap) {
        for (Map<String, Object> stringObjectMap : listMap) {
            String date = ConverterUtils.toString(stringObjectMap.get("date"));
            Double amountTemp = ConverterUtils.toDouble(stringObjectMap.get("amount"));
            if (resultMap.containsKey(date)) {
                //更新金额
                amountTemp = new BigDecimal(amountTemp).add(new BigDecimal(resultMap.get(date))).doubleValue();
                resultMap.put(date, amountTemp);
            } else {
                resultMap.put(date, amountTemp);
            }
        }
        return resultMap;
    }

    /**
     * 交通流量分析（车次）
     */
    public List<FlowAnalyseDTO> findFlowAnalyse(Long parkId, String dateTime) {
        List<FlowAnalyseDTO> flowAnalyse = payCarcomeDao.findFlowAnalyse(parkId, dateTime);
        for (FlowAnalyseDTO flowAnalyseDTO : flowAnalyse) {
            flowAnalyseDTO.setTotalCarNum(flowAnalyseDTO.getTempCarNum() + flowAnalyseDTO.getMonthCarNum());
        }
        return flowAnalyse;
    }

    /**
     * 工作日及周末车流分析（按周统计）
     */
    public List<Map<String, Object>> findWorkAndWeekendFlowAnalyse(Long parkId, String dateTime) {
        return payCarcomeDao.findWorkAndWeekendFlowAnalyse(parkId, dateTime);
    }

    /**
     * 进出通道分析（进出场 数量统计）
     */
    public List<CarcomeCountDTO> findCarcomeCount(Long parkId, String dateTime) {
        return payCarcomeDao.findCarcomeCount(parkId, dateTime);
    }

    /**
     * 停车时长分析（24小时和大于24小时数量统计）
     */
    public Map<String, Object> findParkingTimeCount(Long parkId, String dateTime) {
        Map<String, Object> parkingTimeCount = payTempOrderDao.findParkingTimeCount(parkId, dateTime);
        if ("0".equals(parkingTimeCount.get("totalNumber").toString())) {
            parkingTimeCount = null;
        }
        return parkingTimeCount;
    }

    /**
     * 每天进出场车流高峰时段分析（进场数量 小时精度）
     */
    public List<Map<String, Object>> findHourCarcomeCountByEnter(Long parkId, String dateTime) {
        return payCarcomeDao.findHourCarcomeCountByType(parkId, dateTime, PayCarcomeService.TYPE_COME);
    }

    /**
     * 每天进出场车流高峰时段分析（出场数量 小时精度）
     */
    public List<Map<String, Object>> findHourCarcomeCountByOut(Long parkId, String dateTime) {
        return payCarcomeDao.findHourCarcomeCountByType(parkId, dateTime, PayCarcomeService.TYPE_OUT);
    }

    /**
     * 缴费方式 1 公众号  3 支付宝服务窗  10 现金
     */
    public List<Map<String, Object>> findTempOrderPayType(Long parkId, String dateTime) {
        return payTempOrderDao.findTempOrderPayType(parkId, dateTime, null);
    }

    /**
     * 缴费途径
     */
    public Map<String, Integer> findTempOrderPayChannel(Long parkId, String dateTime) {
        Map<String, Integer> resultMap = new HashMap<>();
        //现金，提前扫码，岗亭扫码，预付费。
        resultMap.put("现金", payTempOrderDao.findTempOrderPayCashCount(parkId, dateTime, null));
        resultMap.put("提前扫码", payTempOrderDao.findTempOrderPayAdvanceCode(parkId, dateTime, null));
        resultMap.put("岗亭扫码", payTempOrderDao.findTempOrderPayCode(parkId, dateTime, null));
        resultMap.put("预付费", payTempOrderDao.findTempOrderPayAdvance(parkId, dateTime, null));
        return resultMap;
    }

    /**
     * 优惠券减免分布 商户 + 减免分类
     */
    public List findCouponAndRelief(Long parkId, String dateTime) {
        List resultList = new ArrayList();
        Map<String, Double> resultMap = new HashMap<>();
        Double totalAmount = 0D;
        //商户名称+单价，金额
        List<Map<String, Object>> businessCashCouponcAmount = businessCashCouponDao.findBusinessCashCouponcAmount(parkId, dateTime);
        for (Map<String, Object> stringObjectMap : businessCashCouponcAmount) {
            totalAmount = new BigDecimal(totalAmount).add(new BigDecimal(ConverterUtils.toDouble(stringObjectMap.get("amount")))).doubleValue();
        }
        //减免分类名称+金额，金额
        List<Map<String, Object>> tempOrderPayDiscountAmount = payTempOrderDao.findTempOrderPayDiscountAmount(parkId, dateTime);
        for (Map<String, Object> stringObjectMap : tempOrderPayDiscountAmount) {
            totalAmount = new BigDecimal(totalAmount).add(new BigDecimal(ConverterUtils.toDouble(stringObjectMap.get("amount")))).doubleValue();
        }
        if (totalAmount == 0) {
            return resultList;
        }
        resultMap.put("totalAmount", totalAmount);
        resultList.add(resultMap);
        resultList.addAll(businessCashCouponcAmount);
        resultList.addAll(tempOrderPayDiscountAmount);
        return resultList;
    }

    @Override
    public String makeReportWord(ReportTask task) {
        //生成word 拿到id返回
        String fileId = null;
        try {
            //keng 地址写死
            fileId = doGet("http://192.168.0.121:8091/webApi/wordReport/monthlyReport?parkId=" + task.getParamMap().get("parkId") + "&date=" + task.getParamMap().get("dateTime"));
        } catch (Exception e) {
            LOG.error("OA报表生成失败:", e);
        }
        String data = JsonUtils.parseJSON2Map(fileId).get("data").toString();
        return data;
    }

    /**
     * httpClient远程调用接口
     *
     * @param url
     * @return
     * @throws IOException
     */
    private String doGet(String url) throws IOException {
        CloseableHttpClient httpclient = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet(url);
        RequestConfig requestConfig = RequestConfig.custom()
                .setConnectTimeout(60000).setConnectionRequestTimeout(60000)
                .setSocketTimeout(60000).build();
        httpGet.setConfig(requestConfig);
        CloseableHttpResponse response = httpclient.execute(httpGet);
        System.out.println("得到的结果:" + response.getStatusLine());//得到请求结果
        HttpEntity entity = response.getEntity();//得到请求回来的数据
        if (entity != null) {
            InputStream instream = entity.getContent();
            String result = IOUtils.toString(instream, "UTF-8");
            return result;
        }
        return null;


    }

    @Override
    public Map<String, Object> findCountData(Long parkId, String dateTime) {
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
                        result.put(countType, countDataMap.get(countType).findCount(parkId, dateTime));
                    } catch (Exception e) {
                        LOG.error("获取OA报表出错", e);
                    }
                    //每循环一次，调用countDown()方法，线程数减1
                    countDownLatch.countDown();
                }
            });
        }

        try {
            /**
             * 调用await()方法后，当所有的线程执行完毕后，再返还数据.
             */
            countDownLatch.await();
            if (!cachedThreadPool.isShutdown()) {
                cachedThreadPool.shutdown();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public void afterPropertiesSet() {
        countDataMap.put("findIncomeInfo", this::findIncomeInfo);
        countDataMap.put("findEverydayIncome", this::findEverydayIncome);
        countDataMap.put("findStopIncome", this::findStopIncome);
        countDataMap.put("findFlowAnalyse", this::findFlowAnalyse);
        countDataMap.put("findWorkAndWeekendFlowAnalyse", this::findWorkAndWeekendFlowAnalyse);
        countDataMap.put("findCarcomeCount", this::findCarcomeCount);
        countDataMap.put("findParkingTimeCount", this::findParkingTimeCount);
        countDataMap.put("findHourCarcomeCountByEnter", this::findHourCarcomeCountByEnter);
        countDataMap.put("findHourCarcomeCountByOut", this::findHourCarcomeCountByOut);
        countDataMap.put("findTempOrderPayType", this::findTempOrderPayType);
        countDataMap.put("findTempOrderPayChannel", this::findTempOrderPayChannel);
        countDataMap.put("findCouponAndRelief", this::findCouponAndRelief);
    }

    @FunctionalInterface
    interface CountData {
        /**
         * 获取报表数据
         *
         * @param parkId   停车场
         * @param dateTime
         * @return 数据
         */
        Object findCount(Long parkId, String dateTime);
    }
}
