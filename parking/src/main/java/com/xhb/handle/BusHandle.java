package com.xhb.pagex.handle;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fhs.common.utils.CheckUtils;
import com.fhs.common.utils.ConverterUtils;
import com.fhs.common.utils.DateUtils;
import com.fhs.common.utils.StringUtil;
import com.fhs.pagex.service.ListExtendsHanleService;
import com.xhb.park.service.ParkMonthlyRuleService;
import com.xhb.pay.service.PayInsideRechargeService;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 不包含任务的(不查表的handl)
 */
@Component
public class BusHandle implements InitializingBean {

    @Autowired
    private ListExtendsHanleService hanleService;

    @Autowired
    private PayInsideRechargeService payInsideRechargeService;

    /**
     * 计算距离结束日期的handle
     * 根据字段所配置的日期，计算当前时间距离哪个日期有多少天
     *
     * @param fieldSett 字段配置
     * @param rows      数据
     */
    public void subDaysHandle(Map<String, Object> fieldSett, JSONArray rows) {
        if (rows.size() == 0) {
            return;
        }
        String name = ConverterUtils.toString(fieldSett.get("camelName"));
        JSONObject row = null;
        long subDays = 0l;
        //所有的内部客户id
        List<String> ids = new ArrayList<>();
        for (int i = 0; i < rows.size(); i++) {
            ids.add(rows.getJSONObject(i).getString("id"));
        }
        //充值过的内部客户id
        List<Long> idsList = payInsideRechargeService.isRecharge(StringUtil.getStrToIn(ids));
        for (int i = 0; i < rows.size(); i++) {
            row = rows.getJSONObject(i);
            String monthlyType = row.getString("monthlyType");
            //存在就充值过
            if (idsList.contains(row.getLong("id"))) {
                row.getJSONObject("transMap").put("isRecharge", "是");
            } else {
                row.getJSONObject("transMap").put("isRecharge", "否");
            }
            //是月租 并且 有结束日期 才有剩余天数
            if (CheckUtils.isNotEmpty(row.getString(name)) && (ParkMonthlyRuleService.MONTHLY_TYPE_ALLDAY.equals(monthlyType) || ParkMonthlyRuleService.MONTHLY_TYPE_DAYTIME.equals(monthlyType)
                    || ParkMonthlyRuleService.MONTHLY_TYPE_NIGHT.equals(monthlyType))) {
                subDays = DateUtils.getSubDasy(DateUtils.parseStr(row.getString(name), DateUtils.DATETIME_PATTERN_DATE), new Date());
                if (subDays > 0) {
                    row.getJSONObject("transMap").put("subDays", subDays + "天");
                } else if (subDays == 0) {
                    row.getJSONObject("transMap").put("subDays", "今天到期");
                } else {
                    row.getJSONObject("transMap").put("subDays", "已到期");
                }
            } else {
                row.getJSONObject("transMap").put("subDays", "无");
            }
        }
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        hanleService.registerHandle("subDays", this::subDaysHandle);
    }

}
