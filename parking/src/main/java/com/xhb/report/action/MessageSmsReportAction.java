package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.ExcelExportTools;
import com.fhs.core.page.Pager;
import com.xhb.report.dto.MessageSmsDTO;
import com.xhb.report.service.MessageSmsReportService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * <per>
 * 短信通知报表
 *
 * @author wangjie
 * @Date 2019/6/10 10:20
 * </per>
 */
@RestController
@RequestMapping("/ms/messageSmsReport")
public class MessageSmsReportAction extends ModelSuperAction<MessageSmsDTO> {

    @Autowired
    private MessageSmsReportService messageSmsService;

    /**
     * 短信通知报表
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping("/messageSmsReportList")
    @RequiresPermissions("message_sms:see")
    public Object messageSmsReportList(HttpServletRequest request, HttpServletResponse response) {

        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        List<MessageSmsDTO> rows = messageSmsService.findSmsListData(paramMap);
        paramMap.put("start", null);
        int total = messageSmsService.findSmsListData(paramMap).size();
        Pager<MessageSmsDTO> pager = new Pager<>(total, rows);
        return pager;
    }

    /**
     * 导出短信通知报表
     *
     * @param request
     * @param response
     */
    @RequestMapping("/messageSmsReportExcel")
    @RequiresPermissions("message_sms:see")
    public void messageSmsReportExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        List<MessageSmsDTO> messageSmsDTOList = messageSmsService.findSmsListData(paramMap);
        for (MessageSmsDTO messageSmsDTO : messageSmsDTOList) {
            messageSmsDTO.setMessageType(messageSmsDTO.getTransMap().get("messageType"));
        }
        ExcelExportTools.exportExcel(messageSmsDTOList, request, response);
    }


}
