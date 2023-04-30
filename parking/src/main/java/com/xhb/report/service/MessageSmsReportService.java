package com.xhb.report.service;

import com.fhs.core.base.service.BaseService;
import com.xhb.report.dto.MessageSmsDTO;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 短信通知报表
 *
 * @author wangjie
 * @Date 2019/6/10 10:14
 * </per>
 */
public interface MessageSmsReportService extends BaseService<MessageSmsDTO> {


    /**
     * 短信报表通知列表查询
     *
     * @param paramMap
     * @return
     */
    List<MessageSmsDTO> findSmsListData(Map<String, Object> paramMap);
}
