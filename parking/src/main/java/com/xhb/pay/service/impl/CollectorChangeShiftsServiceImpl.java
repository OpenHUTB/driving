package com.xhb.pay.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.db.DataSource;
import com.xhb.park.service.ParkParkingService;
import com.xhb.park.service.UcenterTollCollectorService;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.pay.dao.PayHandLiftRodDao;
import com.xhb.pay.dao.PaySpecialPassDao;
import com.xhb.pay.dao.PayTempOrderHistoryDao;
import com.xhb.pay.service.CollectorChangeShiftsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

/**
 * 交接班(CollectorChangeShifts)表服务实现类
 *
 * @author jack_wang(wl)
 * @since 2019-08-05 10:56:47
 */
@Service("collectorChangeShiftsService")
@DataSource("park")
public class CollectorChangeShiftsServiceImpl extends BaseServiceImpl<CollectorChangeShifts> implements CollectorChangeShiftsService {

    //手动抬杆
    @Autowired
    private PayHandLiftRodDao payHandLiftRodDao;

    //特殊放行
    @Autowired
    private PaySpecialPassDao paySpecialPassDao;

    @Autowired
    private ParkParkingService parkParkingService;

    @Autowired
    private UcenterTollCollectorService ucenterTollCollectorService;


    @Autowired
    private PayTempOrderHistoryDao payTempOrderHistoryDao;


    @Override
    public Map<String, Object> workReport(CollectorChangeShifts collectorChangeShifts) {
        Map<String, Object> resultMap = new HashMap<>();
        //收费总金额
        Map<String, Object> tempOrdetrMap = payTempOrderHistoryDao.findTempOrderByCashPayByTime(collectorChangeShifts);
        resultMap.put("tempOrdetrCashPay", tempOrdetrMap.get("amount"));
        resultMap.put("tempOrderCount", tempOrdetrMap.get("count"));
        //手动抬杆总金额
        Map<String, Object> payHandLiftRodMap = payHandLiftRodDao.findPayHandLiftRodAmountByTime(collectorChangeShifts);
        resultMap.put("payHandLiftRodAmount", payHandLiftRodMap.get("amount"));
        resultMap.put("payHandLiftRodCount", payHandLiftRodMap.get("count"));
        //特殊放行总金额
        Map<String, Object> paySpecialPassMap = paySpecialPassDao.findPaySpecialPassAmountByTime(collectorChangeShifts);
        resultMap.put("paySpecialPassAmount", paySpecialPassMap.get("amount"));
        resultMap.put("paySpecialPassCount", paySpecialPassMap.get("count"));
        //减免分类
        Map<String, Object> reliefTypeMap = payTempOrderHistoryDao.findTempOrderByDiscountAmountByTime(collectorChangeShifts);
        resultMap.put("reliefTypeAmount", reliefTypeMap.get("amount"));
        resultMap.put("reliefTypeCount", reliefTypeMap.get("count"));
        //减免分类信息
        resultMap.put("reliefTypeReport", payTempOrderHistoryDao.findReliefTypeByCollectorId(collectorChangeShifts));
        //特殊放行信息
        resultMap.put("paySpecialPassReport", paySpecialPassDao.findPaySpecialPassByCollectorId(collectorChangeShifts));
        //收银员信息
        resultMap.put("collectorChangeShifts", collectorChangeShifts);
        resultMap.put("collectorName", ucenterTollCollectorService.findBeanById(collectorChangeShifts.getCollectorId()).getName());
        //停车场名称
        resultMap.put("parkName", parkParkingService.findBeanById(collectorChangeShifts.getParkId()).getParkName());
        return resultMap;
    }



}
