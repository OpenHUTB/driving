package com.xhb.report.service.impl;

import com.fhs.common.utils.Logger;
import com.xhb.pay.dao.PayCarcomeDao;
import com.xhb.report.service.AdmissionReportService;
import com.xhb.report.vo.AdmissionReportParkComeLineVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 停车场出入场记录报表服务 parking_statistics.html
 */
@Service
public class AdmissionReportServiceImpl implements AdmissionReportService {
    private static Logger LOG = Logger.getLogger(AdmissionReportServiceImpl.class);

    @Autowired
    private PayCarcomeDao payCarcomeDao;    //进出信息表

    @Override
    public AdmissionReportParkComeLineVO findCountDate(Map<String, Object> paramMap) {
        List<Map<String, Object>> resultList = payCarcomeDao.findByTypeAndDate(paramMap);
        List<String> dateList = new ArrayList<>();
        List<Object> enter = new ArrayList<>();
        List<Object> out = new ArrayList<>();
        for (Map m : resultList) {
            dateList.add(m.get("LEFT(create_time,10)").toString());
            enter.add(m.get("enter"));
            out.add(m.get("out"));
        }
        List<AdmissionReportParkComeLineVO.OneParkData> admissionList = new ArrayList<>();

        AdmissionReportParkComeLineVO admissionReportParkComeLineVO = new AdmissionReportParkComeLineVO();
        List<String> list = new ArrayList<>();
        list.add("入场");
        list.add("出场");
        for (int i = 0; i < list.size(); i++) {
            AdmissionReportParkComeLineVO.OneParkData oneAdmissionData = new AdmissionReportParkComeLineVO.OneParkData();
            oneAdmissionData.name = list.get(i);
            if ("入场".equals(oneAdmissionData.name)) {
                oneAdmissionData.data = enter;
                oneAdmissionData.type = "line";
            } else {
                oneAdmissionData.data = out;
                oneAdmissionData.type = "line";
            }
            admissionList.add(oneAdmissionData);
        }
        admissionReportParkComeLineVO.setAdmissionList(list);
        admissionReportParkComeLineVO.setDateList(dateList);
        admissionReportParkComeLineVO.setParkDataList(admissionList);
        return admissionReportParkComeLineVO;
    }

    @Override
    public AdmissionReportParkComeLineVO findCountDay(Map<String, Object> paramMap) {
        List<Map<String, Object>> resultList = payCarcomeDao.findByTypeAndDay(paramMap);
        List<String> dateList = new ArrayList<>();
        List<Object> enter = new ArrayList<>();
        List<Object> out = new ArrayList<>();
        for (Map m : resultList) {
            dateList.add(m.get("SUBSTRING(create_time, 12,2)").toString() + ":00");
            enter.add(m.get("enter"));
            out.add(m.get("out"));
        }

        List<AdmissionReportParkComeLineVO.OneParkData> admissionList = new ArrayList<>();

        AdmissionReportParkComeLineVO admissionReportParkComeLineVO = new AdmissionReportParkComeLineVO();
        List<String> list = new ArrayList<>();
        list.add("入场");
        list.add("出场");
        for (int i = 0; i < list.size(); i++) {
            AdmissionReportParkComeLineVO.OneParkData oneAdmissionData = new AdmissionReportParkComeLineVO.OneParkData();
            oneAdmissionData.name = list.get(i);
            if ("入场".equals(oneAdmissionData.name)) {
                oneAdmissionData.data = enter;
                oneAdmissionData.yAxisIndex = 0;
                oneAdmissionData.type = "line";
            } else if ("出场".equals(oneAdmissionData.name)) {
                oneAdmissionData.data = out;
                oneAdmissionData.yAxisIndex = 0;
                oneAdmissionData.type = "line";
            }
            admissionList.add(oneAdmissionData);
        }
        admissionReportParkComeLineVO.setAdmissionList(list);
        admissionReportParkComeLineVO.setDateList(dateList);
        admissionReportParkComeLineVO.setParkDataList(admissionList);
        return admissionReportParkComeLineVO;
    }

    @Override
    public Map<String, Object> findOutEnterCount(Map<String, Object> paramMap) {
        return payCarcomeDao.findOutEnterCount(paramMap);
    }

}
