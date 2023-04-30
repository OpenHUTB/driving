package com.xhb.report.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.ExcelExportTools;
import com.fhs.common.utils.CheckUtils;
import com.fhs.core.page.Pager;
import com.fhs.core.result.HttpResult;
import com.fhs.core.trans.TransService;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import com.xhb.pay.bean.PaySpecialPass;
import com.xhb.pay.dto.PaySpecialPassDTO;
import com.xhb.pay.service.PaySpecialPassService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/ms/pay_special_pass")
public class PaySpecialPassAction extends ModelSuperAction<PaySpecialPass> {

    @Autowired
    private PaySpecialPassService paySpecialPassService;

    @Autowired
    private TransService transService;

    /**
     * 特殊放行记录分页查询
     *
     * @param request
     * @param response
     * @return
     */

    @RequestMapping("/findPager")
    @RequiresPermissions("pay_special_pass:see")
    public Pager<PaySpecialPass> findPager(HttpServletRequest request, HttpServletResponse response) {
        Map param = getParamMap(request);
        List<PaySpecialPassDTO> page = paySpecialPassService.findPage(param);
        transService.transMore(page);
        int count = paySpecialPassService.getCount(param);
        return new Pager(count, page);
    }

    /**
     * 特殊放行记录导出
     *
     * @param request
     * @param response
     */
    @RequestMapping({"exportPassExcel"})
    @RequiresPermissions("pay_special_pass:see")
    public void exportReportExcel(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = (Map<String, Object>) request.getSession().getAttribute(this.getClass().getName() + "preLoadParam");
        paramMap.put("end", null);
        List<PaySpecialPassDTO> dataList = paySpecialPassService.findPage(paramMap);
        transService.transMore(dataList);
        ExcelExportTools.exportExcel(dataList, request, response);
    }

    /**
     * 获取request中的过滤条件
     *
     * @param request
     * @return
     */

    private Map<String, Object> getParamMap(HttpServletRequest request) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        paramMap.put("sortTzw", formartOrderBy(request));
        request.getSession().setAttribute(this.getClass().getName() + "preLoadParam", paramMap);
        return paramMap;
    }
}
