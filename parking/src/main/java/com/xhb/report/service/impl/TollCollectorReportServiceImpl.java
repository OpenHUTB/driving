package com.xhb.report.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.utils.DateUtils;
import com.fhs.common.utils.IdHelper;
import com.fhs.common.utils.NumberUtil;
import com.fhs.common.utils.StringUtil;
import com.xhb.report.bean.ReportCollectorReport;
import com.xhb.report.dao.TollCollectorReportDao;
import com.xhb.report.service.ReportCollectorReportService;
import com.xhb.report.service.TollCollectorReportService;
import com.xhb.report.vo.DailyReportVo;
import com.xhb.report.vo.TollCollectorReportVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 收费员线下收费报表
 */
@Service
public class TollCollectorReportServiceImpl implements TollCollectorReportService {

    @Autowired
    private TollCollectorReportDao tollCollectorReportDao;

    @Autowired
    private ReportCollectorReportService reportCollectorReportService;

    @Autowired
    private IdHelper idHelper;

    /**
     * 收费员线下收费报表数据分页查询
     *
     * @param paramMap
     * @return
     */

    @Override
    public List<TollCollectorReportVo> findListData(Map<String, Object> paramMap) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
        if (paramMap.get("payTimeMin") != null && !(paramMap.get("payTimeMin").equals(""))){
            String payTimeMin = paramMap.get("payTimeMin").toString();
            try {
                paramMap.put("payTimeMin",simpleDateFormat.format(dateFormat.parse(payTimeMin)));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if (paramMap.get("payTimeMax") != null && !(paramMap.get("payTimeMax").equals(""))){
            String payTimeMax = paramMap.get("payTimeMax").toString();
            try {
                paramMap.put("payTimeMax",simpleDateFormat.format(dateFormat.parse(payTimeMax)));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        List<TollCollectorReportVo> list = tollCollectorReportDao.findListData(paramMap);
        Long total = tollCollectorReportDao.countFindListData(paramMap);
        for(TollCollectorReportVo tollCollectorReportVo : list){
            TollCollectorReportVo tollVo=tollCollectorReportDao.queryTempOrderOfflineCharging(tollCollectorReportVo);
            if (tollVo != null){
                tollCollectorReportVo.setActualAmount(tollVo.getActualAmount() == null? 0:tollVo.getActualAmount());
                tollCollectorReportVo.setStrokeNumber(tollVo.getStrokeNumber() == null? 0:tollVo.getStrokeNumber());
                tollCollectorReportVo.setSpecialPay(tollVo.getSpecialPay() == null? 0:tollVo.getSpecialPay());
            }else {
                tollCollectorReportVo.setActualAmount(0d);
                tollCollectorReportVo.setStrokeNumber(0);
                tollCollectorReportVo.setSpecialPay(0d);
            }
        }
        paramMap.put("total",total);
        return list;
    }

    /**
     * 收费员线下收费报表总条数
     *
     * @param paramMap
     * @return
     */
    @Override
    public Integer findCount(Map<String, Object> paramMap) {
        Integer count = tollCollectorReportDao.findCount(paramMap);
        return count;
    }

    /**
     * 日报表
     *
     * @param paramMap
     * @return
     */
    @Override
    public List<DailyReportVo> findDailyReport(Map<String, Object> paramMap) {
        List<DailyReportVo> dailyReportVos = new ArrayList<>();
        // 查询指定月份临时订单记录
        Map<String, DailyReportVo> tempOrders = tollCollectorReportDao.findDailyTempOrder(paramMap);
        // 查询指定月份的出场记录数
        Map<String, Map<String, Long>> carOutNum = tollCollectorReportDao.findDailyCarOutNum(paramMap);
        // 查询指定月份的手动抬杆金额
        Map<String, Map<String, BigDecimal>> handLiftAmount = tollCollectorReportDao.findDailyHandLiftAmount(paramMap);
        LocalDate date = LocalDate.parse(paramMap.get("payTime") + "-01");
        LocalDate now = LocalDate.now();
        boolean isThisMonth = now.getYear() == date.getYear() && now.getMonthValue() == date.getMonthValue();
        int dayNum = isThisMonth ? now.getDayOfMonth() : date.with(TemporalAdjusters.lastDayOfMonth()).getDayOfMonth();
        if (now.getYear() < date.getYear() || (now.getYear() == date.getYear() && now.getMonthValue() < date.getMonthValue())) {
            dayNum = 0;
        }
        for (int i = dayNum; i >= 1; i--) {
            String day = i + "日";
            //某一天的出场车辆数
            long outNumber = carOutNum.containsKey(day) ? carOutNum.get(day).get("outNumber") : 0L;
            //某一天的手动抬杆金额
            double cashPayLow = handLiftAmount.containsKey(day) ? handLiftAmount.get(day).get("cashPayLow").doubleValue() : 0d;
            DailyReportVo dailyReportVo;
            if (tempOrders.containsKey(day)) {
                dailyReportVo = tempOrders.get(day);
            } else {
                dailyReportVo = new DailyReportVo(day, 0d, 0d, 0, 0d, 0d,
                        0d, 0d, 0d, 0d, 0,
                        0d, 0d, 0d, 0d, 0d,
                        0d, 0d, 0d, 0d);

            }
            dailyReportVo.setReceivable(NumberUtil.add(dailyReportVo.getReceivable() + cashPayLow));
            dailyReportVo.setRealIncome(NumberUtil.add(dailyReportVo.getRealIncome() + cashPayLow));
            dailyReportVo.setOutNumber((int) outNumber);
            dailyReportVo.setCashPayLow(cashPayLow);
            dailyReportVos.add(dailyReportVo);
        }
        DailyReportVo dailyReport = new DailyReportVo("总计", 0d, 0d, 0, 0d, 0d,
                0d, 0d, 0d, 0d, 0,
                0d, 0d, 0d, 0d, 0d,
                0d, 0d, 0d, 0d);
        for (DailyReportVo dailyReportVo : dailyReportVos) {
            Integer outNumber = dailyReportVo.getOutNumber();
            dailyReport.setOutNumber(dailyReport.getOutNumber() + (outNumber == null ? 0 : outNumber));
            Double receivable = dailyReportVo.getReceivable();
            dailyReport.setReceivable(NumberUtil.add(dailyReport.getReceivable(), (receivable == null ? 0d : receivable)));
            Double realIncome = dailyReportVo.getRealIncome();
            dailyReport.setRealIncome(NumberUtil.add(dailyReport.getRealIncome(), realIncome == null ? 0d : realIncome));
            Double cashPay = dailyReportVo.getCashPay();
            dailyReport.setCashPay(NumberUtil.add(dailyReport.getCashPay(), cashPay == null ? 0d : cashPay));
            Double gatePay = dailyReportVo.getGatePay();
            dailyReport.setGatePay(NumberUtil.add(dailyReport.getGatePay(), gatePay == null ? 0d : gatePay));
            Double balancePay = dailyReportVo.getBalancePay();
            dailyReport.setBalancePay(NumberUtil.add(dailyReport.getBalancePay(), balancePay == null ? 0d : balancePay));
            Double integralPay = dailyReportVo.getIntegralPay();
            dailyReport.setIntegralPay(NumberUtil.add(dailyReport.getIntegralPay(), integralPay == null ? 0d : integralPay));
            Double cashCouponPay = dailyReportVo.getCashCouponPay();
            dailyReport.setCashCouponPay(NumberUtil.add(dailyReport.getCashCouponPay(), cashCouponPay == null ? 0d : cashCouponPay));
            Integer cashCouponNumber = dailyReportVo.getCashCouponNumber();
            dailyReport.setCashCouponNumber(dailyReport.getCashCouponNumber() + (cashCouponNumber == null ? 0 : cashCouponNumber));
            Double specialPay = dailyReportVo.getSpecialPay();
            dailyReport.setSpecialPay(NumberUtil.add(dailyReport.getSpecialPay(), (specialPay == null ? 0d : specialPay)));
            Double cashPayLow = dailyReportVo.getCashPayLow();
            dailyReport.setCashPayLow(NumberUtil.add(dailyReport.getCashPayLow(), cashPayLow == null ? 0d : cashPayLow));
            Double discountAmount = dailyReportVo.getDiscountAmount();
            dailyReport.setDiscountAmount(NumberUtil.add(dailyReport.getDiscountAmount(), discountAmount == null ? 0d : discountAmount));
        }
        dailyReportVos.add(0, dailyReport);
        return dailyReportVos;
    }

    /**
     * 查询并插入收费员信息
     *
     * @param reportDate
     * @param parkId
     */
    @Override
    public void insertCollectorReport(String reportDate, Long parkId) {
        List<ReportCollectorReport> list = tollCollectorReportDao.findReportCollectorByParkId(parkId, reportDate);
        for (ReportCollectorReport report : list) {
            LambdaQueryWrapper<ReportCollectorReport> wrapper = new LambdaQueryWrapper();
            wrapper.eq(ReportCollectorReport::getParkId, report.getParkId()).eq(ReportCollectorReport::getCollectorId, report.getCollectorId())
                    .eq(ReportCollectorReport::getReportDate, report.getReportDate());
            if (reportCollectorReportService.selectListMP(wrapper).size() == 0) {
                report.setId(idHelper.nextId());
                report.setCreateTime(DateUtils.formartDate(new Date(), DateUtils.DATETIME_PATTERN));
                report.setReportDate(DateUtils.formartDate(DateUtils.parseStr(report.getReportDate(),DateUtils.DATETIME_PATTERN_DATE),DateUtils.DATETIME_PATTERN_DATE_NO_));
                reportCollectorReportService.insert(report);
            }
        }
    }

    /**
     * 查询最小入库时间
     *
     * @param parkId
     * @return
     */
    @Override
    public String selectMinDate(Long parkId) {
        return tollCollectorReportDao.selectMinDate(parkId);
    }


    /**
     * 查询收费员信息
     *
     * @param parkId
     * @param reportDate
     * @return
     */
    @Override
    public List<ReportCollectorReport> findReportCollectorByParkId(Long parkId, String reportDate) {
        return tollCollectorReportDao.findReportCollectorByParkId(parkId, reportDate);
    }

}
