package com.xhb.report.service.impl;

import com.fhs.common.utils.Logger;
import com.xhb.report.dao.ParkingStatisticsDao;
import com.xhb.report.service.ParkingStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 首页报表服务
 */
@Service
public class ParkingStatisticsServiceImpl implements ParkingStatisticsService {

    private static Logger LOG = Logger.getLogger(ParkingStatisticsServiceImpl.class);
    @Autowired
    private ParkingStatisticsDao parkingStatisticsDao;

    @Override
    public List<Map<String, Object>> findCountData(String dateFull, String typeF, Long parkIdImport, String parkIds, String groupCode) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String[] weekDays = {"日", "一", "二", "三", "四", "五", "六"};
        Calendar cal = Calendar.getInstance();

        DecimalFormat df = new DecimalFormat("0.00");

        Map<String, Object> result = new HashMap();
        List<Map<String, Object>> resultList = parkingStatisticsDao.getParkIncomeCountList(dateFull, typeF, parkIdImport, parkIds, groupCode);

        List xDate = new ArrayList();//折线图x数组
        List numDate = new ArrayList();//折线图数值
        try {
            if (resultList.size() > 0) {
                for (Map<String, Object> map : resultList) {
                    Date date = sdf.parse(map.get("createTime") + "");
                    cal.setTime(date);
                    int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
                    map.put("week", weekDays[w]);
                    Double eval = 0.0;
                    if (map.get("totalTime") == null || map.get("totalNum") == null) {
                        map.put("eval", 0);
                    } else if (map.get("totalNum").toString().equals("0")) {
                        map.put("eval", 0);
                    } else {
                        eval = Double.parseDouble(map.get("totalTime").toString()) / Integer.parseInt(map.get("totalNum").toString()) / 60;
                        map.put("eval", df.format(eval));
                    }
                    //xDate.add(map.get("da")+"\n"+weekDays[w]);
                    xDate.add(map.get("createTime"));

                    numDate.add(df.format(eval));
                }
            } else {
                Map<String, Object> resultMap = new HashMap();
                result.put("code", 1);
                result.put("xDate", 0);
                result.put("numDate", 0);
                resultMap.put("resultDate", result);
                resultList.add(resultMap);
            }

        } catch (ParseException e) {
            e.printStackTrace();
            result.put("code", 2);
            result.put("data", e.getMessage());
        }
        result.put("code", 1);
        result.put("xDate", xDate);
        result.put("numDate", numDate);
        resultList.get(0).put("resultDate", result);
        return resultList;
    }

    @Override
    public Map<String, Object> findParkingFlows(String dateFull, Long parkIdImport, String parkIds, String groupCode) {
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Object> result = new HashMap();

        List<Map<String, Object>> parkReportHolidayList = parkingStatisticsDao.findParkReportHoliday(dateFull);
        Double tem = 0.0;
        try {
            //临停统计获取
            List<Map<String, Object>> temporaryList = parkingStatisticsDao.findParkingFlows(dateFull, "0", parkIdImport, parkIds, groupCode);
            List<Object> temporaryX = new ArrayList<>();//x轴数据
            List<Object> temporaryAdmission = new ArrayList<>();//入场数据
            List<Object> temporaryAppearance = new ArrayList<>();//出场数据
            List<Object> temporaryMoney = new ArrayList<>();//停车费用
            List<Object> temporaryWeek = new ArrayList<>();//星期天的数据
            int temporaryMax = 0;

            //Y轴最大数获取
            for (Map<String, Object> map : temporaryList) {
                if (Integer.parseInt(map.get("admissionSum").toString()) > Integer.parseInt(map.get("appearanceSum").toString())) {
                    if (Integer.parseInt(map.get("admissionSum").toString()) > temporaryMax) {
                        temporaryMax = Integer.parseInt(map.get("admissionSum").toString());
                    }
                } else {
                    if (Integer.parseInt(map.get("appearanceSum").toString()) > temporaryMax) {
                        temporaryMax = Integer.parseInt(map.get("appearanceSum").toString());
                    }
                }
            }

            //节假日统计
            for (Map<String, Object> map : temporaryList) {
                Date date = sdf.parse(map.get("createTime") + "");
                cal.setTime(date);
                int w = cal.get(Calendar.DAY_OF_WEEK);

                int j = 0;
                //判断X轴时间是否在节假日（补班）
                for (Map<String, Object> parkReportHoliday : parkReportHolidayList) {

                    //X轴时间在节假日（补班）时间内
                    if (sdf.parse(map.get("createTime").toString()).getTime() >= sdf.parse(parkReportHoliday.get("holidayDateStart").toString()).getTime() && sdf.parse(map.get("createTime").toString()).getTime() <= sdf.parse(parkReportHoliday.get("holidayDateEnd").toString()).getTime()) {

                        if (parkReportHoliday.get("type").toString().equals("2")) { //补班
                            temporaryWeek.add(0);
                        } else {//节假日
                            temporaryWeek.add(temporaryMax);
                        }
                        j = 1;
                    }

                }

                //X轴时间不在节假日（补班）
                if (j == 0) {
                    if (w == 1 || w == 7) {//星期天
                        temporaryWeek.add(temporaryMax);
                    } else {//正常上班
                        temporaryWeek.add(0);
                    }
                }

                temporaryX.add(map.get("createTime"));
                temporaryAdmission.add(map.get("admissionSum"));
                temporaryAppearance.add(map.get("appearanceSum"));
                tem = 0.00;
                if (map.get("cashPaySum") != null) {
                    tem = Double.parseDouble(map.get("cashPaySum").toString());
                }
                if (map.get("gatePaySum") != null) {
                    tem += Double.parseDouble(map.get("gatePaySum").toString());
                }
                temporaryMoney.add(tem);
            }


            //月租统计获取
            List<Map<String, Object>> monthlyRentList = parkingStatisticsDao.findParkingFlows(dateFull, "1", parkIdImport, parkIds, groupCode);
            List<Object> monthlyRentX = new ArrayList<>();//x轴数据
            List<Object> monthlyRentAdmission = new ArrayList<>();//入场数据
            List<Object> monthlyRentAppearance = new ArrayList<>();//出场数据
            List<Object> monthlyRentMoney = new ArrayList<>();//停车费用
            List<Object> monthlyRentWeek = new ArrayList<>();//星期天的数据

            //最大Y轴获取
            temporaryMax = 0;
            for (Map<String, Object> map : monthlyRentList) {
                if (Integer.parseInt(map.get("admissionSum").toString()) > Integer.parseInt(map.get("appearanceSum").toString())) {
                    if (Integer.parseInt(map.get("admissionSum").toString()) > temporaryMax) {
                        temporaryMax = Integer.parseInt(map.get("admissionSum").toString());
                    }
                } else {
                    if (Integer.parseInt(map.get("appearanceSum").toString()) > temporaryMax) {
                        temporaryMax = Integer.parseInt(map.get("appearanceSum").toString());
                    }
                }
            }

            //星期天统计
            for (Map<String, Object> map : monthlyRentList) {

                Date date = sdf.parse(map.get("createTime") + "");
                cal.setTime(date);
                int w = cal.get(Calendar.DAY_OF_WEEK);

                int j = 0;
                //判断X轴时间是否在节假日（补班）
                for (Map<String, Object> parkReportHoliday : parkReportHolidayList) {

                    //X轴时间在节假日（补班）时间内
                    if (sdf.parse(map.get("createTime").toString()).getTime() >= sdf.parse(parkReportHoliday.get("holidayDateStart").toString()).getTime() && sdf.parse(map.get("createTime").toString()).getTime() <= sdf.parse(parkReportHoliday.get("holidayDateEnd").toString()).getTime()) {

                        if (parkReportHoliday.get("type").toString().equals("2")) { //补班
                            monthlyRentWeek.add(0);
                        } else {//节假日
                            monthlyRentWeek.add(temporaryMax);
                        }
                        j = 1;
                    }

                }

                //X轴时间不在节假日（补班）
                if (j == 0) {
                    if (w == 1 || w == 7) {//星期天
                        monthlyRentWeek.add(temporaryMax);
                    } else {//正常上班
                        monthlyRentWeek.add(0);
                    }
                }

                monthlyRentX.add(map.get("createTime"));
                monthlyRentAdmission.add(map.get("admissionSum"));
                monthlyRentAppearance.add(map.get("appearanceSum"));
                tem = 0.00;
                if (map.get("cashPaySum") != null) {
                    tem = Double.parseDouble(map.get("cashPaySum").toString());
                }
                if (map.get("gatePaySum") != null) {
                    tem += Double.parseDouble(map.get("gatePaySum").toString());
                }
                monthlyRentMoney.add(tem);
            }


            //免费统计获取
            List<Map<String, Object>> freeAdmissionList = parkingStatisticsDao.findParkingFlows(dateFull, "2", parkIdImport, parkIds, groupCode);
            List<Object> freeAdmissionX = new ArrayList<>();//x轴数据
            List<Object> freeAdmissionAdmission = new ArrayList<>();//入场数据
            List<Object> freeAdmissionAppearance = new ArrayList<>();//出场数据
            List<Object> freeAdmissionWeek = new ArrayList<>();//星期天的数据

            //最大数统计
            temporaryMax = 0;
            for (Map<String, Object> map : freeAdmissionList) {
                if (Integer.parseInt(map.get("admissionSum").toString()) > Integer.parseInt(map.get("appearanceSum").toString())) {
                    if (Integer.parseInt(map.get("admissionSum").toString()) > temporaryMax) {
                        temporaryMax = Integer.parseInt(map.get("admissionSum").toString());
                    }
                } else {
                    if (Integer.parseInt(map.get("appearanceSum").toString()) > temporaryMax) {
                        temporaryMax = Integer.parseInt(map.get("appearanceSum").toString());
                    }
                }
            }

            //星期天统计
            for (Map<String, Object> map : freeAdmissionList) {
                Date date = sdf.parse(map.get("createTime") + "");
                cal.setTime(date);
                int w = cal.get(Calendar.DAY_OF_WEEK);
                int j = 0;
                //判断X轴时间是否在节假日（补班）
                for (Map<String, Object> parkReportHoliday : parkReportHolidayList) {

                    //X轴时间在节假日（补班）时间内
                    if (sdf.parse(map.get("createTime").toString()).getTime() >= sdf.parse(parkReportHoliday.get("holidayDateStart").toString()).getTime() && sdf.parse(map.get("createTime").toString()).getTime() <= sdf.parse(parkReportHoliday.get("holidayDateEnd").toString()).getTime()) {

                        if (parkReportHoliday.get("type").toString().equals("2")) { //补班
                            freeAdmissionWeek.add(0);
                        } else {//节假日
                            freeAdmissionWeek.add(temporaryMax);
                        }
                        j = 1;
                    }

                }

                //X轴时间不在节假日（补班）
                if (j == 0) {
                    if (w == 1 || w == 7) {//星期天
                        freeAdmissionWeek.add(temporaryMax);
                    } else {//正常上班
                        freeAdmissionWeek.add(0);
                    }
                }


                freeAdmissionX.add(map.get("createTime"));
                freeAdmissionAdmission.add(map.get("admissionSum"));
                freeAdmissionAppearance.add(map.get("appearanceSum"));
            }
            result.put("temporaryX", temporaryX);
            result.put("temporaryAdmission", temporaryAdmission);
            result.put("temporaryAppearance", temporaryAppearance);
            result.put("temporaryMoney", temporaryMoney);
            result.put("monthlyRentX", monthlyRentX);
            result.put("monthlyRentAdmission", monthlyRentAdmission);
            result.put("monthlyRentAppearance", monthlyRentAppearance);
            result.put("monthlyRentMoney", monthlyRentMoney);
            result.put("freeAdmissionX", freeAdmissionX);
            result.put("freeAdmissionAdmission", freeAdmissionAdmission);
            result.put("freeAdmissionAppearance", freeAdmissionAppearance);

            result.put("temporaryWeek", temporaryWeek);
            result.put("monthlyRentWeek", monthlyRentWeek);
            result.put("freeAdmissionWeek", freeAdmissionWeek);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public Map<String, Object> findTrafficIncome(String dateFull, Long parkIdImport, String groupCode, String parkIds) throws ParseException {

        //车流与收入分析
        Map<String, Object> resultMap = new HashMap<>();
        SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        List<Map<String, Object>> trafficIncomeList = parkingStatisticsDao.findTrafficIncome(dateFull, parkIdImport, groupCode, parkIds);
        List<String> xDate = new ArrayList<>();
        List<String> netReceipts = new ArrayList<>(); //实收
        List<String> receivable = new ArrayList<>();//应收
        List<String> temporary = new ArrayList<>();//临时
        List<String> other = new ArrayList<>();//其他
        for (Map<String, Object> trafficIncome : trafficIncomeList) {
            calendar.setTime(sDateFormat.parse(trafficIncome.get("createTime") + ""));
            int month = calendar.get(Calendar.MONTH) + 1;
            int day = calendar.get(Calendar.DATE);
            xDate.add(month + "月" + day + "日");
            receivable.add(trafficIncome.get("totalAmount") + "");
            netReceipts.add(trafficIncome.get("netReceipts") + "");
            temporary.add(trafficIncome.get("temporaryNum") + "");
            other.add(trafficIncome.get("otherNum") + "");
        }
        resultMap.put("xDate", xDate);
        resultMap.put("netReceipts", netReceipts);
        resultMap.put("receivable", receivable);
        resultMap.put("temporary", temporary);
        resultMap.put("other", other);

        //日均车流
        List<Map<String, Object>> findTrafficList = parkingStatisticsDao.findTraffic(dateFull, parkIdImport, groupCode, parkIds);
        List<String> xDateF = new ArrayList<>();
        List<String> netReceiptsF = new ArrayList<>(); //临时车（工作日）
        List<String> receivableF = new ArrayList<>();//其他车（工作日）
        List<String> temporaryF = new ArrayList<>();//临时（周末）
        List<String> otherF = new ArrayList<>();//其他（周末）
        for (Map<String, Object> findTraffic : findTrafficList) {
            if (findTraffic.get("weekNum").toString().equals("1")) {
                xDateF.add("第一周");
            } else if (findTraffic.get("weekNum").toString().equals("2")) {
                xDateF.add("第二周");
            } else if (findTraffic.get("weekNum").toString().equals("3")) {
                xDateF.add("第三周");
            } else if (findTraffic.get("weekNum").toString().equals("4")) {
                xDateF.add("第四周");
            } else {
                xDateF.add("第五周");
            }

            //第一周
            if (xDateF.size() == 1) {
                if (findTraffic.get("firstW").toString().equals("1")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 5 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 5 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                } else if (findTraffic.get("firstW").toString().equals("2")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 4 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 4 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                } else if (findTraffic.get("firstW").toString().equals("3")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 3 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 3 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                } else if (findTraffic.get("firstW").toString().equals("4")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 2 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 2 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                } else if (findTraffic.get("firstW").toString().equals("5")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 1 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 1 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                } else if (findTraffic.get("firstW").toString().equals("6")) {
                    netReceiptsF.add("0");
                    receivableF.add("0");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                } else {
                    netReceiptsF.add("0");
                    receivableF.add("0");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 1 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 1 + "");
                }
            } else if (xDateF.size() == findTrafficList.size()) {//最后一周
                if (findTraffic.get("lastW").toString().equals("1")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 1 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 1 + "");
                    temporaryF.add("0");
                    otherF.add("0");
                } else if (findTraffic.get("lastW").toString().equals("2")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 2 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 2 + "");
                    temporaryF.add("0");
                    otherF.add("0");
                } else if (findTraffic.get("lastW").toString().equals("3")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 3 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 3 + "");
                    temporaryF.add("0");
                    otherF.add("0");
                } else if (findTraffic.get("lastW").toString().equals("4")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 4 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 4 + "");
                    temporaryF.add("0");
                    otherF.add("0");
                } else if (findTraffic.get("lastW").toString().equals("5")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 5 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 5 + "");
                    temporaryF.add("0");
                    otherF.add("0");
                } else if (findTraffic.get("lastW").toString().equals("6")) {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 5 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 5 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 1 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 1 + "");
                } else {
                    netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 5 + "");
                    receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 5 + "");
                    temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                    otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
                }
            } else {//其他周
                netReceiptsF.add(Integer.parseInt(findTraffic.get("workCountL").toString()) / 5 + "");
                receivableF.add(Integer.parseInt(findTraffic.get("workCountQ").toString()) / 5 + "");
                temporaryF.add(Integer.parseInt(findTraffic.get("weekCountL").toString()) / 2 + "");
                otherF.add(Integer.parseInt(findTraffic.get("weekCountQ").toString()) / 2 + "");
            }
        }

        resultMap.put("xDateF", xDateF);
        resultMap.put("netReceiptsF", netReceiptsF);
        resultMap.put("receivableF", receivableF);
        resultMap.put("temporaryF", temporaryF);
        resultMap.put("otherF", otherF);
        return resultMap;
    }
}
