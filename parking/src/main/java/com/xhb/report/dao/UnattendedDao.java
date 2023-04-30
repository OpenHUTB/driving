package com.xhb.report.dao;


import com.xhb.report.dto.UnattendedDTO;

import java.util.List;
import java.util.Map;

/**
 * 未出场dao
 */
public interface UnattendedDao {

    List<UnattendedDTO> findUnattended(Map<String, Object> paramMap);

    /**
     * 查询未支付记录
     *
     * @param unattendedDTO 停车场ID，车牌号, 入场时间
     * @return
     */
    List<Long> findCarcome(UnattendedDTO unattendedDTO);
}
