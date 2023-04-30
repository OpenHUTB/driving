package com.xhb.pay.dao;

import com.fhs.core.base.dao.BaseDao;
import com.mybatis.jpa.annotation.MapperDefinition;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.pay.bean.PayTempOrderHistory;
import com.xhb.pay.dto.PayTempOrderDTO;
import com.xhb.pay.form.PayTempOrderForm;
import com.xhb.pay.vo.ParkReliefTypeVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Repository
@MapperDefinition(domainClass = PayTempOrderHistory.class, orderBy = " update_time DESC")
public interface PayTempOrderHistoryDao extends BaseDao<PayTempOrderHistory>  {

    /**
     * 查询临时订单列表
     */
    List<PayTempOrderDTO> queryTempOrderPage(PayTempOrderForm payTempOrderForm);
    List<PayTempOrderDTO> findPayTempOrderList(Map<String, Object> paramMap);

    /*
     * 临时订单统计
     *
     * @param paramMap
     * @return
     */
    int findPayTempOrderCount(Map<String, Object> paramMap);

    /**
     * 查询临时订单详情
     */
    PayTempOrderDTO queryTempOrder(Long id);

    /**
     * 获取收费员 现金支付金额和数量
     *
     * @param collectorChangeShifts id, 上班时间,下班时间
     * @return
     */
    Map<String, Object> findTempOrderByCashPayByTime(CollectorChangeShifts collectorChangeShifts);

    /**
     * 获取收费员 减免分类金额和数量
     *
     * @param collectorChangeShifts
     * @return
     */
    Map<String, Object> findTempOrderByDiscountAmountByTime(CollectorChangeShifts collectorChangeShifts);

    /**
     * 获取收费员 减免分类的名称，张数，金额
     *
     * @param collectorChangeShifts id, 上班时间,下班时间
     * @return
     */
    List<ParkReliefTypeVo> findReliefTypeByCollectorId(CollectorChangeShifts collectorChangeShifts);


}
