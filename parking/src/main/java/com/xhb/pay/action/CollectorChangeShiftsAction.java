package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.CollectorChangeShifts;
import com.xhb.pay.service.CollectorChangeShiftsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * (ParkPayMch)表控制层
 *
 * @author jackwong
 * @since 2019-03-04 10:22:10
 */
@RestController
@RequestMapping("/ms/CollectorChangeShifts")
public class CollectorChangeShiftsAction extends ModelSuperAction<CollectorChangeShifts> {

    @Autowired
    private CollectorChangeShiftsService collectorChangeShiftsService;

    /**
     * 下班报表
     *
     * @return
     */
    @RequestMapping("/workReport")
    public HttpResult workReport(Long id) {
        CollectorChangeShifts collectorChangeShifts = collectorChangeShiftsService.selectById(id);
        return HttpResult.success(collectorChangeShiftsService.workReport(collectorChangeShifts));
    }

}
