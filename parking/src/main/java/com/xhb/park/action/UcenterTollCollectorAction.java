package com.xhb.park.action;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.common.utils.JsonUtils;
import com.fhs.core.base.action.BaseAction;
import com.xhb.park.bean.UcenterTollCollector;
import com.xhb.park.service.UcenterTollCollectorService;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 线下收费人员控制器
 */
@RestController
@RequestMapping("/ms/ucenter_toll_collector")
public class UcenterTollCollectorAction extends BaseAction {

    @Autowired
    private UcenterTollCollectorService ucenterTollCollectorService;

    /**
     * 报表服务线下收费人员列表
     *
     * @param parkId   停车场id
     * @param request
     * @param response
     */
    @RequestMapping("getUcenterList")
    public void getUcenterList(Long parkId, HttpServletRequest request, HttpServletResponse response) {
        List<UcenterTollCollector> ucenterTollCollectorlist = null;
        if (parkId == null) {
            ucenterTollCollectorlist = ucenterTollCollectorService.select();
        } else {
            LambdaQueryWrapper<UcenterTollCollector> lambdaQueryWrapper = new LambdaQueryWrapper<>();
            lambdaQueryWrapper.eq(UcenterTollCollector::getParkId, parkId);
            ucenterTollCollectorlist = ucenterTollCollectorService.selectListMP(lambdaQueryWrapper);
        }
        List<Map<String, Object>> list = new ArrayList<>();
        if (CollectionUtils.isNotEmpty(ucenterTollCollectorlist)) {
            for (UcenterTollCollector ucenterTollCollector : ucenterTollCollectorlist) {
                Map<String, Object> map = new HashMap<>();
                map.put("collectorId", ucenterTollCollector.getCollectorId() + "");
                map.put("name", ucenterTollCollector.getName());
                list.add(map);
            }
        }
        outJsonp(JsonUtils.list2json(list), response, request);
    }
}
