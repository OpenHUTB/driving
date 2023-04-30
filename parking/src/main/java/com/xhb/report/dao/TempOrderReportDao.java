package com.xhb.report.dao;

import com.xhb.report.dto.PayTempOrderExportDTO;
import com.xhb.report.vo.DailyReportVo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 临时订单导出信息
 *
 * @author wangjie
 * @Date 2019/5/31 16:42
 * </per>
 */
@Repository
public interface TempOrderReportDao {

    DailyReportVo findMonthData(Map<String, Object> paramMap);

    List<PayTempOrderExportDTO> findPayTempOrderData(@Param("parkId") Long parkId,
                                                     @Param("payTime") String payTime,
                                                     @Param("pageNo") Integer pageNo,
                                                     @Param("pageIndex") Integer pageIndex);

    Long findTempCount(Map<String, Object> paramMap);
}
