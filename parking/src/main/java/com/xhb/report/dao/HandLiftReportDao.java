package com.xhb.report.dao;

import com.xhb.report.dto.HandLiftReportDTO;
import com.xhb.report.vo.DailyReportVo;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 手动抬杆
 *
 * @author wangjie
 * @Date 2019/6/21 14:12
 * </per>
 */
@Repository
public interface HandLiftReportDao {

    DailyReportVo findHandLiftAmount(Map<String, Object> param);

    List<HandLiftReportDTO> findHandLiftDate(Map<String, Object> param);
}
