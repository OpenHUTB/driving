package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.PayInsideCar;
import com.xhb.pay.service.PayInsideCarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * 内部客户管理(PayInsideCar)表控制层
 *
 * @author makejava
 * @since 2019-05-22 10:12:37
 */
@RestController
@RequestMapping("/ms/pay_inside_car")
public class PayInsideCarAction extends ModelSuperAction<PayInsideCar> {

    @Autowired
    private PayInsideCarService payInsideCarService;

    /**
     * 批量导入
     *
     * @param request
     * @param file    内部客户信息文件
     * @returnH
     */
    @RequestMapping("/batchImport")
    public HttpResult<Boolean> batchImport(HttpServletRequest request, @RequestParam("file") MultipartFile file) {
        String sysUserId = super.getSessionuser(request).getUserId();
        Map<String, String> paramMap = new HashMap<>();
        paramMap.put("sysUserId", sysUserId);
        paramMap.put("parkId", request.getParameter("parkId"));
        paramMap.put("groupCode", getSessionuser(request).getGroupCode());
        return HttpResult.success(payInsideCarService.batchImport(paramMap, file));
    }

}
