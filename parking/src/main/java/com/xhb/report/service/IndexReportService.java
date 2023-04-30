package com.xhb.report.service;

import com.xhb.report.vo.IndexReportParkComeLineVO;

import java.util.Map;

/**
 * 首页报表服务
 */

public interface IndexReportService {


    /**
     * 获取首页的折线图vo
     *
     * @param parkIds 停车场id集合
     * @param preDays 往前推多少天
     * @return vo
     */
    IndexReportParkComeLineVO getIndexReportParkComeLineVO(String parkIds, int preDays);

    /**
     * 获取主页统计信息
     *
     * @return
     */
    Map<String, Object> findCountData(String parkIds);
}
