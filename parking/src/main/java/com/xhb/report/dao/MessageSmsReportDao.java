package com.xhb.report.dao;

import com.xhb.report.dto.MessageSmsDTO;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 短信通知报表
 *
 * @author wangjie
 * @Date 2019/6/10 10:16
 * </per>
 */
public interface MessageSmsReportDao {

    List<MessageSmsDTO> findSmsListData(Map<String, Object> paramMap);

}
