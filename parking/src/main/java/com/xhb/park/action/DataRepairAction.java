package com.xhb.park.action;


import com.fhs.common.utils.DateUtils;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.result.HttpResult;
import com.xhb.park.service.DataRepairService;
import com.xhb.park.vo.DataRepairVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ms/data_repair")
public class DataRepairAction {

    @Autowired
    DataRepairService dataRepairService;

    /**
     * 根据车场id数据下发
     */
    @RequestMapping("repairAllData")
    public HttpResult<Boolean> repairAllData(@RequestParam(value = "parkId") Long parkId) {
        ParamChecker.isNotNull(parkId, "parkId不能为空");
        dataRepairService.repairAllData(parkId);
        return HttpResult.success(true);
    }

    /**
     * 根据车场id,表名,起止时间数据下发
     */
    @RequestMapping("repairDataByCondition")
    @ResponseBody
    public HttpResult<Boolean> repairDataByCondition(@RequestBody List<DataRepairVO> dataRepairVOList, Long parkId) {
        ParamChecker.isNotNull(parkId, "parkId不能为空");
        dataRepairService.repairData(dataRepairVOList, parkId);
        return HttpResult.success(true);
    }


    @GetMapping("getTableList")
    public List<DataRepairVO> getTableList(){
        List<Map<String, String>> tblSett = dataRepairService.getTblSett();
        List<DataRepairVO> dataRepairVOList = new ArrayList<>();
        for (Map<String, String> stringStringMap : tblSett) {
            DataRepairVO dataRepairVO = new DataRepairVO();
            dataRepairVO.setTableName(stringStringMap.get("tableName"));
            dataRepairVO.setTitle(stringStringMap.get("title"));
            dataRepairVO.setIsBigger(stringStringMap.get("isBigger"));
            if ("true".equals(stringStringMap.get("isBigger"))){
                LocalDateTime now = LocalDateTime.now();
                now = now.minus(90, ChronoUnit.DAYS);
                dataRepairVO.setStaData(new SimpleDateFormat(DateUtils.DATETIME_PATTERN_DATE).format(DateUtils.parseStr(now.toString(),DateUtils.DATETIME_PATTERN_DATE)));
                dataRepairVO.setEndData(new SimpleDateFormat(DateUtils.DATETIME_PATTERN_DATE).format(new Date()));
            }
            dataRepairVOList.add(dataRepairVO);
        }
        return dataRepairVOList;
    }



}
