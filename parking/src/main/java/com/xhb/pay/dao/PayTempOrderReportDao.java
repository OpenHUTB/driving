package com.xhb.pay.dao;

import com.xhb.pay.dto.PayTempOrderDTO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 临时订单导出
 */
@Repository
public interface PayTempOrderReportDao {
    /**
     * 临时订单列表查询
     *
     * @param paramMap
     * @return
     */
    List<PayTempOrderDTO> findPayTempOrderList(Map<String, Object> paramMap);

    /**
     * 临时订单统计
     *
     * @param paramMap
     * @return
     */
    int findPayTempOrderCount(Map<String, Object> paramMap);

}
