package com.xhb.pay.action;

import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.utils.JsonUtils;
import com.fhs.common.utils.Logger;
import com.fhs.core.exception.ParamChecker;
import com.fhs.core.group.Add;
import com.fhs.core.group.Update;
import com.fhs.core.log.LogDesc;
import com.fhs.core.result.HttpResult;
import com.xhb.pay.bean.PayInsidePlateBind;
import com.xhb.pay.service.PayInsidePlateBindService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 内部车和车牌号绑定记录(PayInsidePlateBind)表控制层
 *
 * @author makejava
 * @since 2019-05-23 13:50:50
 */
@RestController
@RequestMapping("/ms/pay_inside_plate_bind")
public class PayInsidePlateBindAction extends ModelSuperAction<PayInsidePlateBind> {

    private static final Logger LOG = Logger.getLogger(PayInsidePlateBindAction.class);

    @Autowired
    private PayInsidePlateBindService payInsidePlateBindService;


    @RequestMapping("/plateBindAdd")
    @LogDesc(value = "添加", type = LogDesc.ADD)
    @RequiresPermissions("pay_inside_plate_bind:update")
    public HttpResult<Boolean> add(@Validated(Add.class) PayInsidePlateBind payInsidePlateBind, HttpServletRequest request, HttpServletResponse response) {
        payInsidePlateBind.preInsert(getSessionuser(request).getUserId());
        payInsidePlateBind.setGroupCode(getSessionuser(request).getGroupCode());
        payInsidePlateBindService.insertPlateBind(payInsidePlateBind);
        return HttpResult.success(true);
    }


    @RequestMapping("/plateBindUpdate")
    @LogDesc(value = "更新", type = LogDesc.UPDATE)
    @RequiresPermissions("pay_inside_plate_bind:update")
    public HttpResult update(@Validated(Update.class) PayInsidePlateBind payInsidePlateBind, HttpServletRequest request, HttpServletResponse response) {
        payInsidePlateBind.preInsert(getSessionuser(request).getUserId());
        payInsidePlateBind.setGroupCode(getSessionuser(request).getGroupCode());
        payInsidePlateBindService.updatePlateBind(payInsidePlateBind);
        return HttpResult.success();
    }

    @RequestMapping("/plateBindDel/{id}")
    @LogDesc(value = "删除", type = LogDesc.DEL)
    @RequiresPermissions("pay_inside_plate_bind:update")
    public HttpResult del(@PathVariable("id") Long id, HttpServletRequest request) {
        payInsidePlateBindService.deletePlateBind(id);
        return HttpResult.success();
    }

}
