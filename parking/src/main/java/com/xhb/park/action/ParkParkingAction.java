package com.xhb.park.action;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fhs.base.action.ModelSuperAction;
import com.fhs.common.constant.Constant;
import com.fhs.common.utils.IdHelper;
import com.fhs.common.utils.JsonUtils;
import com.fhs.core.log.LogDesc;
import com.fhs.core.result.HttpResult;
import com.fhs.ucenter.api.vo.SysUserVo;
import com.mybatis.jpa.context.DataPermissonContext;
import com.xhb.park.bean.ParkParking;
import com.xhb.park.service.ParkParkingService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 停车场控制器
 */
@RestController
@RequestMapping("/ms/parking")
public class ParkParkingAction extends ModelSuperAction<ParkParking> {

    @Autowired
    private ParkParkingService parkParkingService;

    @Autowired
    protected IdHelper idHelper;

    /**
     * 获取停车场下拉列表接口--只返回name和id 支持jsonp
     * @param request
     * @param response
     */
    @RequestMapping("getParkParkingList")
    public void getParkParkingList(ParkParking e,HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> paramMap = super.getPageTurnNum(request);
        paramMap.put("groupCode", super.getSessionuser(request).getGroupCode());
        paramMap.put("parkIds", DataPermissonContext.getDataPermissonMap().get("parkIds"));
        LambdaQueryWrapper<ParkParking> wrapper = new LambdaQueryWrapper<>(e);
        wrapper.eq(ParkParking::getGroupCode, super.getSessionuser(request).getGroupCode());
        if(DataPermissonContext.getDataPermissonMap().get("parkIds")!=null){
            List<String> parkIds = Arrays.asList(DataPermissonContext.getDataPermissonMap().get("parkIds").split(","));
            wrapper.in(ParkParking::getParkId,parkIds);
        }
        wrapper.select(ParkParking::getParkId,ParkParking::getParkName);
        List<ParkParking> parkParkinglist = parkParkingService.selectListMP(wrapper);
        outJsonp(JsonUtils.list2json(parkParkinglist), response, request);
    }



    /**
     * 所有的停车场 用于商户信息配置和公众号配置
     *
     * @return 获取所有的停车场
     */
    @RequestMapping("getParkList")
    public List<ParkParking> getParkList() {
        LambdaQueryWrapper<ParkParking> lambdaQueryWrapper = new LambdaQueryWrapper<>();
        return parkParkingService.selectListMP(lambdaQueryWrapper);
    }

    @RequestMapping("save")
    @LogDesc(value = "添加", type = LogDesc.ADD)
    @RequiresPermissions("parking:add")
    public HttpResult<Boolean> save(ParkParking parkParking, HttpServletRequest request){
        SysUserVo sysUserVo = (SysUserVo) request.getSession().getAttribute(Constant.SESSION_USER);
        parkParking.preInsert(sysUserVo.getUserId());
        parkParking.setParkId(idHelper.nextId());
        parkParking.setGroupCode(sysUserVo.getGroupCode());
        parkParkingService.insert(parkParking);
        return HttpResult.success(true);
    }
}
