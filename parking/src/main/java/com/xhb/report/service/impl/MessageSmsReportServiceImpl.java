package com.xhb.report.service.impl;

import com.fhs.core.base.service.impl.BaseServiceImpl;
import com.fhs.core.trans.TransService;
import com.xhb.report.dao.MessageSmsReportDao;
import com.xhb.report.dto.MessageSmsDTO;
import com.xhb.report.service.MessageSmsReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * <per>
 * 短信通知报表
 *
 * @author wangjie
 * @Date 2019/6/10 10:18
 * </per>
 */
@Service("messageSmsReportService")
public class MessageSmsReportServiceImpl extends BaseServiceImpl<MessageSmsDTO> implements MessageSmsReportService {

    @Autowired
    private MessageSmsReportDao messageSmsDao;

    @Autowired
    private TransService transService;

    /**
     * 短信报表通知列表查询
     *
     * @param paramMap
     * @return
     */
    @Override
    public List<MessageSmsDTO> findSmsListData(Map<String, Object> paramMap) {
        List<MessageSmsDTO> messageSmsDtoList = messageSmsDao.findSmsListData(paramMap);
        transService.transMore(messageSmsDtoList);
        return messageSmsDtoList;
    }
}
