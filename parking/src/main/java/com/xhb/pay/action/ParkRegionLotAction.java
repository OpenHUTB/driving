package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.result.HttpResult;
import com.xhb.park.bean.ParkRegionLot;
import com.xhb.park.service.ParkRegionLotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;


/**
 * (ParkRegionLot)表控制层
 *
 * @author makejava
 * @since 2019-05-24 10:42:43
 */
@RestController
@RequestMapping("/ms/parkRegionLot")
public class ParkRegionLotAction extends ModelSuperAction<ParkRegionLot> {

    @Autowired
    private ParkRegionLotService parkRegionLotService;

    /**
     * 批量导入
     *
     * @param request
     * @param file    车位号信息文件
     * @returnH
     */
    @RequestMapping("/batchImport")
    public HttpResult<Boolean> batchImport(HttpServletRequest request, @RequestParam("file") MultipartFile file) {
        String sysUserId = super.getSessionuser(request).getUserId();
        Map<String, String> paramMap = new HashMap<>();
        paramMap.put("sysUserId", sysUserId);
        paramMap.put("parkId", request.getParameter("parkId"));
        paramMap.put("regionId", request.getParameter("regionId"));
        paramMap.put("groupCode", getSessionuser(request).getGroupCode());
        return HttpResult.success(parkRegionLotService.batchImport(paramMap, file));
    }

}
