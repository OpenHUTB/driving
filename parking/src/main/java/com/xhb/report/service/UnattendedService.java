package com.xhb.report.service;

import com.xhb.report.dto.UnattendedDTO;

import java.util.List;
import java.util.Map;

public interface UnattendedService {
    /**
     * 未出场列表查询
     *
     * @param paramMap
     * @return
     */
    List<UnattendedDTO> findUnattended(Map<String, Object> paramMap);

    /**
     * 修改选中车牌为已支付
     *
     * @param unattendedDTO 停车场 车牌 accessTime
     */
    void carOut(UnattendedDTO unattendedDTO);
}
